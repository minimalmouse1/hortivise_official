import 'package:flutter/material.dart';

class ReadOnlyWidget extends StatelessWidget implements PreferredSizeWidget {
  const ReadOnlyWidget({super.key, required this.child, this.decoration});
  final TabBar child;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned.fill(child: Container(decoration: decoration)),
          child,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => child.preferredSize;
}
