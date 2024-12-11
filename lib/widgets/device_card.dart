import 'package:flutter/material.dart';

//!cihaz adı ve geri kalanlar modelden çekilecek veritabanından

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String deviceType;
  final String status;
  final Color statusColor;
  final String serverStatus;
  final Color borderColor;

  DeviceCard({
    required this.deviceName,
    required this.deviceType,
    required this.status,
    required this.statusColor,
    required this.serverStatus,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              deviceName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              deviceType,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              status,
              style: TextStyle(
                fontSize: 14,
                color: statusColor, // Durum rengi
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Server Durumu: $serverStatus",
              style: TextStyle(
                fontSize: 12,
                color: borderColor, // Server durumu rengi
              ),
            ),
          ],
        ),
      ),
    );
  }
}
