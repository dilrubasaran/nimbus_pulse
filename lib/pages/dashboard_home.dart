import 'package:flutter/material.dart';
import '../layout/main_layout.dart';
import '../widgets/device_card.dart';

class DashboardHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Padding(
        // 'body' parametresini kullanıyoruz
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600
                ? 4
                : 2, // Responsive tasarım
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 20,
          itemBuilder: (context, index) {
            String serverStatus;
            Color borderColor;
            String status;
            Color statusColor;

            // Server durumu ve renk ayarları
            if (index == 2) {
              serverStatus = "Kritik";
              borderColor = Colors.red;
            } else if (index % 2 == 0) {
              serverStatus = "İyi";
              borderColor = Colors.blue;
            } else {
              serverStatus = "Kontrol Gerektiriyor";
              borderColor = Colors.yellow;
            }

            // Status durumu ve renk ayarları
            if (index % 3 == 0) {
              status = "Çalışıyor";
              statusColor = borderColor; // Server status'tan renk alır
            } else {
              status = "Kapalı";
              statusColor = Colors.black; // Çalışmıyorsa siyah renk
            }

            return DeviceCard(
              deviceName: "Mac Pro 16 inç",
              deviceType: "Laptop",
              status: status,
              statusColor: statusColor,
              serverStatus: serverStatus,
              borderColor: borderColor,
            );
          },
        ),
      ),
    );
  }
}
