import 'package:flutter/material.dart';
import 'package:nimbus_pulse/layout/main_layout.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../styles/consts.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _buildInfoChip(Icons.computer, "Mac Pro 16 inc"),
          _buildInfoChip(Icons.laptop, "Laptop"),
          _buildInfoChip(Icons.memory, "İyi"),
          _buildInfoChip(Icons.wifi, "192.168.1.1"),
          _buildInfoChip(Icons.computer_outlined, "Windows 11 Pro"),
          _buildInfoChip(Icons.access_time, "Son Güncelleme: 12.01.2024 15:30"),
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
                  text:
                      'CPU - RAM Gerçek Zamanlı İzleme (6 saatlik durum tahmini)',
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWebView = constraints.maxWidth > 1200;

        if (isWebView) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildRunningAppsTable(),
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
            _buildRunningAppsTable(),
            SizedBox(height: 24),
            _buildActiveAppsGrid(),
          ],
        );
      },
    );
  }

  Widget _buildRunningAppsTable() {
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
                  DataColumn(label: Text("Cpu")),
                  DataColumn(label: Text("Ram")),
                ],
                rows: List.generate(
                  10,
                  (index) => DataRow(
                    cells: [
                      DataCell(Text("Intel(R) Dynamic App")),
                      DataCell(Text("7 saat 30 dk")),
                      DataCell(Text("0,1")),
                      DataCell(Text("25,6")),
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
//Arka Planda Çalışan Uygulamalar Tablosu

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
                children:
                    List.generate(9, (index) => _buildActiveAppCard(cardWidth)),
              );
            },
          ),
        ],
      ),
    );
  }

  //Aktif Uygulama Kart yapısı
  Widget _buildActiveAppCard(double width) {
    // Son 8 veri noktası için örnek veri oluştur
    final sampleData = List.generate(
        8, (index) => ResourceData(index.toDouble(), 45 + (index % 3) * 10.0));
    final sampleRamData = List.generate(
        8, (index) => ResourceData(index.toDouble(), 65 + (index % 4) * 5.0));

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
                      "Visual Studio",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryTextColor,
                        fontFamily: fontNunitoSans,
                      ),
                    ),
                    Text(
                      "5 saat 30 dk ",
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
                          "45%",
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
                            dataSource: sampleData,
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
                          "65%",
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
                            dataSource: sampleRamData,
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

class ResourceData {
  final double time;
  final double value;

  ResourceData(this.time, this.value);
}
