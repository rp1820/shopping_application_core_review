import 'package:flutter/material.dart';

class CustomInputFields extends StatefulWidget {
  // final String? label;
  final String? hint;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool? isPasswordField;
  const CustomInputFields(
      {this.hint,
      this.onChanged,
      this.onSubmitted,
      this.focusNode,
      this.textInputAction,
      this.isPasswordField});
  @override
  _CustomInputFieldsState createState() => _CustomInputFieldsState();
}

class _CustomInputFieldsState extends State<CustomInputFields> {
  bool _passwordVisible = false;
  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool _isPasswordField = widget.isPasswordField ?? false;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(color: Colors.black, width: 5),
            borderRadius: BorderRadius.circular(12)),
        child: TextFormField(
            //obscureText: _isPasswordField,
            obscureText: !_passwordVisible && _isPasswordField,
            textInputAction: widget.textInputAction,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            decoration: InputDecoration(
              // labelText: widget.label ?? 'null',
              hintText: widget.hint ?? 'null',
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              suffixIcon: Visibility(
                visible: _isPasswordField ? true : false,
                child: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    // color: Theme.of(context).primaryColorDark,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            )),
      ),
    );
  }
}
