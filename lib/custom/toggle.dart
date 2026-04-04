import 'package:flutter/material.dart';
import 'package:new_project/design/AppColor.dart';

class ToggleSwitch extends StatefulWidget {
  final ValueChanged<bool>? onChanged;
  final bool value;

  const ToggleSwitch({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch>
    with SingleTickerProviderStateMixin {

  bool isChecked = false;
  final Duration _duration = const Duration(milliseconds: 370);

  late Animation<Alignment> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    isChecked = widget.value;

    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
    );

    _animation = AlignmentTween(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceOut,
        reverseCurve: Curves.bounceIn,
      ),
    );

    if (isChecked) {
      _animationController.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant ToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value) {
      isChecked = widget.value;

      if (isChecked) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggle() {
    setState(() {
      isChecked = !isChecked;

      if (isChecked) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }

      widget.onChanged?.call(isChecked);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: toggle,
          child: Container(
            width: 55,
            height: 28,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isChecked ? AppColor.green : AppColor.softGray,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Align(
              alignment: _animation.value,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}