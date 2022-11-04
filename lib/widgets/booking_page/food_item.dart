import 'package:flutter/material.dart';

class FoodItem extends StatefulWidget {
  FoodItem({super.key});

  @override
  State<FoodItem> createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovered = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(
          right: 15,
          bottom: 15,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.greenAccent,
          ),
          height: 145,
          width: 125,
          child: Stack(
            children: [
              Visibility(
                visible: isHovered,
                child: Positioned(
                  top: 5,
                  right: 5,
                  child: Icon(
                    Icons.close,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
