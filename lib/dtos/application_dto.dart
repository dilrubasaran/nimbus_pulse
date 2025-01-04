class ApplicationDTO {
  final String id;
  final String name;
  final String processId;
  final String status;
  final double cpuUsage;
  final double memoryUsage;
  final String startTime;
  final List<ResourceHistoryDTO> resourceHistory;

  ApplicationDTO({
    required this.id,
    required this.name,
    required this.processId,
    required this.status,
    required this.cpuUsage,
    required this.memoryUsage,
    required this.startTime,
    required this.resourceHistory,
  });

  factory ApplicationDTO.fromJson(Map<String, dynamic> json) {
    return ApplicationDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      processId: json['processId'] as String,
      status: json['status'] as String,
      cpuUsage: json['cpuUsage'].toDouble(),
      memoryUsage: json['memoryUsage'].toDouble(),
      startTime: json['startTime'] as String,
      resourceHistory: (json['resourceHistory'] as List)
          .map((item) => ResourceHistoryDTO.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'processId': processId,
      'status': status,
      'cpuUsage': cpuUsage,
      'memoryUsage': memoryUsage,
      'startTime': startTime,
      'resourceHistory': resourceHistory.map((item) => item.toJson()).toList(),
    };
  }
}

class ResourceHistoryDTO {
  final DateTime timestamp;
  final double cpuUsage;
  final double memoryUsage;

  ResourceHistoryDTO({
    required this.timestamp,
    required this.cpuUsage,
    required this.memoryUsage,
  });

  factory ResourceHistoryDTO.fromJson(Map<String, dynamic> json) {
    return ResourceHistoryDTO(
      timestamp: DateTime.parse(json['timestamp']),
      cpuUsage: json['cpuUsage'].toDouble(),
      memoryUsage: json['memoryUsage'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'cpuUsage': cpuUsage,
      'memoryUsage': memoryUsage,
    };
  }
}
