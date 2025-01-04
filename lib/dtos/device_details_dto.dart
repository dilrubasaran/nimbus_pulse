class DeviceDetailsDTO {
  final int id;
  final String name;
  final String type;
  final String operatingSystem;
  final String ipAddress;
  final String status;
  final String healthStatus;
  final DateTime lastReportDate;
  final ResourceUsageDTO resourceUsage;
  final List<BackgroundAppDTO> backgroundApplications;
  final List<ActiveAppDTO> activeApplications;

  DeviceDetailsDTO({
    required this.id,
    required this.name,
    required this.type,
    required this.operatingSystem,
    required this.ipAddress,
    required this.status,
    required this.healthStatus,
    required this.lastReportDate,
    required this.resourceUsage,
    required this.backgroundApplications,
    required this.activeApplications,
  });

  factory DeviceDetailsDTO.fromJson(Map<String, dynamic> json) {
    return DeviceDetailsDTO(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      operatingSystem: json['operatingSystem'] as String,
      ipAddress: json['ipAddress'] as String,
      status: json['status'] as String,
      healthStatus: json['healthStatus'] as String,
      lastReportDate: DateTime.parse(json['lastReportDate'] as String),
      resourceUsage: ResourceUsageDTO.fromJson(
          json['resourceUsage'] as Map<String, dynamic>),
      backgroundApplications: (json['backgroundApplications'] as List)
          .map((e) => BackgroundAppDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeApplications: (json['activeApplications'] as List)
          .map((e) => ActiveAppDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      'lastReportDate': lastReportDate.toIso8601String(),
      'resourceUsage': resourceUsage.toJson(),
      'backgroundApplications':
          backgroundApplications.map((e) => e.toJson()).toList(),
      'activeApplications': activeApplications.map((e) => e.toJson()).toList(),
    };
  }
}

class ResourceUsageDTO {
  final List<double> cpuHistory;
  final List<double> ramHistory;
  final double currentCpuUsage;
  final double currentRamUsage;
  final double currentDiskUsage;

  ResourceUsageDTO({
    required this.cpuHistory,
    required this.ramHistory,
    required this.currentCpuUsage,
    required this.currentRamUsage,
    required this.currentDiskUsage,
  });

  factory ResourceUsageDTO.fromJson(Map<String, dynamic> json) {
    return ResourceUsageDTO(
      cpuHistory: (json['cpuHistory'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      ramHistory: (json['ramHistory'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      currentCpuUsage: (json['currentCpuUsage'] as num).toDouble(),
      currentRamUsage: (json['currentRamUsage'] as num).toDouble(),
      currentDiskUsage: (json['currentDiskUsage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpuHistory': cpuHistory,
      'ramHistory': ramHistory,
      'currentCpuUsage': currentCpuUsage,
      'currentRamUsage': currentRamUsage,
      'currentDiskUsage': currentDiskUsage,
    };
  }
}

class BackgroundAppDTO {
  final String name;
  final String runningTime;
  final double cpuUsage;
  final double ramUsage;

  BackgroundAppDTO({
    required this.name,
    required this.runningTime,
    required this.cpuUsage,
    required this.ramUsage,
  });

  factory BackgroundAppDTO.fromJson(Map<String, dynamic> json) {
    return BackgroundAppDTO(
      name: json['name'] as String,
      runningTime: json['runningTime'] as String,
      cpuUsage: (json['cpuUsage'] as num).toDouble(),
      ramUsage: (json['ramUsage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'runningTime': runningTime,
      'cpuUsage': cpuUsage,
      'ramUsage': ramUsage,
    };
  }
}

class ActiveAppDTO {
  final String name;
  final String status;
  final String runningTime;
  final double cpuUsage;
  final double ramUsage;
  final List<double> cpuHistory;
  final List<double> ramHistory;

  ActiveAppDTO({
    required this.name,
    required this.status,
    required this.runningTime,
    required this.cpuUsage,
    required this.ramUsage,
    required this.cpuHistory,
    required this.ramHistory,
  });

  factory ActiveAppDTO.fromJson(Map<String, dynamic> json) {
    return ActiveAppDTO(
      name: json['name'] as String,
      status: json['status'] as String,
      runningTime: json['runningTime'] as String,
      cpuUsage: (json['cpuUsage'] as num).toDouble(),
      ramUsage: (json['ramUsage'] as num).toDouble(),
      cpuHistory: (json['cpuHistory'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
      ramHistory: (json['ramHistory'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'status': status,
      'runningTime': runningTime,
      'cpuUsage': cpuUsage,
      'ramUsage': ramUsage,
      'cpuHistory': cpuHistory,
      'ramHistory': ramHistory,
    };
  }
}
