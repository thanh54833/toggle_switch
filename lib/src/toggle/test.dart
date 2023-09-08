import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          // child: Container(
          //   height: 100,
          //   width: 100,
          //   clipBehavior: Clip.hardEdge,
          //   decoration: const BoxDecoration(),
          //   child: Container(
          //     height: 300,
          //     width: 300,
          //     color: Colors.red,
          //   ),
          // ),
          child: OverlapSquare(),
        ),
      ),
    );
  }
}

class OverlapSquare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red,
      ),
      child: OverflowBox(
        child: ClipRect(
          clipBehavior: Clip.hardEdge,
          child: OverflowBox(
            maxHeight: 250,
            maxWidth: 250,
            child: Center(
              child: SizedBox(
                height: 200,
                width: 250,
                child: Image.asset(
                  "assets/bg_moon.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width, size.height * 0.5128205);
    path_0.cubicTo(size.width, size.height * 0.9744718, size.width * 0.7761424,
        size.height * 1.348718, size.width * 0.5000000, size.height * 1.348718);
    path_0.cubicTo(size.width * 0.2238576, size.height * 1.348718, 0,
        size.height * 0.9744718, 0, size.height * 0.5128205);
    path_0.cubicTo(
        0,
        size.height * 0.05116708,
        size.width * 0.2238576,
        size.height * -0.3230769,
        size.width * 0.5000000,
        size.height * -0.3230769);
    path_0.cubicTo(size.width * 0.7761424, size.height * -0.3230769, size.width,
        size.height * 0.05116708, size.width, size.height * 0.5128205);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff060606).withOpacity(0.3);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
