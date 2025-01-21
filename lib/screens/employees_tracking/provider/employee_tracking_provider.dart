import 'dart:async';

import 'package:employee_location_tracking_app/screens/employees_tracking/models/employee_tracking_model.dart';
import 'package:employee_location_tracking_app/screens/employees_tracking/services/employee_tracking_service.dart';
import 'package:employee_location_tracking_app/utils/app_utils/app_utils.dart';
import 'package:employee_location_tracking_app/utils/static_info/static_info.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EmployeeTrackingProvider extends ChangeNotifier {
  final EmployeeTrackingService _locationService = EmployeeTrackingService();
  List<EmployeeTrackingModel> currentLocation = [];
  StreamSubscription? _locationSubscription;
  bool isLoading = false;
  GoogleMapController? mapController;
  CameraPosition? initialCameraPosition;
  Set<Marker> markers = {};

  void listenToUserLocation({required BuildContext context}) {
    // Listen to the location stream
    _locationSubscription = _locationService.streamUserLocation().listen(
      (locationData) {
        print('Listening to location: $locationData');

        if (locationData is List) {
          try {
            List<Map<String, dynamic>> data =
                List<Map<String, dynamic>>.from(locationData);
            currentLocation = data
                .map((location) => EmployeeTrackingModel.fromJson(location))
                .toList();
            notifyListeners();
            // Optionally: Update Google Maps markers dynamically
            initialCameraPosition = CameraPosition(
                target: LatLng(currentLocation[0].latitude ?? 31.4608099,
                    currentLocation[0].longitude ?? 74.2706179),
                zoom: 15.0);
            mapController?.animateCamera(
              CameraUpdate.newCameraPosition(initialCameraPosition!),
            );
            _updateGoogleMapMarkers(currentLocation, context);
          } catch (e) {
            print('Error parsing location data: $e');
          }
        } else {
          print('Invalid data format: ${locationData.runtimeType}');
        }
      },
      onError: (error) {
        print("Error listening to location: $error");
      },
    );
  }

  void _updateGoogleMapMarkers(
      List<EmployeeTrackingModel> employees, BuildContext context) {
    markers.clear();

    for (var employee in employees) {
      markers.add(
        Marker(
          markerId: MarkerId(employee.userId ?? ''),
          position: LatLng(employee.latitude ?? 0.0, employee.longitude ?? 0.0),
          infoWindow: InfoWindow(
              title: employee.employeeName ?? 'Unknown',
              snippet:
                  'Location: ${employee.address}\nLast Updated: ${employee.time}',
              onTap: () {
                AppUtils.showLocationDetailDialog(
                    context: context,
                    employee: employee,
                    iconPath: 'assets/images/bottom_bar_location_icon.svg');
                // _showCustomInfoWindow(employee, context);
              }),
        ),
      );
    }

    // Notify the map to refresh markers
    notifyListeners();
  }

  void tapOnEmployee(
      {required String userId, required double lat, required double lng}) {
    initialCameraPosition =
        CameraPosition(target: LatLng(lat, lng), zoom: 20.0);
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(initialCameraPosition!),
    );
    notifyListeners();
  }

  void _showCustomInfoWindow(
      EmployeeTrackingModel employee, BuildContext context) {
    // final timestamp = employee.formattedTimestamp;
    // final formattedDateTime = timestamp != null
    //     ? DateFormat('dd MMM yyyy hh:mm a').format(timestamp)
    //     : 'No Date Available';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(employee.employeeName ?? 'Unknown'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(employee.address ?? 'No address available'),
              SizedBox(height: 10),
              Text('Last Update: ${employee.time}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void stopListeningToUserLocation() {
    // Cancel the stream subscription
    _locationSubscription?.cancel();
    _locationSubscription = null;
    print('Stopped listening to location updates.');
  }
}
