import 'package:flutter/material.dart';

class RoomFacilityItem extends StatefulWidget {
  RoomFacilityItem({
    super.key,
    this.onDelete,
  });

  VoidCallback? onDelete;

  @override
  State<RoomFacilityItem> createState() => _RoomFacilityItemState();
}

class _RoomFacilityItemState extends State<RoomFacilityItem> {
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
          height: 165,
          width: 125,
          child: Stack(
            children: [
              Visibility(
                visible: isHovered,
                child: Positioned(
                  top: 5,
                  right: 5,
                  child: InkWell(
                    onTap: widget.onDelete,
                    child: const Icon(
                      Icons.close,
                      size: 18,
                    ),
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
