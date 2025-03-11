import 'package:common_toolkit/common_constants.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset(
      'assets/lottie/loading.json',
      width: 125,
      package: CommonConstants.packageName,
    ) /*LoadingAnimationWidget.horizontalRotatingDots(color: Colors.greenAccent, size: 40)*/);
  }
}
