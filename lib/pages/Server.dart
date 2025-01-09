import 'package:flutter/material.dart';
import '../layout/main_layout.dart';
import '../widgets/device_card.dart';
import '../services/server_service.dart';
import '../dtos/device_dto.dart';
import '../core/network/dio_client.dart';
import '../styles/consts.dart';

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
    String selectedStatus = 'Çalışıyor';
    String selectedHealthStatus = 'Good';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Yeni Cihaz Ekle',
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Cihaz Adı',
                    labelStyle: TextStyle(color: primaryTextColor),
                    filled: true,
                    fillColor: bgPrimaryColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryTextColor, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cihaz Tipi',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: bgPrimaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedType,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: primaryTextColor),
                          dropdownColor: bgPrimaryColor,
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          items: [
                            'Physical Server',
                            'Virtual Server',
                            'Database Server'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedType = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'İşletim Sistemi',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: bgPrimaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedOS,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: primaryTextColor),
                          dropdownColor: bgPrimaryColor,
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          items: [
                            'Windows Server',
                            'Linux Server',
                            'MacOS Server'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedOS = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  controller: ipAddressController,
                  decoration: InputDecoration(
                    labelText: 'IP Adresi',
                    labelStyle: TextStyle(color: primaryTextColor),
                    filled: true,
                    fillColor: bgPrimaryColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryTextColor, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Çalışma Durumu',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: bgPrimaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedStatus,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: primaryTextColor),
                          dropdownColor: bgPrimaryColor,
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          items:
                              ['Çalışıyor', 'Çalışmıyor'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedStatus = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sağlık Durumu',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: bgPrimaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedHealthStatus,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down,
                              color: primaryTextColor),
                          dropdownColor: bgPrimaryColor,
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          items: ['Good', 'Requires Check', 'Critical']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedHealthStatus = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'İptal',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final device = DeviceDTO(
                  name: nameController.text,
                  type: selectedType,
                  operatingSystem: selectedOS,
                  ipAddress: ipAddressController.text,
                  status: selectedStatus,
                  healthStatus: selectedHealthStatus,
                );
                _addDevice(device);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Ekle',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
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
