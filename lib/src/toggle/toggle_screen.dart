import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

enum ToggleType {
  sun,
  moon,
}

class ToggleController extends ChangeNotifier {
  late AnimationController animationController;
  late AnimationController gentleController;
  late Animation<double> animation;
  late Animation<Color?> colorAnimation;
  late Animation<double> gentle;
  var toggleType = ToggleType.sun;

  var begin = 0.0;
  var end = 1.0;
  var beginGentle = 0.0;
  var endGentle = 10.0;

  void init(TickerProviderStateMixin provider) {
    animationController = AnimationController(
      vsync: provider,
      duration: const Duration(milliseconds: 500),
    );

    animation = Tween<double>(begin: begin, end: end).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    colorAnimation = ColorTween(
      begin: const Color(0xff00B1FD),
      end: const Color(0xff171B1D),
    ).animate(animationController);

    gentleController = AnimationController(
      vsync: provider,
      duration: const Duration(milliseconds: 500),
    );

    gentle = Tween<double>(begin: 0, end: 10).animate(CurvedAnimation(
      parent: gentleController,
      curve: Curves.easeInOut,
    ));

    animationController.addListener(() {
      if (animationController.value == 0) {
        toggleType = ToggleType.sun;
      } else if (animationController.value == 1) {
        toggleType = ToggleType.moon;
      }
    });
    onTap();
  }

  onTap() {
    if (animationController.value == 0) {
      animationController.forward().whenComplete(
        () {
          gentleController.forward().whenComplete(() {});
        },
      );
    } else {
      animationController.reverse().whenComplete(() {
        gentleController.reverse().whenComplete(() {});
      });
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class ToggleScreen extends StatefulWidget {
  const ToggleScreen({Key? key}) : super(key: key);

  @override
  State<ToggleScreen> createState() => _ToggleScreenState();
}

class _ToggleScreenState extends State<ToggleScreen>
    with TickerProviderStateMixin {
  ToggleController controller = ToggleController();

  @override
  void initState() {
    super.initState();
    controller.init(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            controller.onTap();
          },
          child: _toggleWidget(),
        ),
      ),
    );
  }

  var widthToggle = 300.0;
  var heightToggle = 125.0;
  var sizeThumb = 100.0;
  var marginHorizontal = 12.0;
  var borderRadius = 60.0;

  _toggleWidget() {
    var distanceMove = widthToggle - sizeThumb - 2 * marginHorizontal;
    return Container(
      height: heightToggle,
      width: widthToggle,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            borderRadius,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(
                borderRadius,
              ),
            ),
            child: Stack(
              children: [
                _backgroundColorWidget(),
                _backgroundImageWidget(
                  heightToggle: heightToggle,
                  widthToggle: widthToggle,
                ),
                AnimatedBuilder(
                  animation: Listenable.merge([
                    controller.animation,
                    controller.gentle,
                  ]),
                  builder: (context, child) {
                    var gentleValue = controller.gentle.value;
                    if (gentleValue >= 5) {
                      gentleValue = controller.endGentle / 2 - gentleValue;
                    }
                    var x =
                        distanceMove * (controller.animation.value - 1 / 2) +
                            gentleValue;
                    return Transform.translate(
                      offset: Offset(x, 0),
                      child: _thumbWidget(
                        sizeThumb: sizeThumb,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  borderRadius,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(3 + 1, 3 + 5),
                  blurRadius: 2,
                  color: Colors.black.withOpacity(0.5),
                  inset: true,
                ),
              ],
              border: Border.all(
                width: 6,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _backgroundColorWidget() {
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        return Container(
          color: controller.colorAnimation.value,
        );
      },
    );
  }

  _backgroundImageWidget({
    required var widthToggle,
    required var heightToggle,
  }) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        controller.animation,
        controller.gentle,
      ]),
      builder: (context, child) {
        var value = controller.animationController.value;
        var gentleValue = controller.gentle.value;
        if (gentleValue >= controller.endGentle / 2) {
          gentleValue = controller.endGentle / 2 - gentleValue;
        }
        var heightMoon = heightToggle * value + gentleValue;
        var heightSun = heightToggle * value - heightToggle + gentleValue;
        return Stack(
          children: [
            Transform.translate(
              offset: Offset(0, heightMoon),
              child: SizedBox(
                height: heightToggle,
                width: widthToggle,
                child: OverflowBox(
                  child: ClipRect(
                    clipBehavior: Clip.hardEdge,
                    child: OverflowBox(
                      maxHeight: heightToggle,
                      maxWidth: widthToggle,
                      child: Image.asset(
                        "assets/bg_sun.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, heightSun),
              child: Container(
                padding: const EdgeInsets.only(left: 40),
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 100,
                  width: 125,
                  child: Image.asset(
                    "assets/bg_moon.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _thumbWidget({
    required double sizeThumb,
  }) {
    var value = controller.animationController.value;
    return Stack(
      alignment: Alignment.center,
      children: [
        _circleWidget(),
        SizedBox(
          height: sizeThumb,
          width: sizeThumb,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      offset: const Offset(4, 4),
                      blurRadius: 5,
                    ),
                    BoxShadow(
                      color: value == 0
                          ? const Color(0xFFF7B858)
                          : const Color(0xFFC4D4D6),
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFFFFFF).withOpacity(0.58),
                      const Color(0xFFFFFFFF).withOpacity(0.58),
                      Colors.transparent,
                      const Color(0xFF000000).withOpacity(0.25),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Stack(
                children: [
                  Opacity(
                    opacity: 1 - value,
                    child: _moonSunWidget(
                      const Color(0xFFF7B858),
                    ),
                  ),
                  Opacity(
                    opacity: value,
                    child: Stack(
                      children: [
                        _moonSunWidget(
                          const Color(0xFFC4D4D6),
                        ),
                        Stack(
                          children: [
                            Positioned(
                              left: 30,
                              top: 10,
                              child: _childMoonWidget(15),
                            ),
                            Positioned(
                              left: 15,
                              top: 34,
                              child: _childMoonWidget(8),
                            ),
                            Positioned(
                              left: 55,
                              top: 31,
                              child: _childMoonWidget(19),
                            ),
                            Positioned(
                              left: 55,
                              top: 52,
                              child: _childMoonWidget(11),
                            ),
                            Positioned(
                              left: 18,
                              top: 55,
                              child: _childMoonWidget(14),
                            ),
                            Positioned(
                              left: 70,
                              top: 52,
                              child: _childMoonWidget(22),
                            ),
                            Positioned(
                              left: 43,
                              top: 64,
                              child: _childMoonWidget(15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  _moonSunWidget(Color color) {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 1,
          ),
        ],
      ),
    );
  }

  _childMoonWidget(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.all(0.5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0xFFB3C7CA),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  _circleWidget() {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(
        3,
        (index) {
          var size = 150 + (60 * index);
          return OverflowBox(
            child: ClipRect(
              clipBehavior: Clip.hardEdge,
              child: OverflowBox(
                maxHeight: size.toDouble(),
                maxWidth: size.toDouble(),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5 - index * 0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
