import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';

class BookingRoomPicture extends StatefulWidget {
  BookingRoomPicture({
    super.key,
    this.pictures,
    this.name,
    this.area,
    this.pictNotFound = true,
  });

  List? pictures;
  String? name;
  String? area;
  bool pictNotFound = false;

  @override
  State<BookingRoomPicture> createState() => _BookingRoomPictureState();
}

class _BookingRoomPictureState extends State<BookingRoomPicture> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.pictures);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 450,
        minWidth: 500,
        maxWidth: 500,
        maxHeight: 500,
      ),
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: davysGray,
                ),
                child: Column(
                  children: [
                    Container(
                      height: widget.pictures!.length == 1 ? 350 : 270,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          image: widget.pictNotFound
                              ? Image.asset('asset/image_not_found.jpg').image
                              : NetworkImage(
                                  widget.pictures!.first['ImageURL']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    widget.pictures!.length == 1
                        ? const SizedBox()
                        : Container(
                            height: 80,
                            width: 500,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                var borderRadius = index == 0
                                    ? BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                      )
                                    : index == 4
                                        ? BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                          )
                                        : null;
                                return Container(
                                  width: 100,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: borderRadius,
                                    image: DecorationImage(
                                      image: widget.pictNotFound
                                          ? Image.asset(
                                                  'asset/image_not_found.jpg')
                                              .image
                                          : NetworkImage(widget
                                              .pictures!.first['ImageURL']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                widget.name!,
                style: const TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.area!,
                style: const TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
