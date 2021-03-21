import 'package:flutter/material.dart';

class WavyHeader extends StatelessWidget {
  final List<Color> colorList = [
    Color(0xff009797),
    Colors.teal,
    Color(0xff4cb6b6),
    Color(0xff99d5d5),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          ClipPath(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.323898,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  colors: colorList,
                  end: Alignment.topRight,
                ),
              ),
            ),
            clipper: BottomWave(MediaQuery.of(context).size.height,
                MediaQuery.of(context).size.height),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: MediaQuery.of(context).size.width * 0.1,
            child: Text(
              "Track Me Beacon",
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomWave extends CustomClipper<Path> {
  double deviceHeight, deviceWidth;
  BottomWave(this.deviceHeight, this.deviceWidth);
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

  @override
  Path getClip(Size size) {
    var secondControlPoint = Offset(size.width * 0.3, size.height * 0.75);
    var secondEndPoint = Offset(size.width * 0.6, size.height * 0.9);
    var firstControlPoint = Offset(size.width * 0.8, size.height);
    var firstEndPoint = Offset(size.width, size.height * 0.8);
    var path = Path()
      ..lineTo(0.0, size.height * 0.9)
      ..quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy)
      ..quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy)
      ..lineTo(size.width, size.height * 0.7)
      ..lineTo(size.width, 0.0)
      ..close();
    return path;
  }
}
