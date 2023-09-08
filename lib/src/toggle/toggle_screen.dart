import 'package:flutter/material.dart';

class ToggleController extends ChangeNotifier {
  late AnimationController animationController;
  late Animation<double> animation;
  late Animation<Color?> colorAnimation;

  void init(SingleTickerProviderStateMixin provider) {
    animationController = AnimationController(
      vsync: provider,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(animationController);

    colorAnimation = ColorTween(
      begin: const Color(0xff00B1FD),
      end: const Color(0xff171B1D),
    ).animate(animationController);
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
    with SingleTickerProviderStateMixin {
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
            if (controller.animationController.value == 1) {
              controller.animationController.reverse();
            } else {
              controller.animationController.forward();
            }
          },
          child: _toggleWidget(),
        ),
      ),
    );
  }

  _toggleWidget() {
    var widthToggle = 300.0;
    var heightToggle = 120.0;
    var sizeThumb = 100.0;
    var marginLeft = 8.0;
    return SizedBox(
      height: heightToggle,
      width: widthToggle,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            60,
          ),
        ),
        child: SizedBox(
          child: Stack(
            children: [
              _backgroundColorWidget(),
              _backgroundWidget(
                heightToggle: heightToggle,
                widthToggle: widthToggle,
              ),
              AnimatedBuilder(
                animation: controller.animation,
                builder: (context, child) {
                  var distance = ((widthToggle - sizeThumb) / 2) - marginLeft;
                  var x = distance * (2 * controller.animation.value - 1);

                  return Transform.translate(
                    offset: Offset(x, 0),
                    child: _thumbWidget(
                      sizeThumb: sizeThumb,
                      marginLeft: marginLeft / 2,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
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

  _backgroundWidget({
    required var widthToggle,
    required var heightToggle,
  }) {
    // height 120
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        var value = controller.animationController.value;
        var heightMoon = heightToggle * value;
        var heightSun = -(heightToggle - heightToggle * value);
        return Stack(
          children: [
            Transform.translate(
              offset: Offset(0, heightMoon), //
              child: SizedBox(
                height: heightToggle,
                width: widthToggle,
                child: Image.asset(
                  "assets/bg_sun.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, heightSun),
              child: SizedBox(
                height: heightToggle,
                width: widthToggle,
                child: OverflowBox(
                  child: ClipRect(
                    clipBehavior: Clip.hardEdge,
                    child: OverflowBox(
                      maxHeight: heightToggle + 100,
                      maxWidth: widthToggle,
                      child: Center(
                        child: SizedBox(
                          child: Image.asset(
                            "assets/bg_moon.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
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
    required double marginLeft,
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
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFFFFFF).withOpacity(0.58),
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
            blurRadius: 2,
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
        color: const Color(0xFFB3C7CA),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.25),
            blurStyle: BlurStyle.inner,
            spreadRadius: -3,
            blurRadius: 3,
          )
        ],
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
                      color: Colors.white.withOpacity(0.5 / (index + 1)),
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
