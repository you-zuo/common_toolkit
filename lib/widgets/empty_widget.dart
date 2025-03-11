import 'package:common_toolkit/common_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyWidget extends StatelessWidget {
  EmptyWidget({this.text = '暂无数据', super.key});

  String text;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset('assets/lottie/empty.json',
            width: 100, height: 100, package: CommonConstants.packageName),
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        )
      ],
    ));
  }
}
