import 'package:flutter/material.dart';

class UnFocusWidget extends StatelessWidget {
  final Widget child;

  UnFocusWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: child,
    );
  }
}
