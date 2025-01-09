import 'package:flutter/material.dart';
import 'package:nimbus_pulse/layout/main_layout.dart';
import 'package:nimbus_pulse/layout/header.dart';
import 'package:nimbus_pulse/services/report_export_service.dart';
import 'package:nimbus_pulse/models/report_model.dart';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final TextEditingController _searchController = TextEditingController();
  // final ReportExportService _exportService = ReportExportService();
  String? selectedDevice;
  String? selectedProperty;
  String? selectedDate;
  String? selectedSort;
  String? selectedExportFormat;
  bool _isExporting = false;

  // Statik veri listesi
  List<Report> _reports = Report.sampleReports;
  List<Report> _filteredReports = [];

  @override
  void initState() {
    super.initState();
    _filteredReports = _reports;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _filterReports();
  }

  void _filterReports() {
    setState(() {
      var searchResults = Report.search(_searchController.text, _reports);
      _filteredReports = Report.filter(
        reports: searchResults,
        device: selectedDevice,
        property: selectedProperty,
        dateRange: selectedDate,
        sortOrder: selectedSort,
      );
    });
  }

  Future<void> _handleExport(String? format) async {
    if (format == null) return;

    setState(() {
      _isExporting = true;
      selectedExportFormat = format;
    });

    try {
      final reportData = _filteredReports
          .map((report) => {
                'deviceName': report.deviceName,
                'ipAddress': report.ipAddress,
                'property': report.property,
                'date': report.date,
              })
          .toList();

      // await _exportService.exportReport(format, reportData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rapor başarıyla dışa aktarıldı'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rapor dışa aktarılırken hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
          selectedExportFormat = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return MainLayout(
      body: SafeArea(
        child: Column(
          children: [
            Header(title: 'Reports'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark ? Color(0xFF2D2D2D) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? Color(0xFF404040) : Color(0xFFE5E5E5),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search,
                              color: Color(0xFF177EC6), size: 20),
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white70 : Color(0xFF64748B),
                            fontSize: 14,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Filters - First Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildFilterDropdown(
                            'Cihaz Seçin',
                            selectedDevice,
                            Report.devices,
                            (value) {
                              setState(() => selectedDevice = value);
                              _filterReports();
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildFilterDropdown(
                            'Özellik Seçin',
                            selectedProperty,
                            Report.properties,
                            (value) {
                              setState(() => selectedProperty = value);
                              _filterReports();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    // Filters - Second Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildFilterDropdown(
                            'Tarih',
                            selectedDate,
                            Report.dateRanges,
                            (value) {
                              setState(() => selectedDate = value);
                              _filterReports();
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildFilterDropdown(
                            'Sıralama',
                            selectedSort,
                            Report.sortOptions,
                            (value) {
                              setState(() => selectedSort = value);
                              _filterReports();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Reports List
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredReports.length,
                        itemBuilder: (context, index) {
                          final report = _filteredReports[index];
                          return _buildReportItem(isDark, report);
                        },
                      ),
                    ),
                    // Export Button
                    Container(
                      width: double.infinity,
                      child: _buildExportDropdown(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(bool isDark, Report report) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Color(0xFF404040) : Color(0xFFE5E5E5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                report.deviceName,
                style: TextStyle(
                  color: isDark ? Colors.white : Color(0xFF2D2D2D),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                report.date,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Color(0xFF64748B),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                report.ipAddress,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Color(0xFF64748B),
                  fontSize: 13,
                ),
              ),
              Text(
                report.property,
                style: TextStyle(
                  color: Color(0xFF177EC6),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String hint,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF2D2D2D) : Color(0xFFEFF8FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Color(0xFF404040) : Color(0xFFD9D9D9),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(
              color: isDark ? Colors.white70 : Color(0xFF64748B),
              fontSize: 13,
            ),
          ),
          icon: Icon(Icons.keyboard_arrow_down,
              color: Color(0xFF177EC6), size: 20),
          dropdownColor: isDark ? Color(0xFF2D2D2D) : Colors.white,
          style: TextStyle(
            color: isDark ? Colors.white : Color(0xFF2D2D2D),
            fontSize: 13,
          ),
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildExportDropdown() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Color(0xFF177EC6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedExportFormat,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isExporting)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                else
                  Icon(Icons.file_download_outlined,
                      color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  _isExporting ? 'Dışa Aktarılıyor...' : 'Raporu Dışarı Aktar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
          dropdownColor: Color(0xFF177EC6),
          style: TextStyle(color: Colors.white, fontSize: 14),
          isExpanded: true,
          items: _isExporting
              ? null
              : ['PDF', 'Excel', 'CSV'].map((String format) {
                  return DropdownMenuItem<String>(
                    value: format,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(format),
                    ),
                  );
                }).toList(),
          onChanged: _isExporting ? null : _handleExport,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
