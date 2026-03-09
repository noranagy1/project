import 'package:attendo/core/color_manager.dart';
import 'package:attendo/features/auth/data/auth_repo.dart';
import 'package:attendo/providers/theme_provider.dart';
import 'package:attendo/ui/attendence/widget/attendance_model.dart';
import 'package:attendo/ui/attendence/widget/overview_bar.dart';
import 'package:attendo/ui/attendence/widget/report_card.dart';
import 'package:attendo/ui/attendence/widget/weekly_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ─────────────────────────────────────────
//  REPORT SCREEN
// ─────────────────────────────────────────
class ReportScreen extends StatefulWidget {
   const ReportScreen({super.key});
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}
class _ReportScreenState extends State<ReportScreen> {
  bool _isLoading = true;
  MonthlyReport? _report;
  DateTime _selectedMonth = DateTime.now();
  AuthRepo authRepo = AuthRepo();
  @override
  void initState() {
    super.initState();
    _fetchReport();
  }
  // ── Fetch from API via Repo ───────────
  Future<void> _fetchReport() async {
    setState(() => _isLoading = true);
    try {
      final report = await authRepo.getMonthlyReport();
      setState(() => _report = report);
    } catch (e) {
      debugPrint('Error fetching report: $e');
      setState(() => _report = null);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  // ── Month picker ──────────────────────
  Future<void> _pickMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null) {
      setState(() => _selectedMonth = picked);
      _fetchReport();
    }
  }
  String get _monthLabel {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[_selectedMonth.month - 1]} ${_selectedMonth.year}';
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return Scaffold(
      backgroundColor: isDark ? ColorManager.darkBg : const Color(0xFFF1F5F9),
      body: Column(
        children: [
          // ── Gradient Header ───────────
          _buildHeader(),
          // ── Content ───────────────────
          Expanded(
            child: _isLoading
                ? _buildLoader()
                : _report == null
                ? _buildError()
                : _buildContent(),
          ),
        ],
      ),
    );
  }
  // ── Header ────────────────────────────
  Widget _buildHeader() {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E3A5F), ColorManager.darkBg]
              : [const Color(0xFF1E3A5F), ColorManager.blueDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
          child: Column(
            children: [
              // Title row
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 22),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Attendance Report',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 34),
                ],
              ),
              const SizedBox(height: 14),
              // Month picker
              GestureDetector(
                onTap: _pickMonth,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded, color: Colors.white70, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _monthLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white60, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // ── Content ───────────────────────────
  Widget _buildContent() {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final report = _report!;
    return RefreshIndicator(
      onRefresh: _fetchReport,
      color: ColorManager.blue,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Summary cards
            ReportSummaryCards(summary: report.summary, isDark: isDark),
            const SizedBox(height: 14),
            // Overview bar
            ReportOverviewBar(summary: report.summary, isDark: isDark),
            const SizedBox(height: 14),
            // Week sections
            ...report.weekGroups.map((week) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: ReportWeekSection(week: week, isDark: isDark),
            )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
  Widget _buildLoader() => const Center(
    child: CircularProgressIndicator(color: ColorManager.blue),
  );
  Widget _buildError() {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('⚠️', style: TextStyle(fontSize: 40)),
        const SizedBox(height: 12),
        Text('Failed to load report', style: TextStyle(color: isDark ? ColorManager.darkTextSecond : ColorManager.lightTextSecond)),
        const SizedBox(height: 16),
        TextButton(onPressed: _fetchReport, child: const Text('Try Again')),
      ],
    ),
  );
}
}