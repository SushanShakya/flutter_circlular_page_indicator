import 'dart:math';

import 'package:animation/tap_effect.dart';
import 'package:flutter/material.dart';

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
      home: Home(),
    );
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
              painter: IndicatorPainter(value, size),
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

class IndicatorPainter extends CustomPainter {
  final double value;
  final double size;
  IndicatorPainter(this.value, this.size) : super();
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
