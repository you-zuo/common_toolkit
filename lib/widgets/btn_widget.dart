import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BtnWidget extends StatelessWidget {
  BtnWidget({required this.child, required this.onPressed, this.padding, super.key});

  Widget child;
  VoidCallback onPressed;
  EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: padding ?? EdgeInsets.zero,
      minSize: 0,
      onPressed: onPressed,
      child: Container(child: child),
    );
  }
}
