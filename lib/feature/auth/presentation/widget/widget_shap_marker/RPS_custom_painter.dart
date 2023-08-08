import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Square

    Paint paint_fill_1 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_1 = Path();
    path_1.moveTo(size.width * -0.0000000, 0);
    path_1.quadraticBezierTo(size.width * 0.0484377, size.height * 0.0000000, size.width * 0.0645836, size.height * 0.0000000);
    path_1.cubicTo(size.width * -0.1262875, size.height * 0.4548800, size.width * 0.1821750, size.height * 0.5072400, size.width * 0.0020875, size.height * 0.9993600);
    path_1.quadraticBezierTo(size.width * -0.0449875, size.height * 0.9993000, size.width * 0.0000000, size.height * 1.0033558);
    path_1.lineTo(size.width * -0.0000000, 0);
    path_1.close();

    canvas.drawPath(path_1, paint_fill_1);

    // Square
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
