import 'package:flutter/material.dart';
class WebViewLoadingBar extends StatelessWidget {
  const WebViewLoadingBar({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: LinearProgressIndicator(
        value: progress > 0 ? progress : null,
        minHeight: 2.5,
        backgroundColor: Colors.grey.shade200,
        color: Colors.black,
      ),
    );
  }
}
