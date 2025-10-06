
class UserRegistrationData {
  String? email;
  String? password;
  String? photoPath;
  String? coverPath;
  String? nationality;
  List<String> languages;
  List<String> interests;
  bool? isStudent;
  String? nickname;
  String? status;
  String? country;
  String? firstName;
  String? lastName;

  DateTime? lastNationalityChange;
  bool isLoggedIn;

  UserRegistrationData({
    this.email,
    this.password,
    this.photoPath,
    this.coverPath,
    this.nationality,
    List<String>? languages,
    List<String>? interests,
    this.isStudent,
    this.nickname,
    this.status,
    this.country,
    this.firstName,
    this.lastName,
    this.lastNationalityChange,
    this.isLoggedIn = false,
  })  : languages = languages ?? [],
        interests = interests ?? [];


  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "photoPath": photoPath,
    "coverPath": coverPath,
    "nationality": nationality,
    "languages": languages,
    "interests": interests,
    "isStudent": isStudent,
    "nickname": nickname,
    "status": status,
    "country": country,
    "firstName": firstName,
    "lastName": lastName,
    "lastNationalityChange": lastNationalityChange?.toIso8601String(),
    "isLoggedIn": isLoggedIn,
  };

  static UserRegistrationData fromJson(Map<String, dynamic> json) {
    return UserRegistrationData(
      email: json["email"] as String?,
      password: json["password"] as String?,
      photoPath: json["photoPath"] as String?,
      coverPath: json["coverPath"] as String?,
      nationality: json["nationality"] as String?,
      languages: (json["languages"] as List?)?.cast<String>() ?? [],
      interests: (json["interests"] as List?)?.cast<String>() ?? [],
      isStudent: json["isStudent"] as bool?,
      nickname: json["nickname"] as String?,
      status: json["status"] as String?,
      country: json["country"] as String?,
      firstName: json["firstName"] as String?,
      lastName: json["lastName"] as String?,
      lastNationalityChange: json["lastNationalityChange"] != null
          ? DateTime.tryParse(json["lastNationalityChange"])
          : null,
      isLoggedIn: json["isLoggedIn"] ?? false,
    );
  }
}
