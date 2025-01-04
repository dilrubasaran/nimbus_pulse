import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../layout/main_layout.dart';
import '../services/device_details_service.dart';
import '../dtos/device_details_dto.dart';
import '../core/network/dio_client.dart';
import '../styles/consts.dart';

class ResourceData {
  final double time;
  final double value;

  ResourceData(this.time, this.value);
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late DeviceDetailsService _deviceDetailsService;
  DeviceDetailsDTO? _deviceDetails;
  bool _isLoading = true;
  String? _error;
  bool _isInitialized = false;
  late TooltipBehavior tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _deviceDetailsService = DeviceDetailsService(DioClient());
    tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _loadDeviceDetails();
      _isInitialized = true;
    }
  }

  Future<void> _loadDeviceDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final args = ModalRoute.of(context)?.settings.arguments;
      print('\n=== Dashboard Arguments ===');
      print('Raw Args: $args');

      if (args == null) {
        throw Exception('No arguments provided');
      }

      final Map<String, dynamic> argsMap = args as Map<String, dynamic>;
      print('Args Map: $argsMap');

      if (!argsMap.containsKey('deviceId')) {
        throw Exception('Device ID not found in arguments');
      }

      final deviceId = argsMap['deviceId'].toString();
      print('Device ID: $deviceId');

      final details = await _deviceDetailsService.getDeviceDetails(deviceId);

      if (mounted) {
        setState(() {
          _deviceDetails = details;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading device details: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  // Son güncelleme tarihini formatlayan yardımcı metod
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDeviceInfo(),
                      SizedBox(height: 24),
                      _buildResourceGauges(),
                      SizedBox(height: 24),
                      _buildResourceCharts(),
                      SizedBox(height: 24),
                      _buildRunningApplications(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDeviceInfo() {
    if (_deviceDetails == null) return SizedBox();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgPrimaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildInfoChip(Icons.computer, _deviceDetails!.name),
              _buildInfoChip(Icons.laptop, _deviceDetails!.type),
              _buildInfoChip(Icons.memory, _deviceDetails!.healthStatus),
              _buildInfoChip(Icons.wifi, _deviceDetails!.ipAddress),
              _buildInfoChip(
                  Icons.computer_outlined, _deviceDetails!.operatingSystem),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.blue, size: 16),
              SizedBox(width: 8),
              Text(
                "Son Güncelleme:",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontFamily: fontNunitoSans,
                ),
              ),
              SizedBox(width: 8),
              Text(
                _formatDateTime(_deviceDetails!.lastReportDate),
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontFamily: fontNunitoSans,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, color: Colors.red, size: 16),
                SizedBox(width: 8),
                Text(
                  "Cihazı Yeniden Başlat",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontFamily: fontNunitoSans,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.blue, size: 16),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
              fontFamily: fontNunitoSans,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceGauges() {
    if (_deviceDetails == null) return SizedBox();

    return LayoutBuilder(
      builder: (context, constraints) {
        double gaugeSize = constraints.maxWidth > 900
            ? (constraints.maxWidth - 64) / 3
            : constraints.maxWidth > 600
                ? (constraints.maxWidth - 48) / 2
                : constraints.maxWidth - 32;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildGauge(
              "RAM",
              _deviceDetails!.resourceUsage.currentRamUsage / 100,
              Colors.amber,
              gaugeSize,
            ),
            _buildGauge(
              "CPU",
              _deviceDetails!.resourceUsage.currentCpuUsage / 100,
              Colors.blue,
              gaugeSize,
            ),
            _buildGauge(
              "Disk",
              _deviceDetails!.resourceUsage.currentDiskUsage / 100,
              Colors.purple,
              gaugeSize,
            ),
          ],
        );
      },
    );
  }

  Widget _buildGauge(String title, double value, Color color, double size) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgPrimaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
              fontFamily: fontNunitoSans,
            ),
          ),
          Expanded(
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 100,
                  showLabels: false,
                  showTicks: false,
                  startAngle: 180,
                  endAngle: 0,
                  radiusFactor: 0.8,
                  axisLineStyle: AxisLineStyle(
                    thickness: 0.2,
                    color: color.withOpacity(0.2),
                    thicknessUnit: GaugeSizeUnit.factor,
                  ),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: value * 100,
                      width: 0.2,
                      sizeUnit: GaugeSizeUnit.factor,
                      color: color,
                      enableAnimation: true,
                      animationDuration: 1000,
                      animationType: AnimationType.ease,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Text(
                        '${(value * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontFamily: fontNunitoSans,
                        ),
                      ),
                      positionFactor: 0.5,
                      angle: 90,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCharts() {
    if (_deviceDetails == null) return SizedBox();

    final cpuData = _deviceDetails!.resourceUsage.cpuHistory
        .asMap()
        .entries
        .map((e) => ResourceData(e.key.toDouble(), e.value))
        .toList();

    final ramData = _deviceDetails!.resourceUsage.ramHistory
        .asMap()
        .entries
        .map((e) => ResourceData(e.key.toDouble(), e.value))
        .toList();

    return Column(
      children: [
        Container(
          height: 200,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgPrimaryColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SfCartesianChart(
            title: ChartTitle(
              text: 'CPU Dağılımı',
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
                fontFamily: fontNunitoSans,
              ),
            ),
            primaryXAxis: NumericAxis(
              labelStyle: TextStyle(
                color: secondaryTextColor,
                fontFamily: fontNunitoSans,
              ),
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 100,
              labelStyle: TextStyle(
                color: secondaryTextColor,
                fontFamily: fontNunitoSans,
              ),
            ),
            series: <ChartSeries>[
              LineSeries<ResourceData, double>(
                dataSource: cpuData,
                xValueMapper: (ResourceData data, _) => data.time,
                yValueMapper: (ResourceData data, _) => data.value,
                color: Colors.blue,
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 200,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgPrimaryColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SfCartesianChart(
            title: ChartTitle(
              text: 'RAM Dağılımı',
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
                fontFamily: fontNunitoSans,
              ),
            ),
            primaryXAxis: NumericAxis(
              labelStyle: TextStyle(
                color: secondaryTextColor,
                fontFamily: fontNunitoSans,
              ),
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 100,
              labelStyle: TextStyle(
                color: secondaryTextColor,
                fontFamily: fontNunitoSans,
              ),
            ),
            series: <ChartSeries>[
              LineSeries<ResourceData, double>(
                dataSource: ramData,
                xValueMapper: (ResourceData data, _) => data.time,
                yValueMapper: (ResourceData data, _) => data.value,
                color: Colors.amber,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRunningApplications() {
    if (_deviceDetails == null) return SizedBox();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWebView = constraints.maxWidth > 1200;

        if (isWebView) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildBackgroundAppsTable(),
              ),
              SizedBox(width: 24),
              Expanded(
                flex: 3,
                child: _buildActiveAppsGrid(),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackgroundAppsTable(),
            SizedBox(height: 24),
            _buildActiveAppsGrid(),
          ],
        );
      },
    );
  }

  Widget _buildBackgroundAppsTable() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgPrimaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Arka Planda Çalışan Uygulamalar",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
              fontFamily: fontNunitoSans,
            ),
          ),
          SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Uygulama İsmi',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: fontNunitoSans,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Çalışma Süresi',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: fontNunitoSans,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'CPU',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: fontNunitoSans,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'RAM',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: fontNunitoSans,
                      ),
                    ),
                  ),
                ],
              ),
              ..._deviceDetails!.backgroundApplications.map(
                (app) => TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        app.name,
                        style: TextStyle(
                          color: Colors.blue[200],
                          fontSize: 14,
                          fontFamily: fontNunitoSans,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        app.runningTime,
                        style: TextStyle(
                          color: Colors.blue[200],
                          fontSize: 14,
                          fontFamily: fontNunitoSans,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        app.cpuUsage.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.blue[200],
                          fontSize: 14,
                          fontFamily: fontNunitoSans,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        app.ramUsage.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.blue[200],
                          fontSize: 14,
                          fontFamily: fontNunitoSans,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveAppsGrid() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgPrimaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Aktif Çalışan Uygulamalar",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
              fontFamily: fontNunitoSans,
            ),
          ),
          SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth > 900
                  ? (constraints.maxWidth - 48) / 3
                  : constraints.maxWidth > 600
                      ? (constraints.maxWidth - 32) / 2
                      : constraints.maxWidth;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _deviceDetails!.activeApplications
                    .map((app) => _buildActiveAppCard(cardWidth, app))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActiveAppCard(double width, ActiveAppDTO app) {
    final cpuData = app.cpuHistory
        .asMap()
        .entries
        .map((e) => ResourceData(e.key.toDouble(), e.value))
        .toList();

    final ramData = app.ramHistory
        .asMap()
        .entries
        .map((e) => ResourceData(e.key.toDouble(), e.value))
        .toList();

    return Container(
      width: width,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.computer, color: Colors.blue, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryTextColor,
                        fontFamily: fontNunitoSans,
                      ),
                    ),
                    Text(
                      app.runningTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryTextColor,
                        fontFamily: fontNunitoSans,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Çalışıyor",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontFamily: fontNunitoSans,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "CPU",
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryTextColor,
                            fontFamily: fontNunitoSans,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "${app.cpuUsage.toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 12,
                            color: primaryTextColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: fontNunitoSans,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Container(
                      height: 30,
                      child: SfCartesianChart(
                        margin: EdgeInsets.zero,
                        primaryXAxis: NumericAxis(isVisible: false),
                        primaryYAxis: NumericAxis(isVisible: false),
                        plotAreaBorderWidth: 0,
                        series: <ChartSeries>[
                          SplineAreaSeries<ResourceData, double>(
                            dataSource: cpuData,
                            xValueMapper: (ResourceData data, _) => data.time,
                            yValueMapper: (ResourceData data, _) => data.value,
                            color: Colors.blue.withOpacity(0.2),
                            borderColor: Colors.blue,
                            borderWidth: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "RAM",
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryTextColor,
                            fontFamily: fontNunitoSans,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "${app.ramUsage.toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 12,
                            color: primaryTextColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: fontNunitoSans,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Container(
                      height: 30,
                      child: SfCartesianChart(
                        margin: EdgeInsets.zero,
                        primaryXAxis: NumericAxis(isVisible: false),
                        primaryYAxis: NumericAxis(isVisible: false),
                        plotAreaBorderWidth: 0,
                        series: <ChartSeries>[
                          SplineAreaSeries<ResourceData, double>(
                            dataSource: ramData,
                            xValueMapper: (ResourceData data, _) => data.time,
                            yValueMapper: (ResourceData data, _) => data.value,
                            color: Colors.amber.withOpacity(0.2),
                            borderColor: Colors.amber,
                            borderWidth: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
