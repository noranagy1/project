import 'package:attendo/core/color_manager.dart';
import 'package:attendo/core/extensions.dart';
import 'package:attendo/core/reusable_components/customButton.dart';
import 'package:attendo/core/reusable_components/customField.dart';
import 'package:attendo/core/utils/controller_mixin.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// ─────────────────────────────────────────
//  COMPLAINT SCREEN
//  Name + Job + Title + Details + Date → Send
// ─────────────────────────────────────────
class ComplaintScreen extends StatefulWidget {
  final bool isDark;
  const ComplaintScreen({super.key, this.isDark = false});
  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}
class _ComplaintScreenState extends State<ComplaintScreen> with ControllerMixin {
  late final _nameCtrl    = ctrl();
  late final _jobCtrl     = ctrl();
  late final _titleCtrl   = ctrl();
  late final _detailsCtrl = ctrl();
  DateTime? _selectedDate;
  bool _isLoading = false;
  @override
  void dispose() {
    _nameCtrl.dispose();
    _jobCtrl.dispose();
    _titleCtrl.dispose();
    _detailsCtrl.dispose();
    super.dispose();
  }
  // ── Date picker ───────────────────────
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: ColorManager.blue,
            onPrimary: Colors.white,
            surface: widget.isDark ? ColorManager.darkCard : Colors.white,
            onSurface: widget.isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }
  String get _dateLabel {
    if (_selectedDate == null) return 'Date of complaint';
    return '${_selectedDate!.day.toString().padLeft(2, '0')}/'
        '${_selectedDate!.month.toString().padLeft(2, '0')}/'
        '${_selectedDate!.year}';
  }
  // ── Submit ────────────────────────────
  Future<void> _submit() async {
    if (_nameCtrl.text.trim().isEmpty ||
        _titleCtrl.text.trim().isEmpty ||
        _detailsCtrl.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    try {
      // TODO: استبدل بـ API call حقيقي
      // await complaintRepo.submit(
      //   name:    _nameCtrl.text.trim(),
      //   job:     _jobCtrl.text.trim(),
      //   title:   _titleCtrl.text.trim(),
      //   details: _detailsCtrl.text.trim(),
      //   date:    _selectedDate,
      // );
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Complaint submitted successfully'),
            backgroundColor: ColorManager.emerald,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.pop(context);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDark ? ColorManager.darkBg : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Back button ───────────
              BackButton(),
              const SizedBox(height: 16),
              // ── Title banner ──────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [ColorManager.blue, ColorManager.blueDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.blue.withOpacity(0.35),
                      blurRadius: 24, offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Submit a formal complaint',
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Fill in the details below',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // ── Name ──────────────────
              _InputField(
                hint: 'Name',
                controller: _nameCtrl,
                isDark: widget.isDark,
              ),
              const SizedBox(height: 14),
              // ── Job / Department ──────
              _InputField(
                hint: 'Job or department',
                controller: _jobCtrl,
                isDark: widget.isDark,
              ),
              const SizedBox(height: 14),
              // ── Report title ──────────
              _InputField(
                hint: 'Report title',
                controller: _titleCtrl,
                isDark: widget.isDark,
              ),
              const SizedBox(height: 14),
              // ── Report details ────────
              _InputField(
                hint: 'Report details',
                controller: _detailsCtrl,
                isDark: widget.isDark,
                maxLines: 5,
              ),
              const SizedBox(height: 14),
              // ── Date picker ───────────
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  decoration: BoxDecoration(
                    color: widget.isDark
                        ? Colors.white.withOpacity(0.04)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _selectedDate != null
                          ? ColorManager.blue.withOpacity(0.4)
                          : (widget.isDark
                          ? Colors.white.withOpacity(0.1)
                          : ColorManager.lightBorder),
                      width: 1.5,
                    ),
                    boxShadow: _selectedDate != null
                        ? [BoxShadow(color: ColorManager.blue.withOpacity(0.1), blurRadius: 0, spreadRadius: 3)]
                        : [],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _dateLabel,
                          style: TextStyle(
                            color: _selectedDate != null
                                ? (widget.isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary)
                                : (widget.isDark ? ColorManager.darkTextSecond : ColorManager.lightTextSecond),
                            fontSize: 14,
                            fontWeight: _selectedDate != null ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                      const Icon(Icons.calendar_month_rounded, color: ColorManager.blue, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // ── Send button ───────────
              AuthButton(
                label: 'Send',
                isLoading: _isLoading,
                onTap: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ─────────────────────────────────────────
//  INPUT FIELD
// ─────────────────────────────────────────
class _InputField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final bool isDark;
  final int maxLines;
  const _InputField({
    required this.hint,
    required this.controller,
    required this.isDark,
    this.maxLines = 1,
  });
  @override
  State<_InputField> createState() => _InputFieldState();
}
class _InputFieldState extends State<_InputField> {
  final _focus = FocusNode();
  bool _focused = false;
  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
  }
  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: _focused
            ? [BoxShadow(color: ColorManager.blue.withOpacity(0.1), blurRadius: 0, spreadRadius: 3)]
            : [],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focus,
        maxLines: widget.maxLines,
        style: TextStyle(
          color: widget.isDark ? ColorManager.darkTextPrimary : ColorManager.lightTextPrimary,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: widget.isDark ? ColorManager.darkTextSecond : ColorManager.lightTextSecond,
            fontSize: 14,
          ),
          filled: true,
          fillColor: widget.isDark ? Colors.white.withOpacity(0.04) : Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: widget.isDark ? Colors.white.withOpacity(0.1) : ColorManager.lightBorder,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: widget.isDark ? Colors.white.withOpacity(0.1) : ColorManager.lightBorder,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: ColorManager.blue.withOpacity(0.5), width: 1.5),
          ),
        ),
      ),
    );
  }
}