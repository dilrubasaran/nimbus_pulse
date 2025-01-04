class DeviceDTO {
  final int id;
  final String name;
  final String type;
  final String operatingSystem;
  final String ipAddress;
  final String status;
  final String healthStatus;
  final ResourceUsage resourceUsage;

  DeviceDTO({
    required this.id,
    required this.name,
    required this.type,
    required this.operatingSystem,
    required this.ipAddress,
    required this.status,
    required this.healthStatus,
    ResourceUsage? resourceUsage,
  }) : this.resourceUsage = resourceUsage ??
            ResourceUsage(cpuUsage: 0, ramUsage: 0, diskUsage: 0);

  factory DeviceDTO.fromJson(Map<String, dynamic> json) {
    return DeviceDTO(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      operatingSystem: json['operatingSystem'] as String,
      ipAddress: json['ipAddress'] as String,
      status: json['status'] as String,
      healthStatus: json['healthStatus'] as String,
      resourceUsage: ResourceUsage(
        cpuUsage: 0, // Bu değerler API'den gelecek şekilde güncellenebilir
        ramUsage: 0,
        diskUsage: 0,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'operatingSystem': operatingSystem,
      'ipAddress': ipAddress,
      'status': status,
      'healthStatus': healthStatus,
    };
  }
}

class ResourceUsage {
  final double cpuUsage;
  final double ramUsage;
  final double diskUsage;

  ResourceUsage({
    required this.cpuUsage,
    required this.ramUsage,
    required this.diskUsage,
  });

  factory ResourceUsage.fromJson(Map<String, dynamic> json) {
    return ResourceUsage(
      cpuUsage: (json['cpuUsage'] as num).toDouble(),
      ramUsage: (json['ramUsage'] as num).toDouble(),
      diskUsage: (json['diskUsage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpuUsage': cpuUsage,
      'ramUsage': ramUsage,
      'diskUsage': diskUsage,
    };
  }
}
