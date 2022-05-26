import 'package:flutter/material.dart';
import 'standard.dart';

/// 存放一些扩展的组件。

/// 标题字体。
class TitleText extends Text {
  final String text;
  const TitleText(
    this.text, {
    Key? key,
    bool? softWrap,
  }) : super(
          key: key,
          text,
          softWrap: false,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        );
}

class CardContainer extends Container {
  CardContainer({
    Key? key,
    Widget? child,
    double? width,
    double? height,
    Color? backgroundColor,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? opacity,
  }) : super(
          key: key,
          width: width,
          height: height,
          margin: margin,
          padding: padding,
          constraints: constraints,
          decoration: BoxDecoration(
            border: Border.all(color: lightColor.withOpacity(opacity ?? 0.1)),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                  color: backgroundColor ?? lightColor.withOpacity(opacity ?? 0.05), blurRadius: 1, spreadRadius: 1),
            ],
          ),
          child: child,
        );
}
