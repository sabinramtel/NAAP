import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// The NAAP mark: blue tile, white "N" posts and a yellow tape measure.
/// [progress] runs from 0 to 1 and draws the mark piece by piece (US-010).
/// Drawn in code, so it needs no image file and stays sharp at any size.
class NaapLogo extends StatelessWidget {
  final double size;
  final double progress;

  const NaapLogo({super.key, this.size = 96, this.progress = 1});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LogoPainter(progress.clamp(0.0, 1.0))),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final double p;
  _LogoPainter(this.p);

  /// Maps the overall progress to the progress of one step that runs from [start] to [end].
  double _step(double start, double end) => ((p - start) / (end - start)).clamp(0.0, 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;

    // 1. Tile pops in (0.00 - 0.30)
    final tile = Curves.easeOutBack.transform(_step(0.0, 0.3));
    if (tile <= 0) return;
    canvas.save();
    canvas.translate(s / 2, s / 2);
    canvas.scale(tile);
    canvas.translate(-s / 2, -s / 2);
    final rect = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(s * 0.24));
    canvas.drawRRect(rect, Paint()..color = AppColors.blue);

    final top = s * 0.28, bottom = s * 0.72, left = s * 0.32, right = s * 0.68;
    final post = Paint()
      ..color = Colors.white
      ..strokeWidth = s * 0.12
      ..strokeCap = StrokeCap.round;
    final tape = Paint()
      ..color = AppColors.tape
      ..strokeWidth = s * 0.12
      ..strokeCap = StrokeCap.round;
    final tick = Paint()
      ..color = AppColors.navy
      ..strokeWidth = s * 0.02
      ..strokeCap = StrokeCap.round;

    // 2. Left post draws upwards (0.25 - 0.45)
    final a = _step(0.25, 0.45);
    if (a > 0) {
      canvas.drawLine(Offset(left, bottom), Offset(left, _lerp(bottom, top, a)), post);
    }

    // 3. Tape draws diagonally (0.45 - 0.65)
    final b = _step(0.45, 0.65);
    if (b > 0) {
      canvas.drawLine(Offset(left, top),
          Offset(_lerp(left, right, b), _lerp(top, bottom, b)), tape);
    }

    // 4. Tick marks appear one by one (0.60 - 0.80)
    final c = _step(0.6, 0.8);
    const ticks = 5;
    final dx = right - left, dy = bottom - top;
    final len = s * 0.05;
    for (var i = 0; i < (c * ticks).ceil() && i < ticks; i++) {
      final t = 0.2 + i * 0.15;
      final cx = left + dx * t, cy = top + dy * t;
      // a short line across the tape, at right angles to it
      canvas.drawLine(Offset(cx - len * 0.77, cy + len * 0.64), Offset(cx + len * 0.77, cy - len * 0.64), tick);
    }

    // 5. Right post draws upwards (0.75 - 0.95)
    final d = _step(0.75, 0.95);
    if (d > 0) {
      canvas.drawLine(Offset(right, bottom), Offset(right, _lerp(bottom, top, d)), post);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_LogoPainter old) => old.p != p;
}

/// Straight-line blend between [a] and [b]. t = 0 gives a, t = 1 gives b.
double _lerp(double a, double b, double t) => a + (b - a) * t;
