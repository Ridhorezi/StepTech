import 'package:flutter/material.dart';
import 'package:step_tech/views/shared/appstyle.dart';

class CategoryBtn extends StatelessWidget {
  const CategoryBtn(
      {super.key, this.onPress, required this.buttonClr, required this.label});
  final void Function()? onPress;
  final Color buttonClr;
  final String label;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPress,
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.242,
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: buttonClr,
              style: BorderStyle.solid,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(9))),
        child: Center(
          child: Text(
            label,
            style: appstyle(11, buttonClr, FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
