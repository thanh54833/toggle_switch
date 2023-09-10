import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class ToggleController extends ChangeNotifier {
  late AnimationController animationController;
  late Animation<double> animation;
  late Animation<Color?> colorAnimation;

  void init(SingleTickerProviderStateMixin provider) {
    animationController = AnimationController(
      vsync: provider,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutCubicEmphasized));

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

  var widthToggle = 280.0;
  var heightToggle = 120.0;
  var sizeThumb = 100.0;
  var marginLeft = 15.0;
  var borderRadius = 60.0;

  _toggleWidget() {
    return Container(
      height: heightToggle,
      width: widthToggle,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            borderRadius,
          ),
        ),
        border: Border.all(
          width: 5,
          color: Colors.white,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(
            borderRadius,
          ),
        ),
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
    return AnimatedBuilder(
      animation: controller.animationController,
      builder: (context, child) {
        var value = controller.animationController.value;
        var heightMoon = heightToggle * value;
        var heightSun = -(heightToggle - heightToggle * value);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(3, 3),
                blurRadius: 2,
                color: Colors.black.withOpacity(0.8),
                inset: true,
              ),
            ],
          ),
          child: Stack(
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
          ),
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
