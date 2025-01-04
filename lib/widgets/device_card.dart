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
  final String deviceId;

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
    required this.deviceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardColor = isSelected ? Colors.blue : borderColor;

    return GestureDetector(
      onTap: onSelect,
      onDoubleTap: () {
        print('\n=== DeviceCard Navigation ===');
        print('Device ID: $deviceId');
        Navigator.pushNamed(
          context,
          '/dashboard',
          arguments: {'deviceId': deviceId},
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: cardColor,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              deviceName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              deviceType,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: cardColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status.toLowerCase() == "active"
                              ? "Çalışıyor"
                              : "Çalışmıyor",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: cardColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Server Durumu:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: cardColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          serverStatus,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: cardColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
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
