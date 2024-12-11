import 'package:flutter/material.dart';
import '../layout/main_layout.dart';
import '../widgets/device_card.dart';
// ! tam değil responsive yapı çalışıyor ama tam değil

class DashboardHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Kart genişliği
            const cardWidth = 160;
            // Ekran genişliğine göre sütun sayısını hesapla
            int crossAxisCount = (constraints.maxWidth / cardWidth).floor();

            // En fazla 7 kart sığacak
            if (crossAxisCount > 7) crossAxisCount = 7;

            // Minimum 2 kart
            if (crossAxisCount < 2) crossAxisCount = 2;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: cardWidth / 120, // Kart boyut oranı
              ),
              itemCount: 20, // Kaç kart gösterileceği
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
            );
          },
        ),
      ),
    );
  }
}
