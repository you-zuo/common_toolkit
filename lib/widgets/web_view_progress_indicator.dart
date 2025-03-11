import 'package:flutter/material.dart';

class WebViewProgressIndicator extends StatelessWidget {
  WebViewProgressIndicator({super.key, required this.progress});

  double progress;

  @override
  Widget build(BuildContext context) {
    return _createProgressIndicator();
  }

  Widget _createProgressIndicator() {
    if (progress >= 1.0) {
      return Container(
        height: 2.0,
      );
    }
    return PreferredSize(
        preferredSize: const Size(double.infinity, 4.0),
        child: SizedBox(
            height: 2.0,
            child: LinearProgressIndicator(
              value: progress,
            )));
  }
}
