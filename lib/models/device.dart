class Device {
  final String id;
  final String name;
  final String type;
  final String status;
  final double cpuUsage;
  final double ramUsage;
  final String workingTime;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.cpuUsage,
    required this.ramUsage,
    required this.workingTime,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      cpuUsage: json['cpuUsage'] as double,
      ramUsage: json['ramUsage'] as double,
      workingTime: json['workingTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'status': status,
      'cpuUsage': cpuUsage,
      'ramUsage': ramUsage,
      'workingTime': workingTime,
    };
  }
}
