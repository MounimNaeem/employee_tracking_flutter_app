import 'dart:async';
import 'package:action_slider/action_slider.dart';
import 'package:employee_location_tracking_app/screens/employee_dashboard/services/employee_services.dart';
import 'package:employee_location_tracking_app/services/shared_prefs_service.dart';
import 'package:employee_location_tracking_app/utils/static_info/static_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

final employeeProvider = ChangeNotifierProvider((ref) => EmployeeNotifier());

class EmployeeNotifier extends ChangeNotifier {
  final _locationService = EmployeeService();
  GoogleMapController? mapController;
  Timer? _locationTimer;
  // StreamSubscription<Position>? _locationSubscription;

  bool isOnline = false;
  // bool get isOnline => _isOnline;
  bool _isShiftActive = false;
  bool get isShiftActive => _isShiftActive;
  bool isLoading = false;

  CameraPosition? initialCameraPosition;
  Set<Marker> markers = {};

  ActionSliderController actionSliderController = ActionSliderController();

  Future<void> providerInit() async {
    isOnline = await SharedPrefsService().getisUserOnline();
    getCurrentLocation();
  }

  Future<void> toggleOnlineStatus() async {
    try {
      if (isOnline) {
        isOnline = !isOnline;
        await endShift();
      } else {
        isOnline = !isOnline;
        await startShift();
      }

      await _locationService.updateEmployeeActiveStatusInUserDoc(isOnline);

      await SharedPrefsService().setisUserOnline(isOnline);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Check and request location permissions
  Future<bool> checkAndRequestPermissions() async {
    if (await Permission.location.isGranted) {
      return true;
    }

    final status = await Permission.location.request();
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      print("Location permissions are denied.");
      return false;
    } else if (status.isPermanentlyDenied) {
      print(
          "Location permissions are permanently denied. Opening app settings.");
      await openAppSettings();
      return false;
    }
    return false;
  }

  /// Start the employee shift and location tracking
  Future<void> startShift() async {
    // if (_isShiftActive) return;

    final hasPermission = await checkAndRequestPermissions();
    if (!hasPermission) {
      throw Exception("Location permission not granted.");
    }

    notifyListeners();

    // Start periodic location tracking (every 30 minutes)
    await _updateLocation(); // Initial update
    _startPeriodicLocationTracking();
  }

  /// Stop the employee shift and location tracking
  Future<void> endShift() async {
    await _updateLocation();
    _stopPeriodicLocationTracking();
    // _locationSubscription?.cancel();
    notifyListeners();
  }

  /// Start periodic location tracking (every 30 minutes)
  void _startPeriodicLocationTracking() {
    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      print('timer running');
      _updateLocation();
    });
  }

  /// Stop periodic location tracking
  void _stopPeriodicLocationTracking() {
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  /// Update location and store in history
  Future<void> _updateLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();
      final userId = StaticInfo.userModel?.userId ?? '-1';

      /// Convert latitude and longitude to address
      final address = await _getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      // Update location in database
      await _locationService.updateLiveLocation(
          userId, position, address, isOnline);
      await _locationService.storeLocationHistory(
          userId, position, address, isOnline);

      // Update Google Map marker and camera position
      final latLng = LatLng(position.latitude, position.longitude);
      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: latLng,
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
      );

      mapController?.animateCamera(
        CameraUpdate.newLatLng(latLng),
      );

      notifyListeners();
    } catch (e) {
      print('Error in periodic location update: $e');
    }
  }

  /// Get the current location and update the initial camera position on the Google Map
  Future<void> getCurrentLocation() async {
    showLoader(true);
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
      );

      final latLng = LatLng(position.latitude, position.longitude);
      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: latLng,
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
      );

      mapController?.animateCamera(
        CameraUpdate.newLatLng(latLng),
      );
      showLoader(false);
    } catch (e) {
      showLoader(false);
      print('Error getting current location: $e');
    }
  }

  Future<String> _getAddressFromLatLng(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];

      String address =
          "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      return address;
    } catch (e) {
      print("Failed to get address: $e");
      return ' ';
    }
  }

  void showLoader(bool loader) {
    isLoading = loader;
    notifyListeners();
  }

  
  void disposeData() {
    print('dispose called');
    _stopPeriodicLocationTracking();
    // _locationSubscription?.cancel();
    mapController?.dispose();
    super.dispose();
  }
}
