enum UserType {
  employee,
  admin;

  String toJson() => name;
  static UserType fromJson(String json) => values.firstWhere((e) => e.name == json);
}


enum AllThemes {
  light,
  dark,
}