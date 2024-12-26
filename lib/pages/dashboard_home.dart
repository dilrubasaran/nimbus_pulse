import 'package:flutter/material.dart';
import '../layout/main_layout.dart';
import '../widgets/device_card.dart';

class DashboardHome extends StatefulWidget {
  @override
  _DashboardHomeState createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  String _sortBy = 'status';
  List<int> _selectedDevices = [];

  void _showAddDeviceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Yeni Cihaz Ekle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Cihaz Adı',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Cihaz Tipi',
                  border: OutlineInputBorder(),
                ),
                items: ['Laptop', 'Desktop']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              // API call to add device
              Navigator.pop(context);
            },
            child: Text('Ekle'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Column(
        children: [
          // Device Management Buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildActionButton(
                      icon: Icons.add_circle_outline,
                      text: "Yeni Cihaz Ekle",
                      onTap: _showAddDeviceDialog,
                    ),
                    SizedBox(width: 16),
                    if (_selectedDevices.isNotEmpty)
                      _buildActionButton(
                        icon: Icons.remove_circle_outline,
                        text: "Cihaz Kaldır",
                        onTap: () {
                          // API call to remove devices
                        },
                        color: Colors.red,
                      ),
                  ],
                ),
                _buildSortingDropdown(),
              ],
            ),
          ),
          // Devices Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Kart genişliği
                  const cardWidth = 160;
                  // Ekran genişliğine göre sütun sayısını hesapla
                  int crossAxisCount =
                      (constraints.maxWidth / cardWidth).floor();

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
                        statusColor =
                            borderColor; // Server status'tan renk alır
                      } else {
                        status = "Kapalı";
                        statusColor = Colors.black; // Çalışmıyorsa siyah renk
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/device_detail',
                            arguments: {
                              'deviceId': index.toString(),
                              'deviceName': "Mac Pro 16 inç",
                            },
                          );
                        },
                        child: DeviceCard(
                          deviceName: "Mac Pro 16 inç",
                          deviceType: "Laptop",
                          status: status,
                          statusColor: statusColor,
                          serverStatus: serverStatus,
                          borderColor: borderColor,
                          isSelected: _selectedDevices.contains(index),
                          onSelect: () {
                            setState(() {
                              if (_selectedDevices.contains(index)) {
                                _selectedDevices.remove(index);
                              } else {
                                _selectedDevices.add(index);
                              }
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color?.withOpacity(0.1) ?? Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color ?? Colors.blue),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: color ?? Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortingDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _sortBy,
          icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
          style: TextStyle(
            fontSize: 14,
            color: Colors.blue,
          ),
          items: [
            DropdownMenuItem(
              value: 'status',
              child: Text('Kritik Duruma Göre'),
            ),
            DropdownMenuItem(
              value: 'resource',
              child: Text('Kaynak Kullanımına Göre'),
            ),
            DropdownMenuItem(
              value: 'name',
              child: Text('Alfabetik'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _sortBy = value!;
              // Implement sorting logic
            });
          },
        ),
      ),
    );
  }
}
