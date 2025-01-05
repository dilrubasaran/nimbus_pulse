import 'package:flutter/material.dart';
import '../layout/main_layout.dart';
import '../widgets/device_card.dart';
import '../services/server_service.dart';
import '../dtos/device_dto.dart';
import '../core/network/dio_client.dart';

class ServerPage extends StatefulWidget {
  @override
  _ServerPage createState() => _ServerPage();
}

class _ServerPage extends State<ServerPage> {
  String _sortBy = 'status';
  List<int> _selectedDevices = [];
  final ServerService _serverService = ServerService(DioClient());
  List<DeviceDTO> _devices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final devices = await _serverService.getDevices();
      setState(() {
        _devices = devices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cihazlar yüklenirken hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addDevice(DeviceDTO device) async {
    try {
      await _serverService.addDevice(device);
      _loadDevices(); // Refresh the list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cihaz başarıyla eklendi'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cihaz eklenirken hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteSelectedDevices() async {
    try {
      for (var index in _selectedDevices) {
        final deviceId = _devices[index].id;
        if (deviceId != null) {
          await _serverService.deleteDevice(deviceId);
        }
      }
      _selectedDevices.clear();
      _loadDevices(); // Refresh the list
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Seçili cihazlar başarıyla silindi'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cihazlar silinirken hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAddDeviceDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ipAddressController = TextEditingController();
    String selectedType = 'Physical Server';
    String selectedOS = 'Windows Server';
    String selectedStatus = 'Active';
    String selectedHealthStatus = 'Good';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Yeni Cihaz Ekle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
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
                value: selectedType,
                items: ['Physical Server', 'Virtual Machine', 'Database Server']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedType = value!;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'İşletim Sistemi',
                  border: OutlineInputBorder(),
                ),
                value: selectedOS,
                items: ['Windows Server', 'Linux Server', 'MacOS Server']
                    .map((os) => DropdownMenuItem(
                          value: os,
                          child: Text(os),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedOS = value!;
                },
              ),
              SizedBox(height: 16),
              TextField(
                controller: ipAddressController,
                decoration: InputDecoration(
                  labelText: 'IP Adresi',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Çalışma Durumu',
                  border: OutlineInputBorder(),
                ),
                value: selectedStatus,
                items: ['Active', 'Inactive']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(
                              status == 'Active' ? 'Çalışıyor' : 'Çalışmıyor'),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedStatus = value!;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Sağlık Durumu',
                  border: OutlineInputBorder(),
                ),
                value: selectedHealthStatus,
                items: ['Good', 'Requires Check', 'Critical']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  selectedHealthStatus = value!;
                },
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
              if (nameController.text.isEmpty ||
                  ipAddressController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tüm alanları doldurunuz'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              final newDevice = DeviceDTO(
                name: nameController.text,
                type: selectedType,
                operatingSystem: selectedOS,
                ipAddress: ipAddressController.text,
                status: selectedStatus,
                healthStatus: selectedHealthStatus,
              );

              _addDevice(newDevice);
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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildActionButton(
                        icon: Icons.add_circle_outline,
                        text: "Yeni Cihaz Ekle",
                        onTap: _showAddDeviceDialog,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: _buildSortingDropdown(),
                    ),
                  ],
                ),
                if (_selectedDevices.isNotEmpty) ...[
                  SizedBox(height: 12),
                  _buildActionButton(
                    icon: Icons.remove_circle_outline,
                    text: "Cihaz Kaldır",
                    onTap: _deleteSelectedDevices,
                    color: Colors.red,
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double cardWidth = 180;
                        final double cardHeight = 100;
                        int crossAxisCount =
                            (constraints.maxWidth / cardWidth).floor();
                        if (crossAxisCount < 2) crossAxisCount = 1;
                        if (crossAxisCount > 6) crossAxisCount = 6;

                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: cardWidth / cardHeight,
                          ),
                          itemCount: _devices.length,
                          itemBuilder: (context, index) {
                            final device = _devices[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_selectedDevices.contains(index)) {
                                    _selectedDevices.remove(index);
                                  } else {
                                    _selectedDevices.add(index);
                                  }
                                });
                              },
                              onDoubleTap: () {
                                if (device.id != null) {
                                  print('\n=== Navigating to Dashboard ===');
                                  print('Device ID: ${device.id}');
                                  Navigator.pushNamed(
                                    context,
                                    '/dashboard',
                                    arguments: {
                                      'deviceId': device.id.toString(),
                                    },
                                  );
                                }
                              },
                              child: DeviceCard(
                                deviceName: device.name,
                                deviceType: device.type,
                                status: device.status,
                                statusColor:
                                    device.status.toLowerCase() == "active"
                                        ? Colors.green
                                        : Colors.red,
                                serverStatus: device.healthStatus,
                                borderColor:
                                    _getHealthStatusColor(device.healthStatus),
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
                                deviceId: device.id.toString(),
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
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortingDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _sortBy,
          icon: Icon(Icons.arrow_drop_down, color: Colors.blue, size: 20),
          iconSize: 16,
          elevation: 2,
          isDense: true,
          isExpanded: true,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.blue,
          ),
          items: [
            DropdownMenuItem(
              value: 'criticality',
              child: Text(
                'Sağlık Durumuma Göre ',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            DropdownMenuItem(
              value: 'status',
              child: Text(
                'Çalışma Durumuna Göre',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            DropdownMenuItem(
              value: 'name',
              child: Text(
                'Alfabetik',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          onChanged: (value) async {
            setState(() {
              _sortBy = value!;
            });
            await _loadDevicesOrdered(_sortBy);
          },
        ),
      ),
    );
  }

  Future<void> _loadDevicesOrdered(String orderBy) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final devices = await _serverService.getDevicesOrdered(orderBy);
      setState(() {
        _devices = devices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cihazlar sıralanırken hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  int _getDeviceCriticality(DeviceDTO device) {
    if (device.resourceUsage.cpuUsage > 80 ||
        device.resourceUsage.ramUsage > 80) {
      return 2; // Kritik
    } else if (device.resourceUsage.cpuUsage > 60 ||
        device.resourceUsage.ramUsage > 60) {
      return 1; // Kontrol Gerektiriyor
    }
    return 0; // İyi
  }

  Color _getHealthStatusColor(String healthStatus) {
    switch (healthStatus.toLowerCase()) {
      case 'good':
        return Colors.green;
      case 'requires check':
        return Color(0xFFFFC107);
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
