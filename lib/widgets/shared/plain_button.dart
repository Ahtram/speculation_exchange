import 'package:flutter/material.dart';

class PlainButton extends StatelessWidget {
  const PlainButton(
      {this.text = '',
      this.onPressed,
      this.backgroundColor,
      this.margin = const EdgeInsets.all(0),
      this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      this.radius = 5.0,
      this.elevation = 2,
      this.child,
      this.enable = true,
      this.textStyle,
      super.key});

  final Color? backgroundColor;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double radius;
  final double elevation;
  final String text;
  final TextStyle? textStyle;
  final Widget? child;
  final bool enable;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    TextStyle? useTextStyle = textStyle ?? Theme.of(context)
        .textTheme
        .titleMedium;

    Color useBackgroundColor = backgroundColor ?? Theme.of(context).primaryColor;

    return Padding(
      padding: margin,
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(radius),
        color: useBackgroundColor,
        elevation: elevation,
        child: Opacity(
          opacity: enable ? 1 : 0.5,
          child: InkWell(
              child: Padding(
                padding: padding,
                child: Center(
                  child: child ??
                      Text(
                        text,
                        style: useTextStyle,
                        textAlign: TextAlign.center,
                      ),
                ),
              ),
              onTap: () {
                if (enable) {
                  onPressed?.call();
                }
              }),
        ),
      ),
    );
  }
}
