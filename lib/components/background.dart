import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -14,
            right: 0,
            child: Image.asset("assets/images/top1.png",
                alignment: Alignment.topRight, width: size.width),
          ),
          Positioned(
            top: -14,
            right: 0,
            child: Image.asset("assets/images/top2.png",
                alignment: Alignment.topRight, width: size.width),
          ),
          Positioned(
            bottom: -18,
            right: 0,
            child: Image.asset("assets/images/bottom1.png",
                alignment: Alignment.bottomLeft, width: size.width),
          ),
          Positioned(
            bottom: -18,
            right: 0,
            child: Image.asset("assets/images/bottom2.png",
                alignment: Alignment.bottomLeft, width: size.width),
          ),
          child,
        ],
      ),
    );
  }
}
