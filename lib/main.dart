import 'dart:math';

import 'package:flutter/material.dart';

import 'package:animation/tap_effect.dart';

void main() => runApp(Animation());

class Animation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(elevation: 0),
      ),
      debugShowCheckedModeBanner: false,
      home: _Home(),
    );
  }
}

class _Home extends StatefulWidget {
  @override
  State<_Home> createState() => __HomeState();
}

class __HomeState extends State<_Home> with TickerProviderStateMixin {
  late AnimationController controller;

  static const totalPages = 3;

  int curPage = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  void nextPage() {
    if (curPage == totalPages) {
      curPage = 0;
    } else {
      curPage++;
    }
    controller.animateTo(curPage / totalPages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (c, child) => Btn(
            value: controller.value,
            onTap: nextPage,
          ),
        ),
      ),
    );
  }
}

class Btn extends StatelessWidget {
  final double size;
  final double value;
  final void Function() onTap;
  const Btn({
    Key? key,
    this.size = 100,
    required this.onTap,
    required this.value,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size + 20,
      width: size + 20,
      child: Stack(
        children: [
          SizedBox(
            height: size + 20,
            width: size + 20,
            child: CustomPaint(
              painter: IndicatorPainter(value: value),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: size,
                width: size,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IndicatorPainter extends CustomPainter {
  final double value;
  IndicatorPainter({
    required this.value,
  }) : assert(value >= 0 && value <= 1);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final angle = 6.2832 * value;

    canvas.drawArc(
      const Offset(0, 0) & const Size(120, 120),
      -1.5708,
      angle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ArcPainter extends CustomPainter {
  final double value;
  final double size;
  ArcPainter(this.value, this.size) : super();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final paint2 = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final radius = size.width / 2;
    // final angle = 2.0944 * index;
    final angle = 6.2832 * value;
    var x = radius * sin(angle);
    var y = radius * cos(angle);

    var h = radius;
    var k = radius;
    var center = Offset(-y, -x);

    if (value > 0) {
      canvas.drawCircle(Offset(h - center.dy, k + center.dx), 5, paint2);
    }

    canvas.drawArc(
      const Offset(0, 0) & Size(this.size, this.size),
      -1.5708,
      angle,
      false,
      paint,
    );
    // canvas.drawCircle(Offset(size.width / 2, size.height / 2), 100, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController _ctrl;
  late int totalPages;
  late int index;

  @override
  void initState() {
    super.initState();
    totalPages = 10;
    index = 0;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Index : $index"),
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: _ctrl,
                builder: (c, child) {
                  return OnboardBtn(
                    onTap: () async {
                      if (index < totalPages) {
                        await _ctrl.animateTo(1 / totalPages * (index + 1));
                        setState(() {
                          index++;
                        });
                      }
                    },
                    value: _ctrl.value,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardBtn extends StatelessWidget {
  final double spacing;
  final double size;
  final double value;
  final void Function() onTap;

  const OnboardBtn({
    Key? key,
    required this.onTap,
    this.spacing = 10,
    this.size = 110,
    required this.value,
  })  : assert(value >= 0 && value <= 1),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        children: [
          SizedBox(
            height: size,
            width: size,
            child: CustomPaint(
              painter: ArcPainter(value, size),
            ),
          ),
          Center(
            child: TapEffect(
              onClick: onTap,
              child: Container(
                height: size - (spacing * 2),
                width: size - (spacing * 2),
                child: const Center(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color primaryColor = const Color(0xff212E7E);
