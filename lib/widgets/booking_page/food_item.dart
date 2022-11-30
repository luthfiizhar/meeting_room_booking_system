import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/model/amenities_class.dart';

class FoodItem extends StatefulWidget {
  FoodItem({
    super.key,
    this.displayOnly = false,
    this.listFOod,
    this.onDelete,
  });

  bool displayOnly;
  FoodAmenities? listFOod;
  VoidCallback? onDelete;

  @override
  State<FoodItem> createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: !widget.displayOnly
          ? (event) {
              setState(() {
                isHovered = true;
              });
            }
          : null,
      onExit: !widget.displayOnly
          ? (event) {
              setState(() {
                isHovered = false;
              });
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 15,
          bottom: 15,
        ),
        child: Container(
          // decoration: BoxDecoration(
          //   color: Colors.greenAccent,
          // ),
          height: 145,
          width: 125,
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: Image.network(widget.listFOod!.photo!).image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      // width: 100,
                      height: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.listFOod!.amenitiesName!,
                              style: helveticaText.copyWith(
                                fontSize: 14,
                                color: eerieBlack,
                                fontWeight: FontWeight.w300,
                                height: 1.3,
                              ),
                            ),
                          ),
                          Text(
                            widget.listFOod!.qty!.toString(),
                            style: helveticaText.copyWith(
                              fontSize: 14,
                              color: davysGray,
                              fontWeight: FontWeight.w300,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
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
