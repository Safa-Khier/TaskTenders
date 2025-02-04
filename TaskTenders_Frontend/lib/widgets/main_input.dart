import 'package:flutter/material.dart';

class MainInput extends StatefulWidget {
  final String hintText;
  final Color color;
  final bool isPassword;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final String? leadingText;
  final double fontSize;
  final double borderRadius;
  final double width;
  final double height;
  final Function(String)? onTextChanged; // Callback for text changes
  final TextInputType? keyboardType;
  final String initialValue;
  final TextEditingController? controller;
  final int maxLines;

  const MainInput({
    super.key,
    required this.hintText,
    required this.color,
    this.isPassword = false,
    this.leadingText,
    this.leadingIcon,
    this.trailingIcon,
    this.borderRadius = 15,
    this.fontSize = 15,
    this.width = double.infinity,
    this.height = 52,
    this.onTextChanged,
    this.controller,
    this.keyboardType,
    this.initialValue = '',
    this.maxLines = 1,
  });

  @override
  State<MainInput> createState() => _MainInputState();
}

class _MainInputState extends State<MainInput> {
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = !widget.isPassword;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.maxLines == 1 ? widget.height : null,
      child: TextField(
        onChanged: widget.onTextChanged,
        maxLines: widget.maxLines,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        obscureText: widget.isPassword && !_passwordVisible,
        style: TextStyle(
          color: widget.color,
          fontSize: widget.fontSize,
        ),
        decoration: InputDecoration(
          // prefix: Text(widget.leadingText ?? ''),
          contentPadding:
              EdgeInsets.all((widget.height - widget.fontSize) / 2 - 2),
          hintText: widget.hintText,
          hintStyle: TextStyle(
              fontSize: widget.fontSize,
              color: widget.color.withValues(alpha: 0.5),
              fontWeight: FontWeight.bold),
          enabledBorder: OutlineInputBorder(
            // Border style when TextField is enabled
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: widget.color, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            // Border style when TextField is focused
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: widget.color, width: 2),
          ),
          prefixIcon: widget.leadingIcon != null
              ? Icon(widget.leadingIcon, color: widget.color)
              : null,
          suffixIcon: widget.trailingIcon != null
              ? Icon(widget.trailingIcon, color: widget.color)
              : (widget.isPassword
                  ? IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(
                            milliseconds: 200), // Duration of the animation
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              scale: animation, child: child);
                        },
                        child: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          key: ValueKey(
                              _passwordVisible), // Unique key for each state
                          color: widget.color,
                        ),
                      ),
                      style: ButtonStyle(
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    )
                  : null),
        ),
      ),
    );
  }
}
