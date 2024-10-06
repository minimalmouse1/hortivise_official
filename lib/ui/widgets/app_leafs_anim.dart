import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:horti_vige/generated/assets.dart';

class AppLeafsAnim extends StatefulWidget {
  const AppLeafsAnim({super.key});

  @override
  _AppLeafsAnimState createState() => _AppLeafsAnimState();
}

class _AppLeafsAnimState extends State<AppLeafsAnim> {
  bool _isMoving = false;

  void _startAnimation() {
    setState(() {
      _isMoving = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Animation Example'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _startAnimation,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedPositioned(
                duration: const Duration(seconds: 5),
                curve: Curves.easeInOut,
                // top: _isMoving ? 0 : MediaQuery.of(context).size.height / 2 - 50,
                left:
                    _isMoving ? 0 : MediaQuery.of(context).size.width / 2 - 50,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 5),
                  curve: Curves.easeInOut,
                  width:
                      _isMoving ? 50 : MediaQuery.of(context).size.width - 20,
                  height: MediaQuery.of(context).size.height,
                  child: SvgPicture.asset(
                    Assets.imagesLeftLeafs,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(seconds: 5),
                curve: Curves.easeInOut,
                // top: _isMoving ? 0 : MediaQuery.of(context).size.height / 2 - 50,
                right:
                    _isMoving ? 0 : MediaQuery.of(context).size.width / 2 - 50,
                child: AnimatedContainer(
                  duration: const Duration(seconds: 5),
                  curve: Curves.easeInOut,
                  width:
                      _isMoving ? 50 : MediaQuery.of(context).size.width - 20,
                  height: MediaQuery.of(context).size.height,
                  child: SvgPicture.asset(
                    Assets.imagesRightLeafs,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
