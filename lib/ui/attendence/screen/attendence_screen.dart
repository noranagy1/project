import 'package:attendo/core/appStyle.dart';
import 'package:attendo/features/auth/data/attendance_model.dart';
import 'package:attendo/features/auth/data/attendance_repo.dart';
import 'package:flutter/material.dart';
class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}
class _AttendanceScreenState extends State<AttendanceScreen> {
  final AttendanceRepo _repo = AttendanceRepo();
  AttendanceModel? attendance;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getAttendance();
  }
  Future<void> getAttendance() async {
    try {
      final data = await _repo.getAttendance();
      if (!mounted) return;
      setState(() {
        attendance = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print(e);
    }
  }
  String formatTime(String? isoDate) {
    if (isoDate == null) return '--:--';
    final dt = DateTime.parse(isoDate).toLocal();
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$hour:$min';
  }
  Color statusColor(String status) {
    switch (status) {
      case 'Late': return Colors.orange;
      case 'Present': return Colors.green;
      case 'Absent': return Colors.red;
      default: return Colors.grey;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Back Button
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFECECEC),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, size: 25),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Attendance Report',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (attendance == null)
                Center(child: Text('No data found'))
              else ...[
                  /// Summary Cards
                  Row(
                    children: [
                      _summaryCard('Present', attendance!.presentDays, Colors.green),
                      SizedBox(width: 10),
                      _summaryCard('Late', attendance!.lateDays, Colors.orange),
                      SizedBox(width: 10),
                      _summaryCard('Absent', attendance!.absentDays, Colors.red),
                    ],
                  ),
                  SizedBox(height: 20),

                  /// Details List
                  Text('Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Expanded(
                    child: attendance!.details.isEmpty
                        ? Center(child: Text('No records found'))
                        : ListView.builder(
                      itemCount: attendance!.details.length,
                      itemBuilder: (context, index) {
                        final date = attendance!.details.keys.elementAt(index);
                        final day = attendance!.details[date]!;
                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(date, style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 6),
                                  Text('Check In: ${formatTime(day.checkIn)}',
                                      style: TextStyle(color: Colors.grey)),
                                  Text('Check Out: ${formatTime(day.checkOut)}',
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: statusColor(day.status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  day.status,
                                  style: TextStyle(
                                    color: statusColor(day.status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
            ],
          ),
        ),
      ),
    );
  }
  Widget _summaryCard(String title, int count, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            SizedBox(height: 4),
            Text(title, style: TextStyle(color: color, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}