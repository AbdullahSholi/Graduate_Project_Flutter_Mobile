import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Icon CustomIcon;
  final Function(bool) onClick;
  final bool initialValue;



  CustomButton({
    required this.CustomIcon,
    required this.onClick,
    this.initialValue = false,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {

          widget.onClick(_value);
        });
      },
      child: Container(
        padding: EdgeInsets.all(10.0),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            widget.CustomIcon
          ],
        ),
      ),
    );
  }
}
