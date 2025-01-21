import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// To parse this JSON data, do
//
//     final employeeTrackingModel = employeeTrackingModelFromJson(jsonString);

EmployeeTrackingModel employeeTrackingModelFromJson(String str) =>
    EmployeeTrackingModel.fromJson(json.decode(str));

String employeeTrackingModelToJson(EmployeeTrackingModel data) =>
    json.encode(data.toJson());

class EmployeeTrackingModel {
  String? employeeName;
  String? address;
  double? latitude;
  bool? isActive;
  String? userId;
  double? longitude;
  String? time;

  EmployeeTrackingModel({
    this.employeeName,
    this.address,
    this.latitude,
    this.isActive,
    this.userId,
    this.longitude,
    this.time,
  });

  factory EmployeeTrackingModel.fromJson(Map<String, dynamic> json) =>
      EmployeeTrackingModel(
        employeeName: json["employeeName"],
        address: json["address"],
        latitude: json["latitude"]?.toDouble(),
        isActive: json["isActive"],
        userId: json["userId"],
        time: json["time"],
        longitude: json["longitude"]?.toDouble(),
        // Access timestamp fields directly using seconds and nanoseconds properties
      );

  Map<String, dynamic> toJson() => {
        "employeeName": employeeName,
        "address": address,
        "latitude": latitude,
        "isActive": isActive,
        "userId": userId,
        "time": time,
        "longitude": longitude,
        // Serialize timestamp fields to seconds and nanoseconds
      };
}
