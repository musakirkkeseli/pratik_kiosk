import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:kiosk/features/utility/const/constant_color.dart';
import 'package:kiosk/features/utility/extension/color_extension.dart';

class CircularCountdown extends StatefulWidget {
  const CircularCountdown({
    super.key,
    required this.total,
    this.size = 120,
    this.strokeWidth = 8,
    this.color,
    this.backgroundColor,
    this.textStyle,
  });

  final Duration total;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  @override
  State<CircularCountdown> createState() => _CircularCountdownState();
}

class _CircularCountdownState extends State<CircularCountdown> {
  late Duration _left;
  late Duration _initialTotal;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initialTotal = widget.total;
    _left = widget.total;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        final next = _left - const Duration(seconds: 1);
        _left = next.isNegative ? Duration.zero : next;
      });
    });
  }

  @override
  void didUpdateWidget(CircularCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.total != widget.total) {
      _left = widget.total;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalMs = _initialTotal.inMilliseconds.clamp(
      1,
      1 << 31,
    ); // İlk total değerini kullan
    final leftMs = _left.inMilliseconds.clamp(0, totalMs);
    final progress = leftMs / totalMs; // 1.0 -> 0.0
    final color = context.primaryColor;
    final bg = widget.backgroundColor ?? ConstColor.grey300;
    final textStyle =
        widget.textStyle ?? Theme.of(context).textTheme.headlineSmall;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: widget.strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(bg),
              backgroundColor: ConstColor.transparent,
            ),
          ),
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: widget.strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              backgroundColor: ConstColor.transparent,
            ),
          ),
          AnimatedFlipCounter(
            value: _left.inSeconds.clamp(0, 9999).toDouble(),
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeInOutCubic,
            wholeDigits: 1,
            thousandSeparator: '',
            textStyle: textStyle,
          ),
          Positioned(
            bottom: 10,
            child: Text(
              'sn',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: ConstColor.grey700),
            ),
          ),
        ],
      ),
    );
  }
}
