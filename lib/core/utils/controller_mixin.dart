import 'package:flutter/material.dart';

/// ControllerMixin
/// ───────────────────────────────────────────────
/// بدل ما تعمل في كل شاشة:
///   final _nameCtrl = TextEditingController();
///   void dispose() { _nameCtrl.dispose(); super.dispose(); }
///
/// بقى بتعمل كده بس:
///   class _MyState extends State<MyScreen> with ControllerMixin {
///     late final name = ctrl();      ← تنشئ controller
///     late final email = ctrl();     ← تنشئ تاني
///   }
///   // dispose بيتعمل أوتوماتيك — مش محتاجة تكتبيه خالص!
///
/// ───────────────────────────────────────────────
mixin ControllerMixin<T extends StatefulWidget> on State<T> {
  final List<TextEditingController> _controllers = [];

  /// اعملي controller جديد — بيتسجل أوتوماتيك للـ dispose
  TextEditingController ctrl([String initialText = '']) {
    final c = TextEditingController(text: initialText);
    _controllers.add(c);
    return c;
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }
}