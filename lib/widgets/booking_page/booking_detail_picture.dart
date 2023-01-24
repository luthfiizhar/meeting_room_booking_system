import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:shimmer/shimmer.dart';

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
        maxHeight: 470,
      ),
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: davysGray,
                ),
                child: Column(
                  children: [
                    Container(
                      height: widget.pictures!.length == 1 ? 350 : 270,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(10),
                          topRight: const Radius.circular(10),
                          bottomLeft: widget.pictures!.length == 1
                              ? const Radius.circular(10)
                              : Radius.zero,
                          bottomRight: widget.pictures!.length == 1
                              ? const Radius.circular(10)
                              : Radius.zero,
                        ),
                        // image: DecorationImage(
                        //   image: widget.pictNotFound
                        //       ? Image.asset('asset/image_not_found.jpg').image
                        //       : NetworkImage(
                        //           widget.pictures!.first['ImageURL']),
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      child: widget.pictures!.first['ImageURL'] == ""
                          ? const SizedBox()
                          : CachedNetworkImage(
                              imageUrl: widget.pictures!.first['ImageURL'],
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  height:
                                      widget.pictures!.length == 1 ? 350 : 270,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(10),
                                      topRight: const Radius.circular(10),
                                      bottomLeft: widget.pictures!.length == 1
                                          ? const Radius.circular(10)
                                          : Radius.zero,
                                      bottomRight: widget.pictures!.length == 1
                                          ? const Radius.circular(10)
                                          : Radius.zero,
                                    ),
                                  ),
                                );
                              },
                              placeholder: (context, url) {
                                return Shimmer(
                                  gradient: const LinearGradient(
                                    colors: [platinum, grayx11, davysGray],
                                  ),
                                  direction: ShimmerDirection.rtl,
                                  child: Container(
                                    height: widget.pictures!.length == 1
                                        ? 350
                                        : 270,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(10),
                                        topRight: const Radius.circular(10),
                                        bottomLeft: widget.pictures!.length == 1
                                            ? const Radius.circular(10)
                                            : Radius.zero,
                                        bottomRight:
                                            widget.pictures!.length == 1
                                                ? const Radius.circular(10)
                                                : Radius.zero,
                                      ),
                                    ),
                                  ),
                                );
                              },
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
                  // overflow: TextOverflow.ellipsis,
                ),
                // softWrap: true,
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
