import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

class ButtonsCard extends StatelessWidget {
  final Color colur;
  final Function OnPressed;
  final Text title;

  ButtonsCard(
      {@required this.colur, @required this.OnPressed, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kButtonsCardPadding,
      child: Material(
        elevation: 5.0,
        color: colur,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
            onPressed: OnPressed, minWidth: 200.0, height: 42.0, child: title),
      ),
    );
  }
}