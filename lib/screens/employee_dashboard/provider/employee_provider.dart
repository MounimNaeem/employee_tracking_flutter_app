import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:action_slider/action_slider.dart';
import 'package:employee_location_tracking_app/firebase_options.dart';
import 'package:employee_location_tracking_app/screens/auth/signup/models/user_model.dart';
import 'package:employee_location_tracking_app/screens/employee_dashboard/services/employee_services.dart';
import 'package:employee_location_tracking_app/services/background_service_manager/backgroung_service_manager.dart';
import 'package:employee_location_tracking_app/services/shared_prefs_service.dart';
import 'package:employee_location_tracking_app/utils/static_info/static_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BackgroundLocationService {
  static final _instance = FlutterBackgroundService();
  static FlutterBackgroundService get instance => _instance;
  static final _httpClient = http.Client();

  static Future<String> getAddressFromOpenStreetMap(
      double lat, double lon) async {
    try {
      final response = await _httpClient.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&zoom=20&addressdetails=1&accept-language=en',
        ),
        headers: {
          'User-Agent': 'YourAppName/1.0',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'];

        final parts = <String>[];
        parts.add(address['display_name']);
        // if (address['house_number'] != null) parts.add(address['house_number']);
        // if (address['road'] != null) parts.add(address['road']);
        // if (address['suburb'] != null) parts.add(address['suburb']);
        // if (address['city'] != null) parts.add(address['city']);
        // if (address['state'] != null) parts.add(address['state']);
        // if (address['postcode'] != null) parts.add(address['postcode']);
        // if (address['country'] != null) parts.add(address['country']);

        return parts.join(', ');
      }
      throw Exception('Failed to get address');
    } catch (e) {
      print('Error getting address from OpenStreetMap: $e');
      return 'Address unavailable';
    }
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (service is AndroidServiceInstance) {
      service.setAsForegroundService();

      service.on('setAsForeground').listen((event) async {
        await service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) async {
        await service.setAsBackgroundService();
      });

      service.on('keepAlive').listen((event) async {
        await service.setForegroundNotificationInfo(
          title: "Location Tracking Active",
          content: "Monitoring your location...",
        );
      });
    }

    service.on('stopService').listen((event) async {
      await service.stopSelf();
    });

    Timer.periodic(const Duration(minutes: 15), (timer) async {
      if (service is AndroidServiceInstance) {
        try {
          final prefs = await SharedPreferences.getInstance();
          final isTracking =
              prefs.getBool(BackgroundServicesManager.LOCATION_SERVICE_KEY) ??
                  false;

          if (!isTracking) {
            await service.stopSelf();
            timer.cancel();
            return;
          }

          await service.setForegroundNotificationInfo(
            title: "Location Tracking Active",
            content: "Monitoring your location...",
          );

          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          String address = await getAddressFromOpenStreetMap(
            position.latitude,
            position.longitude,
          );

          UserModel? userModel = await SharedPrefsService().getUserData();
          final userId = userModel?.userId ?? '';

          if (userId.isNotEmpty) {
            final employeeService = EmployeeService();
            await employeeService.updateLiveLocation(
              userId: userId,
              position: position,
              address: address,
              isOnline: true,
              userModel: userModel,
            );
            await employeeService.storeLocationHistory(userId, position,
                address, true, userModel?.firstName ?? 'Employee');
          }

          service.invoke('keepAlive');
        } catch (e) {
          print('Error in background service: $e');
          await service.setForegroundNotificationInfo(
            title: "Location Tracking Active",
            content: "Monitoring your location...",
          );
        }
      }
    });
  }

  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return true;
  }
}

final employeeProvider = ChangeNotifierProvider((ref) => EmployeeNotifier());

class EmployeeNotifier extends ChangeNotifier with WidgetsBindingObserver {
  final _locationService = EmployeeService();
  GoogleMapController? mapController;
  Timer? _locationTimer;
  final _backgroundService = FlutterBackgroundService();
  // bool isAppInForeground = true; // Track app state
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
    // initializeBackgroundService();
  }

  // Future<void> initializeBackgroundService() async {
  //   await BackgroundLocationService().initializeService();
  // }

  Future<void> toggleOnlineStatus(BuildContext context) async {
    try {
      if (isOnline) {
        isOnline = !isOnline;
        await endShift();
      } else {
        isOnline = !isOnline;
        // final hasPermission = await checkAndRequestPermissions(context);
        // if (!hasPermission) {
        //   await checkAndRequestPermissions(context);
        //   // throw Exception("Location permission not granted.");
        // }else
        // {
          await startShift(context);
          // }
      }

      await _locationService.updateEmployeeActiveStatusInUserDoc(
        isOnline,
      );

      await SharedPrefsService().setisUserOnline(isOnline);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Check and request location permissions
  Future<bool> checkAndRequestPermissions(BuildContext context) async {
    // Check if "Always" permission is granted
    if (await Permission.locationAlways.isGranted) {
      return true;
    }

    // Request "Always" location permission
    final status = await Permission.locationAlways.request();

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      print("Location permission is denied.");
      return false;
    } else if (status.isPermanentlyDenied) {
      print("Location permission is permanently denied. Opening settings...");

      // Show a dialog to inform the user
      bool? openSettings = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Location Permission Required"),
            content: Text(
                "To go online, you must allow 'Allow all the time' location access."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context, true);
                },
                child: Text("Open Settings"),
              ),
            ],
          );
        },
      );

      return openSettings ?? false;
    }
    return false;
  }

  /// Start the employee shift and location tracking
  Future<void> startShift(BuildContext context) async {
    // if (_isShiftActive) return;

    
    await _locationService.cleanHistory(StaticInfo.userModel!.userId ?? '');
    // await BackgroundLocationService.startLocationService();
    await BackgroundServicesManager.startLocationService();
    notifyListeners();

    // Start periodic location tracking (every 30 minutes)
    // await updateLocation(); // Initial update
    // startPeriodicLocationTracking();
  }

  /// Stop the employee shift and location tracking
  Future<void> endShift() async {
    await updateLocation();
    // _stopPeriodicLocationTracking();
    // _locationSubscription?.cancel();
    // await BackgroundLocationService.stopLocationService();
    await BackgroundServicesManager.stopLocationService();
    notifyListeners();
  }

  /// Start periodic location tracking (every 30 minutes)
  void startPeriodicLocationTracking() {
    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      print('timer running');
      updateLocation();
    });
  }

  /// Stop periodic location tracking
  void _stopPeriodicLocationTracking() {
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  /// Update location and store in history
  Future<void> updateLocation() async {
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
          userId: userId,
          position: position,
          address: address,
          isOnline: isOnline,
          userModel: StaticInfo.userModel);
      await _locationService.storeLocationHistory(
        userId,
        position,
        address,
        isOnline,
        StaticInfo.userModel?.firstName ?? 'Employee',
      );

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
///AIzaSyCCWqVXt2kSZZzyqeAZu4jqvfQ-gjxdcn8