import 'package:flutter/material.dart';
import 'package:tasktender_frontend/utils/app.theme.dart';

class ListItem extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData? iconData;
  final double? height;
  final VoidCallback onPressed;
  final Color? color;
  final IconData? trailingIcon;
  final bool isDisabled;

  const ListItem(
      {super.key,
      required this.title,
      required this.onPressed,
      this.subtitle,
      this.iconData,
      this.height = 55,
      this.color,
      this.trailingIcon,
      this.isDisabled = false});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  Widget getTitle() {
    Color color = widget.color ?? Theme.of(context).primaryColor;

    if (widget.isDisabled) {
      color = color.withOpacity(0.5);
    }

    return widget.subtitle != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: color,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 5),
              Text(widget.subtitle!,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w400, fontSize: 12)),
            ],
          )
        : Text(widget.title,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w600,
            ));
  }

  List<Widget> getIcon() {
    Color color = widget.color ?? Color(0xFF999999);

    if (widget.isDisabled) {
      color = color.withOpacity(0.5);
    }

    return widget.iconData != null
        ? [
            Icon(
              widget.iconData,
              color: color,
              size: 25,
            ),
            const SizedBox(width: 10)
          ]
        : [Container()];
  }

  List<Widget> getTrailingIcon() {
    Color color = widget.color ?? Color(0xFF999999);

    if (widget.isDisabled) {
      color = color.withOpacity(0.5);
    }

    return widget.trailingIcon != null
        ? [
            const Expanded(child: SizedBox()),
            Icon(
              widget.trailingIcon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 10),
          ]
        : [Container()];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          // color: Colors.white,
          border: Border.symmetric(
            horizontal: BorderSide(
              color: Color(0xAA999999),
              width: 0.25,
            ),
          ),
        ),
        child: OutlinedButton(
            style: ButtonStyle(
              side: WidgetStateProperty.all(
                const BorderSide(
                    color: Colors.transparent,
                    width: 1), // Edge color and thickness
              ),
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  // Color when button is pressed
                  return (Theme.of(context)
                              .extension<CustomThemeExtension>()
                              ?.listItemBackground ??
                          Colors.white)
                      .withAlpha(50);
                }
                // Default color
                return Theme.of(context)
                        .extension<CustomThemeExtension>()
                        ?.listItemBackground ??
                    Colors.white;
              }),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Rounded corners
                ),
              ),
              padding: WidgetStateProperty.all(
                const EdgeInsets.all(0),
              ),
              overlayColor: WidgetStateProperty.all(
                  Colors.transparent), // No overlay color
            ),
            onPressed: widget.isDisabled ? null : widget.onPressed,
            child: Row(
              children: [
                const SizedBox(width: 15),
                ...getIcon(),
                getTitle(),
                ...getTrailingIcon(),
              ],
            )));
  }
}
