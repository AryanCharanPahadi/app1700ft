import 'package:app17000ft_new/components/custom_button.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

class Confirmation extends StatefulWidget {
  final String? desc;
  final String? title;
  final bool? settle;
  final Callback? onPressed;
  final String? yes;
  final String? no;
  final IconData? iconname;

  const Confirmation({
    super.key,
    required this.desc,
    required this.title,
    this.settle,
    required this.onPressed,
    required this.yes,
    this.no,
    required this.iconname,
  });

  @override
  ConfirmationState createState() => ConfirmationState();
}

class ConfirmationState extends State<Confirmation> {
  @override
  Widget build(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: screenWidth * 0.5, // Use 80% of screen width
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Wrap(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: AppColors.primary,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: screenWidth * 0.02), // Dynamic spacing
                    Icon(
                      widget.iconname,
                      color: Colors.white,
                      size: screenWidth * 0.1, // Dynamic icon size
                    ),
                    SizedBox(height: screenWidth * 0.02), // Dynamic spacing
                    Text(
                      widget.title.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.03, // Dynamic font size
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.02), // Dynamic spacing
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: screenWidth * 0.02), // Dynamic spacing
                    Text(
                      widget.desc ?? "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.02, // Dynamic font size
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: widget.no != null
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: CustomButton(
                        onPressedButton: () {
                          widget.onPressed!();
                          Navigator.of(context).pop();
                        },
                        title: widget.yes,
                      ),
                    ),
                    if (widget.no != null)
                      SizedBox(width: screenWidth * 0.04), // Add spacing between buttons
                    if (widget.no != null)
                      Flexible(
                        child: CustomButton(
                          title: widget.no,
                          onPressedButton: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
