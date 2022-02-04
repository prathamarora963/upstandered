import 'package:flutter/material.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';

class RoundedBorderTextButton extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final double height;
  final double width;
  final Color textColor;
  final Color bgColor;
  final double fontSize;
  final double borderRadius;
  final Color borderColor;

  const RoundedBorderTextButton(
      {Key key,
      @required this.title,
      @required this.onTap,
      @required this.height,
      @required this.width,
      @required this.textColor,
      @required this.bgColor,
      this.fontSize,
      @required this.borderRadius,
      @required this.borderColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          alignment: Alignment.center,
          height: height,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: bgColor,
              border: Border.all(color: borderColor)),
          child: Text(
            title,
            style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: textColor),
          )),
    );
  }
}

class AnimatedRoundedBorderTextButton extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final double height;
  final double width;
  final Color textColor;
  final Color bgColor;
  final double fontSize;
  final double borderRadius;
  final bool isLoading;
  final Color processColor;
  final Alignment alignment;

  const AnimatedRoundedBorderTextButton({
    Key key,
    @required this.title,
    @required this.onTap,
    @required this.height,
    @required this.isLoading,
    @required this.width,
    @required this.textColor,
    @required this.bgColor,
    @required this.borderRadius,
    @required this.alignment,
    this.fontSize,
    this.processColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: alignment,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          alignment: Alignment.center,
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          child: isLoading
              ? ProcessingIndicator(
                  size: size.height * 0.0015,
                  processColor: processColor,
                )
              : Text(
                  title,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
        ),
      ),
    );
  }
}

class AnimatedRoundedBorderTextIconButton extends StatelessWidget {
  final bool isLoading;
  final Alignment alignment;
  final String title;
  final void Function() onTap;
  final double height;
  final double width;
  final Color textColor;
  final Color bgColor;
  final double fontSize;
  final double borderRadius;

  final String iconAsset;
  final Color iconColor;
  final Color processColor;

  const AnimatedRoundedBorderTextIconButton({
    Key key,
    @required this.isLoading,
    @required this.processColor,
    @required this.alignment,
    @required this.title,
    @required this.onTap,
    @required this.height,
    @required this.width,
    @required this.textColor,
    @required this.bgColor,
    this.fontSize,
    @required this.borderRadius,
    @required this.iconColor,
    @required this.iconAsset,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: alignment,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          alignment: Alignment.center,
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          child: isLoading
              ? ProcessingIndicator(
                  size: size.height * 0.0015,
                  processColor: processColor,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                    SizedBox(width: 15),
                    Image.asset(
                      iconAsset,
                      color: iconColor,
                      height: 25,
                      width: 25,
                    )
                  ],
                ),
        ),
      ),
    );
  }
}

class RoundedBorderTextIconButton extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final double height;
  final double width;
  final Color textColor;
  final Color bgColor;
  final double fontSize;
  final double borderRadius;
  final Color borderColor;
  final String iconAsset;
  final Color iconColor;

  const RoundedBorderTextIconButton(
      {Key key,
      @required this.title,
      @required this.onTap,
      @required this.height,
      @required this.width,
      @required this.textColor,
      @required this.bgColor,
      this.fontSize,
      @required this.borderRadius,
      @required this.iconColor,
      @required this.iconAsset,
      @required this.borderColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          alignment: Alignment.center,
          height: height,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: bgColor,
              border: Border.all(color: borderColor)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
              SizedBox(width: 15),
              Image.asset(
                iconAsset,
                color: iconColor,
                height: 25,
                width: 25,
              )
            ],
          )),
    );
  }
}

class CircularButton extends StatelessWidget {
  final void Function() onTap;
  final double buttonRadius;
  final Color buttonBgColor;
  final IconData icon;
  final Color iconColor;
  final double iconSize;

  const CircularButton(
      {Key key,
      this.onTap,
      this.buttonRadius,
      this.buttonBgColor,
      this.icon,
      this.iconColor,
      this.iconSize})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: buttonRadius,
        width: buttonRadius,
        decoration: BoxDecoration(
          color: buttonBgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
      ),
    );
  }
}
