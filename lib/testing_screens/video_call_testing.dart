import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class TestingVideoCallPage extends StatefulWidget {
  const TestingVideoCallPage({
    super.key,
    required this.call,
  });
  final Call call;

  @override
  State<TestingVideoCallPage> createState() => _TestingVideoCallPageState();
}

class _TestingVideoCallPageState extends State<TestingVideoCallPage> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamCallContainer(
      call: widget.call,
    );
  }
}
