import 'package:flutter/material.dart';

void main() => runApp(const MainPage());

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clean Drawer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(title: const Text('Clean Drawer')),
          body: const CanvasView()),
    );
  }
}

class CanvasView extends StatefulWidget {
  const CanvasView({super.key});

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();
  double _currentX = 0;
  double _currentY = 0;
  bool drawMode = false;

  List<Offset> points = [];

  @override
  void initState() {
    super.initState();
    _horizontalController.addListener(_updatePosition);
    _verticalController.addListener(_updatePosition);
  }

  void _updatePosition() => setState(() {
        _currentX = _horizontalController.offset;
        _currentY = _verticalController.offset;
      });

  void _startDrawing(Offset position) => setState(() => points = [position]);

  void _updateDrawing(Offset position) => setState(() => points.add(position));

  @override
  void dispose() {
    _horizontalController.removeListener(_updatePosition);
    _verticalController.removeListener(_updatePosition);
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          _horizontalController
              .jumpTo(_horizontalController.offset - details.delta.dx);
          _verticalController
              .jumpTo(_verticalController.offset - details.delta.dy);
        },
        child: SingleChildScrollView(
          controller: _horizontalController,
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            controller: _verticalController,
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: 10000,
              height: 10000,
              child: Stack(
                children: [
                  CustomPaint(
                    painter: LinePainter(points),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final List<Offset> points;

  LinePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
