import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/model/amenities_class.dart';

class RoomFacilityItem extends StatefulWidget {
  RoomFacilityItem({
    super.key,
    this.onDelete,
    this.displayOnly = false,
    this.image,
    this.name,
    this.qty,
    this.result,
  });

  VoidCallback? onDelete;
  bool displayOnly;
  String? name;
  String? qty;
  String? image;
  Amenities? result;

  @override
  State<RoomFacilityItem> createState() => _RoomFacilityItemState();
}

class _RoomFacilityItemState extends State<RoomFacilityItem> {
  bool isHovered = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.image);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: widget.result!.defaultAmount! > 0
          ? null
          : !widget.displayOnly
              ? (event) {
                  setState(() {
                    isHovered = true;
                  });
                }
              : null,
      onExit: widget.result!.defaultAmount! > 0
          ? null
          : !widget.displayOnly
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
          decoration: BoxDecoration(
              // color: Colors.greenAccent,
              ),
          height: 165,
          width: 125,
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: Image.network(widget.result!.photo!).image,
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
                              widget.result!.amenitiesName!,
                              style: helveticaText.copyWith(
                                fontSize: 14,
                                color: eerieBlack,
                                fontWeight: FontWeight.w300,
                                height: 1.3,
                              ),
                            ),
                          ),
                          Text(
                            "${widget.result!.qty!.toString()} Unit",
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
