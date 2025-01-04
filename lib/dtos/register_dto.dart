class RegisterDTO {
  final String name;
  final String surname;
  final String password;
  final String email;
  final String phoneNumber;
  final String companyName;

  // Constructor
  RegisterDTO({
    required this.name,
    required this.surname,
    required this.password,
    required this.email,
    required this.phoneNumber,
    required this.companyName,
  });

  // JSON'dan RegisterDTO oluşturmak için factory
  factory RegisterDTO.fromJson(Map<String, dynamic> json) {
    return RegisterDTO(
      name: json['name'],
      surname: json['surname'],
      password: json['password'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      companyName: json['companyName'],
    );
  }

  // RegisterDTO'yu JSON'a dönüştürmek için
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'password': password,
      'email': email,
      'phoneNumber': phoneNumber,
      'companyName': companyName,
    };
  }
}
