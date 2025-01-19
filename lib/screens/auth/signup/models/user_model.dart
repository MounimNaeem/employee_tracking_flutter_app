// import 'package:employee_location_tracking_app/utils/enums/enums.dart';

// class UserModel {
//   final String? userUid; // Original UID provided by Firebase
//   final String? userId; // New auto-generated 4-6 digit ID
//   final String? firstName;
//   final String? lastName;
//   final String? email;
//   final String? phone;
//   final UserType? userType;
//   final DateTime? createdAt;

//   UserModel({
//     this.userUid,
//     this.userId,
//      this.firstName,
//      this.lastName,
//      this.email,
//      this.phone,
//     this.userType = UserType.employee,
//     this.createdAt,
//   });

//   Map<String, dynamic> toJson() => {
//     'userUid': userUid,
//     'userId': userId,
//     'firstName': firstName,
//     'lastName': lastName,
//     'email': email,
//     'phone': phone,
//     'user_type': userType?.toJson(),
//     'createdAt': createdAt?.toIso8601String(),
//   };

//   factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
//     userUid: json['userUid'],
//     userId: json['userId'],
//     firstName: json['firstName'],
//     lastName: json['lastName'],
//     email: json['email'],
//     phone: json['phone'],
//     userType: UserType.fromJson(json['user_type']),
//     createdAt: json['createdAt'] != null
//         ? DateTime.parse(json['createdAt'])
//         : null,
//   );
// }
import 'package:employee_location_tracking_app/utils/enums/enums.dart';

class UserModel {
  final String? userUid;
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final UserType? userType;
  final bool isActive;
  final String? profileImage;

  UserModel({
    this.userUid,
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.userType = UserType.employee,
    this.isActive = true,
    this.profileImage,
  });

  Map<String, dynamic> toJson() => {
        'userUid': userUid,
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'user_type': userType?.toJson(),
        'isActive': isActive,
        'profileImage': profileImage,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userUid: json['userUid'],
        userId: json['userId'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        phone: json['phone'],
        userType: UserType.fromJson(json['user_type']),
        isActive: json['isActive'] ?? true,
        profileImage: json['profileImage'],
      );

  String get fullName => '$firstName $lastName';

  bool get isAdmin => userType == UserType.admin;
  
  UserModel copyWith({
    String? userUid,
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    UserType? userType,
    bool? isActive,
    String? profileImage,
  }) {
    return UserModel(
      userUid: userUid ?? this.userUid,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      isActive: isActive ?? this.isActive,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}