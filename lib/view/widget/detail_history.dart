import 'package:attendance_project/model/history_model.dart';
import 'package:attendance_project/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryDetailPage extends StatelessWidget {
  final History history;

  const HistoryDetailPage({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isIzin = history.status == "izin";
    final bool isAlpha = history.status == "alpha";

    Color textColor;

    if (isIzin) {
      textColor = Colors.orange.shade400;
    } else if (isAlpha) {
      textColor = Colors.grey.shade700;
    } else {
      textColor = const Color(0xFF898AC4);
    }

    return Scaffold(
      backgroundColor: AttendanceColors.background,
      appBar: AppBar(
        title: const Text(
          "Detail History Absen",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: textColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tanggal: ${DateFormat('dd MMMM yyyy').format(history.attendanceDate ?? DateTime.now())}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              "Check In:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: textColor,
              ),
            ),
            Text(
              "Waktu: ${history.checkInTime ?? "-"}",
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            Text(
              "Lokasi: ${history.checkInLocation ?? history.checkInAddress ?? "-"}",
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            const SizedBox(height: 20),

            Text(
              "Check Out:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: textColor,
              ),
            ),
            Text(
              "Waktu: ${history.checkOutTime ?? "-"}",
              style: TextStyle(fontSize: 16, color: textColor),
            ),
            Text(
              "Lokasi: ${history.checkOutLocation ?? history.checkOutAddress ?? "-"}",
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
