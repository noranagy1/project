import 'package:attendo/core/appStyle.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/features/auth/data/qr_repo.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
class QrScreen extends StatefulWidget {
  const QrScreen({super.key});
  @override
  State<QrScreen> createState() => _QrScreenState();
}
class _QrScreenState extends State<QrScreen> {
  final QrRepo _qrRepo = QrRepo();
  late Future<String?> _qrFuture;
  @override
  void initState() {
    super.initState();
    _qrFuture = _qrRepo.getQrData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFECECEC),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      size: 30,
                      Icons.arrow_back_ios_new,
                      color: Color(0xFF1E1E1E),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
              ),
              SizedBox(height: 80),
              Center(
                child: FutureBuilder<String?>(
                  future: _qrFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('context.l10n.error: ${snapshot.error}');
                    }
                    if (snapshot.data == null) {
                      return Text(context.l10n.no_qr_data);
                    }
                    return QrImageView(
                      data: snapshot.data!,
                      version: QrVersions.auto,
                      size: 250.0,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}