class Device {
  final String id;
  final String name;
  final String type;
  final String status;
  final String ipAddress;
  final String operatingSystem;
  final String lastUpdate;
  final double cpuUsage;
  final double ramUsage;
  final double diskUsage;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.ipAddress,
    required this.operatingSystem,
    required this.lastUpdate,
    required this.cpuUsage,
    required this.ramUsage,
    required this.diskUsage,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      status: json['status'],
      ipAddress: json['ipAddress'],
      operatingSystem: json['operatingSystem'],
      lastUpdate: json['lastUpdate'],
      cpuUsage: json['cpuUsage'].toDouble(),
      ramUsage: json['ramUsage'].toDouble(),
      diskUsage: json['diskUsage'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'status': status,
      'ipAddress': ipAddress,
      'operatingSystem': operatingSystem,
      'lastUpdate': lastUpdate,
      'cpuUsage': cpuUsage,
      'ramUsage': ramUsage,
      'diskUsage': diskUsage,
    };
  }
}
