import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
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
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalMs = widget.total.inMilliseconds.clamp(1, 1 << 31);
    final leftMs = _left.inMilliseconds.clamp(0, totalMs);
    final progress = leftMs / totalMs; // 1.0 -> 0.0
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    final bg = widget.backgroundColor ?? Colors.grey.shade300;
    final textStyle = widget.textStyle ?? Theme.of(context).textTheme.headlineSmall;

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
              backgroundColor: Colors.transparent,
            ),
          ),
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: widget.strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              backgroundColor: Colors.transparent,
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
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey[700]),
            ),
          )
        ],
      ),
    );
  }
}
