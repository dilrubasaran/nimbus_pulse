import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String deviceType;
  final String status;
  final Color statusColor;
  final String serverStatus;
  final Color borderColor;
  final bool isSelected;
  final VoidCallback onSelect;

  const DeviceCard({
    Key? key,
    required this.deviceName,
    required this.deviceType,
    required this.status,
    required this.statusColor,
    required this.serverStatus,
    required this.borderColor,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deviceName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                deviceType,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              Text(
                status,
                style: TextStyle(
                  fontSize: 14,
                  color: statusColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Server Durumu: $serverStatus",
                style: TextStyle(
                  fontSize: 12,
                  color: borderColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResponsiveDeviceGrid extends StatelessWidget {
  final List<DeviceCard> devices;

  const ResponsiveDeviceGrid({Key? key, required this.devices})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Her bir kartın genişliği
        const cardWidth = 160;
        // Maksimum kart sayısı
        const maxCards = 7;

        // Ekran genişliğine göre sütun sayısını hesapla
        int crossAxisCount = (constraints.maxWidth / cardWidth).floor();
        if (crossAxisCount > maxCards) crossAxisCount = maxCards;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: cardWidth / 120, // Kart boyut oranı
            ),
            itemCount: devices.length,
            itemBuilder: (context, index) {
              return devices[index];
            },
          ),
        );
      },
    );
  }
}
