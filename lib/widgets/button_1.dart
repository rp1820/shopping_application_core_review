import 'package:flutter/material.dart';
import 'package:shopping_application_qstp/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {
  final String? text;
  final void Function()? onPressed;
  final void Function()? onlongPress;
  final bool? outlineBtn;
  final bool? isLoading;
  const CustomButton(
      {this.text,
      this.onPressed,
      this.outlineBtn,
      this.onlongPress,
      this.isLoading});

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    bool _outlineBtn = widget.outlineBtn ?? false;
    bool _isLoading = widget.isLoading ?? false;
    return GestureDetector(
      onTap: widget.onPressed,
      onLongPress: widget.onlongPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: _outlineBtn ? Colors.transparent : Colors.black,
            border: Border.all(width: 3.0, color: Colors.black),
            borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Stack(
          children: [
            Visibility(
              visible: _isLoading ? false : true,
              child: Text(
                widget.text ?? 'Text',
                style: TextStyle(
                  fontSize: 17,
                  color: _outlineBtn ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Visibility(visible: _isLoading, child: CircularProgressIndicator())
          ],
        ),
      ),
    );
  }
}
