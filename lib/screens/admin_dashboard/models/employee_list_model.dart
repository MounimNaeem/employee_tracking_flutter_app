// To parse this JSON data, do
//
//     final employeeListModel = employeeListModelFromJson(jsonString);

import 'dart:convert';

import 'package:employee_location_tracking_app/utils/enums/enums.dart';

List<EmployeeListModel> employeeListModelFromJson(String str) =>
    List<EmployeeListModel>.from(
        json.decode(str).map((x) => EmployeeListModel.fromJson(x)));

String employeeListModelToJson(List<EmployeeListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmployeeListModel {
  String? id;
  String? firstName;
  String? lastName;
  final UserType? userType;
  String? phone;
  dynamic profileImage;
  bool? isActive;
  String? userId;
  String? email;
  String? userUid;
  DateTime? createdAt;

  EmployeeListModel({
    this.id,
    this.firstName,
    this.lastName,
    this.userType,
    this.phone,
    this.profileImage,
    this.isActive,
    this.userId,
    this.email,
    this.userUid,
    this.createdAt,
  });

  factory EmployeeListModel.fromJson(Map<String, dynamic> json) =>
      EmployeeListModel(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        userType: UserType.fromJson(json['user_type']),
        phone: json["phone"],
        profileImage: json["profileImage"],
        isActive: json["isActive"],
        userId: json["userId"],
        email: json["email"],
        userUid: json["userUid"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "user_type": userType,
        "phone": phone,
        "profileImage": profileImage,
        "isActive": isActive,
        "userId": userId,
        "email": email,
        "userUid": userUid,
        "createdAt": createdAt?.toIso8601String(),
      };
}
