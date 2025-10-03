class UserRegistrationData {
  final String email;      // 👈 обязательный
  final String password;   // 👈 обязательный

  final String? photoPath;       // аватар
  final String? coverPath;       // обложка
  final String? nationality;     // национальность
  final List<String> languages;
  final List<String> interests;
  final bool? isStudent;
  final String? nickname;
  final String? status;
  final String? country;
  final String? firstName;       // имя
  final String? lastName;        // фамилия
  final DateTime? lastNationalityChange; // дата последнего изменения национальности
  final bool isLoggedIn;                 // флаг текущего залогиненного пользователя

  UserRegistrationData({
    required this.email,
    required this.password,
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

  /// Сериализация в JSON
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

  /// Десериализация из JSON
  factory UserRegistrationData.fromJson(Map<String, dynamic> json) {
    return UserRegistrationData(
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      photoPath: json["photoPath"],
      coverPath: json["coverPath"],
      nationality: json["nationality"],
      languages: (json["languages"] as List?)?.cast<String>() ?? [],
      interests: (json["interests"] as List?)?.cast<String>() ?? [],
      isStudent: json["isStudent"],
      nickname: json["nickname"],
      status: json["status"],
      country: json["country"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      lastNationalityChange: json["lastNationalityChange"] != null
          ? DateTime.tryParse(json["lastNationalityChange"])
          : null,
      isLoggedIn: json["isLoggedIn"] ?? false,
    );
  }

  /// Удобное копирование с изменением отдельных полей FOR MAIN DART !!!!!!!!
  UserRegistrationData copyWith({
    String? email,
    String? password,
    String? photoPath,
    String? coverPath,
    String? nationality,
    List<String>? languages,
    List<String>? interests,
    bool? isStudent,
    String? nickname,
    String? status,
    String? country,
    String? firstName,
    String? lastName,
    DateTime? lastNationalityChange,
    bool? isLoggedIn,
  }) {
    return UserRegistrationData(
      email: email ?? this.email,
      password: password ?? this.password,
      photoPath: photoPath ?? this.photoPath,
      coverPath: coverPath ?? this.coverPath,
      nationality: nationality ?? this.nationality,
      languages: languages ?? this.languages,
      interests: interests ?? this.interests,
      isStudent: isStudent ?? this.isStudent,
      nickname: nickname ?? this.nickname,
      status: status ?? this.status,
      country: country ?? this.country,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      lastNationalityChange: lastNationalityChange ?? this.lastNationalityChange,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  @override
  String toString() {
    return 'UserRegistrationData(email: $email, nickname: $nickname, isLoggedIn: $isLoggedIn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserRegistrationData &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}
