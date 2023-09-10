import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
  const OverlapSquare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        children: [
          Container(
            color: Colors.red,
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(1),
                  blurRadius: 100,
                  blurStyle: BlurStyle.inner,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
