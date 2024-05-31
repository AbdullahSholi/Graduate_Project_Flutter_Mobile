import 'package:flutter/material.dart';

class ToggleButton1 extends StatefulWidget {
  // final Icon toggleIcon;
  final Function(bool) onChanged;
  final bool initialValue;
  final Icon onIcon;
  final Icon offIcon;



  ToggleButton1({
    // required this.toggleIcon,
    required this.onChanged,
    required this.onIcon ,
    required this.offIcon ,
    this.initialValue = false,
  });

  @override
  _ToggleButton1State createState() => _ToggleButton1State();
}

class _ToggleButton1State extends State<ToggleButton1> {
  late bool _value;
  // late Color _iconColor;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    // _iconColor = _value ? widget.onIconColor : widget.offIconColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _value = !_value;
          widget.onChanged(_value);
          // _iconColor = _value ? widget.onIconColor : widget.offIconColor;
        });
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          // color: _value ? Color(0xFF212128) : Colors.transparent,
        ),
        child: _value ? widget.onIcon : widget.offIcon,
      ),
    );
  }
}
