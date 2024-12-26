import 'package:flutter/material.dart';
import 'package:nimbus_pulse/layout/main_layout.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../styles/consts.dart';

class DeviceDetailPage extends StatefulWidget {
  final String deviceId;
  final String deviceName;

  const DeviceDetailPage({
    Key? key,
    required this.deviceId,
    required this.deviceName,
  }) : super(key: key);

  @override
  _DeviceDetailPageState createState() => _DeviceDetailPageState();
}

class _DeviceDetailPageState extends State<DeviceDetailPage> {
  late List<ResourceData> cpuData;
  late List<ResourceData> ramData;
  late List<ResourceData> diskData;
  late TooltipBehavior tooltipBehavior;

  @override
  void initState() {
    super.initState();
    tooltipBehavior = TooltipBehavior(enable: true);
    _initializeData();
  }

  void _initializeData() {
    // Örnek veri
    cpuData = List.generate(
      24,
      (index) => ResourceData(
        index.toDouble(),
        45 + (index % 3) * 10.0,
      ),
    );

    ramData = List.generate(
      24,
      (index) => ResourceData(
        index.toDouble(),
        65 + (index % 4) * 5.0,
      ),
    );

    diskData = List.generate(
      24,
      (index) => ResourceData(
        index.toDouble(),
        45 + (index % 5) * 8.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeviceHeader(),
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

  Widget _buildDeviceHeader() {
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
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: primaryTextColor),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(width: 8),
              Text(
                widget.deviceName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                  fontFamily: fontNunitoSans,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildInfoChip(Icons.computer, "Mac Pro 16 inc"),
              _buildInfoChip(Icons.laptop, "Laptop"),
              _buildInfoChip(Icons.memory, "İyi"),
              _buildInfoChip(Icons.wifi, "192.168.1.1"),
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
            _buildGauge("RAM", 0.65, Colors.amber, gaugeSize),
            _buildGauge("CPU", 0.45, Colors.blue, gaugeSize),
            _buildGauge("Disk", 0.45, Colors.purple, gaugeSize),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Container(
              height: 300,
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
                  text: 'CPU - RAM Gerçek Zamanlı İzleme',
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                    fontFamily: fontNunitoSans,
                  ),
                ),
                legend: Legend(isVisible: true),
                tooltipBehavior: tooltipBehavior,
                primaryXAxis: NumericAxis(
                  labelStyle: TextStyle(
                    color: secondaryTextColor,
                    fontFamily: fontNunitoSans,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 100,
                  title: AxisTitle(
                    text: 'Kullanım %',
                    textStyle: TextStyle(
                      color: secondaryTextColor,
                      fontFamily: fontNunitoSans,
                    ),
                  ),
                  labelStyle: TextStyle(
                    color: secondaryTextColor,
                    fontFamily: fontNunitoSans,
                  ),
                ),
                series: <ChartSeries>[
                  LineSeries<ResourceData, double>(
                    name: 'CPU',
                    dataSource: cpuData,
                    xValueMapper: (ResourceData data, _) => data.time,
                    yValueMapper: (ResourceData data, _) => data.value,
                    color: Colors.blue,
                  ),
                  LineSeries<ResourceData, double>(
                    name: 'RAM',
                    dataSource: ramData,
                    xValueMapper: (ResourceData data, _) => data.time,
                    yValueMapper: (ResourceData data, _) => data.value,
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
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
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
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
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildRunningApplications() {
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
            "Çalışan Uygulamalar",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
              fontFamily: fontNunitoSans,
            ),
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Theme(
              data: Theme.of(context).copyWith(
                dataTableTheme: DataTableThemeData(
                  headingTextStyle: TextStyle(
                    color: primaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontNunitoSans,
                  ),
                  dataTextStyle: TextStyle(
                    color: secondaryTextColor,
                    fontFamily: fontNunitoSans,
                  ),
                ),
              ),
              child: DataTable(
                columns: [
                  DataColumn(label: Text("Uygulama İsmi")),
                  DataColumn(label: Text("Çalışma Süresi")),
                  DataColumn(label: Text("CPU")),
                  DataColumn(label: Text("RAM")),
                ],
                rows: List.generate(
                  10,
                  (index) => DataRow(
                    cells: [
                      DataCell(Text("Visual Studio Code")),
                      DataCell(Text("5 saat 30 dk")),
                      DataCell(Text("45%")),
                      DataCell(Text("65%")),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResourceData {
  final double time;
  final double value;

  ResourceData(this.time, this.value);
}
