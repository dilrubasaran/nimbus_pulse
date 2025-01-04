class DeviceDTO {
  final String id;
  final String name;
  final String type;
  final String status;
  final String ipAddress;
  final String operatingSystem;
  final String lastUpdate;
  final ResourceUsageDTO resourceUsage;

  DeviceDTO({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.ipAddress,
    required this.operatingSystem,
    required this.lastUpdate,
    required this.resourceUsage,
  });

  factory DeviceDTO.fromJson(Map<String, dynamic> json) {
    return DeviceDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      ipAddress: json['ipAddress'] as String,
      operatingSystem: json['operatingSystem'] as String,
      lastUpdate: json['lastUpdate'] as String,
      resourceUsage: ResourceUsageDTO.fromJson(json['resourceUsage']),
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
      'resourceUsage': resourceUsage.toJson(),
    };
  }
}

class ResourceUsageDTO {
  final double cpuUsage;
  final double ramUsage;
  final double diskUsage;
  final List<ResourceHistoryDTO> history;

  ResourceUsageDTO({
    required this.cpuUsage,
    required this.ramUsage,
    required this.diskUsage,
    required this.history,
  });

  factory ResourceUsageDTO.fromJson(Map<String, dynamic> json) {
    return ResourceUsageDTO(
      cpuUsage: json['cpuUsage'].toDouble(),
      ramUsage: json['ramUsage'].toDouble(),
      diskUsage: json['diskUsage'].toDouble(),
      history: (json['history'] as List)
          .map((item) => ResourceHistoryDTO.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpuUsage': cpuUsage,
      'ramUsage': ramUsage,
      'diskUsage': diskUsage,
      'history': history.map((item) => item.toJson()).toList(),
    };
  }
}

class ResourceHistoryDTO {
  final DateTime timestamp;
  final double cpuUsage;
  final double ramUsage;
  final double diskUsage;

  ResourceHistoryDTO({
    required this.timestamp,
    required this.cpuUsage,
    required this.ramUsage,
    required this.diskUsage,
  });

  factory ResourceHistoryDTO.fromJson(Map<String, dynamic> json) {
    return ResourceHistoryDTO(
      timestamp: DateTime.parse(json['timestamp']),
      cpuUsage: json['cpuUsage'].toDouble(),
      ramUsage: json['ramUsage'].toDouble(),
      diskUsage: json['diskUsage'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'cpuUsage': cpuUsage,
      'ramUsage': ramUsage,
      'diskUsage': diskUsage,
    };
  }
}
