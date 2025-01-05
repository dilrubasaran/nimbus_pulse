class ProfileUpdateDTO {
  final String firstName;
  final String surName;
  final String email;
  final String phoneNumber;
  final String profilePictureUrl;

  ProfileUpdateDTO({
    required this.firstName,
    required this.surName,
    required this.email,
    required this.phoneNumber,
    this.profilePictureUrl = '',
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'surName': surName,
        'email': email,
        'phoneNumber': phoneNumber,
        'profilePictureUrl': profilePictureUrl,
      };

  factory ProfileUpdateDTO.fromJson(Map<String, dynamic> json) {
    print('Converting JSON to ProfileUpdateDTO:');
    print('Input JSON: $json');

    return ProfileUpdateDTO(
      firstName: json['firstName']?.toString() ?? '',
      surName: json['surName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      profilePictureUrl: json['profilePictureUrl']?.toString() ?? '',
    );
  }
}

class PasswordChangeDTO {
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  PasswordChangeDTO({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  Map<String, dynamic> toJson() => {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      };
}

class ThemeUpdateDTO {
  final String theme;
  final String language;

  ThemeUpdateDTO({
    required this.theme,
    required this.language,
  });

  Map<String, dynamic> toJson() => {
        'theme': theme,
        'language': language,
      };

  factory ThemeUpdateDTO.fromJson(Map<String, dynamic> json) => ThemeUpdateDTO(
        theme: json['theme'],
        language: json['language'],
      );
}

class SecurityCodeChangeDTO {
  final String currentSecurityCode;
  final String newSecurityCode;
  final String confirmNewSecurityCode;

  SecurityCodeChangeDTO({
    required this.currentSecurityCode,
    required this.newSecurityCode,
    required this.confirmNewSecurityCode,
  });

  Map<String, dynamic> toJson() => {
        'currentSecurityCode': currentSecurityCode,
        'newSecurityCode': newSecurityCode,
        'confirmNewSecurityCode': confirmNewSecurityCode,
      };
}
