import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  final Icon toggleIcon;
  final Function(bool) onChanged;
  final bool initialValue;
  final Color onIconColor;
  final Color offIconColor;



  ToggleButton({
    required this.toggleIcon,
    required this.onChanged,
    this.initialValue = false,
    this.onIconColor = Colors.white,
    this.offIconColor = Colors.grey,
  });

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  late bool _value;
  late Color _iconColor;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _iconColor = _value ? widget.onIconColor : widget.offIconColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _value = !_value;
          widget.onChanged(_value);
          _iconColor = _value ? widget.onIconColor : widget.offIconColor;
        });
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.red ,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
            widget.toggleIcon.icon,
            size: 20,
            color: _iconColor,
            )
          ],
        ),
      ),
    );
  }
}
