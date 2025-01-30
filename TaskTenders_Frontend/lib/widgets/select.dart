import 'package:flutter/material.dart';

class Select extends StatefulWidget {
  final List<String> options;
  final String? initialSelection;
  final String? hintText;
  final Widget? label;
  final double borderRadius;
  final Color? backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double fontSize;
  final Function(String)? onSelectionChanged;

  const Select({
    super.key,
    required this.options,
    this.initialSelection,
    this.borderRadius = 15,
    this.label,
    this.hintText,
    this.backgroundColor,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.fontSize = 15,
    this.onSelectionChanged,
  });

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      hintText: widget.hintText,
      label: widget.label,
      expandedInsets: EdgeInsets.zero,
      textStyle: TextStyle(
        fontSize: widget.fontSize,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: widget.backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          // Border style when TextField is enabled
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          // Border style when TextField is focused
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: widget.borderColor, width: 2),
        ),
      ),
      initialSelection: widget.initialSelection,
      onSelected: (String? value) {
        if (value != null) {
          setState(() {
            _selectedOption = value;
          });
          if (widget.onSelectionChanged != null) {
            widget.onSelectionChanged!(value);
          }
        }
      },
      dropdownMenuEntries:
          widget.options.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
