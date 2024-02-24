import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class ToggleController extends ChangeNotifier {
  late AnimationController _animationController;
  late Animation<Color?> _backgroundColorAnimation;

  late AnimationController _toggleController;
  late Animation<double> toggleAnimation;
  late Animation<double> thumbAnimation;

  var begin = 0.0;
  var end = 1.0;
  var beginGentle = 0.0;
  var endGentle = 10.0;

  onInit(TickerProviderStateMixin provider) {
    _animationController = AnimationController(
      vsync: provider,
      duration: const Duration(milliseconds: 500),
    );

    toggleAnimation =
        Tween<double>(begin: begin, end: end).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    ));

    _backgroundColorAnimation = ColorTween(
      begin: const Color(0xff00B1FD),
      end: const Color(0xff171B1D),
    ).animate(_animationController);

    _toggleController = AnimationController(
      vsync: provider,
      duration: const Duration(milliseconds: 300),
    );

    thumbAnimation = Tween<double>(begin: 0, end: 10).animate(CurvedAnimation(
      parent: _toggleController,
      curve: Curves.easeInOutCubic,
    ));
  }

  onTap() {
    if (_animationController.value == 0) {
      _animationController.forward().whenComplete(
        () {
          _toggleController.forward();
        },
      );
    } else {
      _animationController.reverse().whenComplete(() {
        _toggleController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
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
  final controller = ToggleController();
  final _widthToggle = 300.0;
  final _heightToggle = 125.0;
  final _sizeThumb = 100.0;
  final _marginHorizontal = 12.0;
  final _borderRadius = 60.0;

  @override
  void initState() {
    super.initState();
    controller.onInit(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe9bc47),
      body: Center(
        child: InkWell(
          onTap: () {
            controller.onTap();
          },
          child: _toggleWidget(),
        ),
      ),
    );
  }

  _toggleWidget() {
    return Container(
      height: _heightToggle,
      width: _widthToggle,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            _borderRadius,
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
                _borderRadius,
              ),
            ),
            child: Stack(
              children: [
                _trackColorWidget(),
                _trackImageWidget(),
                _thumbWidget(),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  _borderRadius,
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
                width: 5.5,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _trackColorWidget() {
    return AnimatedBuilder(
      animation: controller._animationController,
      builder: (context, child) {
        return Container(
          color: controller._backgroundColorAnimation.value,
        );
      },
    );
  }

  _trackImageWidget() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        controller.toggleAnimation,
        controller.thumbAnimation,
      ]),
      builder: (context, child) {
        var value = controller._animationController.value;
        var gentleValue = controller.thumbAnimation.value;
        if (gentleValue >= controller.endGentle / 2) {
          gentleValue = controller.endGentle / 2 - gentleValue;
        }
        var heightMoon = _heightToggle * value + gentleValue;
        var heightSun = _heightToggle * value - _heightToggle + gentleValue;
        return Stack(
          children: [
            Transform.translate(
              offset: Offset(0, heightMoon),
              child: SizedBox(
                height: _heightToggle,
                width: _widthToggle,
                child: OverflowBox(
                  child: ClipRect(
                    clipBehavior: Clip.hardEdge,
                    child: OverflowBox(
                      maxHeight: _heightToggle,
                      maxWidth: _widthToggle,
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

  _thumbWidget() {
    var distanceMove = _widthToggle - _sizeThumb - 2 * _marginHorizontal;

    return AnimatedBuilder(
      animation: Listenable.merge([
        controller.toggleAnimation,
        controller.thumbAnimation,
      ]),
      builder: (context, child) {
        var value = controller._animationController.value;
        var gentleValue = controller.thumbAnimation.value;
        if (gentleValue >= 5) {
          gentleValue = controller.endGentle / 2 - gentleValue;
        }
        var x = distanceMove * (controller.toggleAnimation.value - 1 / 2) +
            gentleValue;
        return Transform.translate(
          offset: Offset(x, 0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _circleWidget(),
              SizedBox(
                height: _sizeThumb,
                width: _sizeThumb,
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
                          child: _thumbBackgroundWidget(
                            const Color(0xFFF7B858),
                          ),
                        ),
                        Opacity(
                          opacity: value,
                          child: Stack(
                            children: [
                              _thumbBackgroundWidget(
                                const Color(0xFFC4D4D6),
                              ),
                              _decorMoonWidget(),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _decorMoonWidget() {
    return Stack(
      children: [
        Positioned(
          left: 30,
          top: 10,
          child: _mountainWidget(15),
        ),
        Positioned(
          left: 15,
          top: 34,
          child: _mountainWidget(8),
        ),
        Positioned(
          left: 55,
          top: 31,
          child: _mountainWidget(19),
        ),
        Positioned(
          left: 55,
          top: 52,
          child: _mountainWidget(11),
        ),
        Positioned(
          left: 18,
          top: 55,
          child: _mountainWidget(14),
        ),
        Positioned(
          left: 70,
          top: 52,
          child: _mountainWidget(22),
        ),
        Positioned(
          left: 43,
          top: 64,
          child: _mountainWidget(15),
        ),
      ],
    );
  }

  _thumbBackgroundWidget(Color color) {
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

  _mountainWidget(double size) {
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
