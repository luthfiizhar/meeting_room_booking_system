import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/amenities_class.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';

class SelectAmenitiesDialog extends StatefulWidget {
  SelectAmenitiesDialog({
    super.key,
    this.setListAmenities,
    this.roomId,
    this.listAmen,
  });

  Function? setListAmenities;
  String? roomId;
  List? listAmen;

  @override
  State<SelectAmenitiesDialog> createState() => _SelectAmenitiesDialogState();
}

class _SelectAmenitiesDialogState extends State<SelectAmenitiesDialog> {
  List listAmen = [];
  List<Amenities> amenities = [];

  List selectedAmen = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // getAmenitiesList(widget.roomId!).then((value) {
    //   // print(value);
    //   setState(() {
    //     listAmen = value['Data'];
    print(widget.listAmen!);
    for (var element in widget.listAmen!) {
      amenities.add(
        Amenities(
            amenitiesId: element['AmenitiesID'] ?? element.amenitiesId,
            amenitiesName: element['AmenitiesName'] ?? element.amenitiesName,
            qty: element['Default'] ?? element.qty,
            photo: element['ImageURL'] ?? element.photo),
      );
    }
    //     print(amenities.toString());
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      // shape: OutlinedBorder,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 550,
          minHeight: 200,
          minWidth: 450,
          maxWidth: 450,
        ),
        child: SingleChildScrollView(
          child: Container(
            // width: 450,
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 25,
            ),
            decoration: BoxDecoration(
              color: culturedWhite,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              // color: Colors.green,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Facilities',
                    style: TextStyle(
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: amenities.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              bottom: index < amenities.length - 1 ? 5 : 0,
                              top: index != 0 ? 5 : 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    amenities[index].amenitiesName!,
                                    style: const TextStyle(
                                      height: 1.3,
                                      fontFamily: 'Helvetica',
                                      fontSize: 18,
                                      color: eerieBlack,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: RegularButton(
                                        disabled: false,
                                        text: '-',
                                        onTap: () {
                                          int min = amenities[index].qty!;

                                          if (min > 0) {
                                            min--;
                                            amenities[index].qty = min;
                                          } else {
                                            min = 0;
                                            amenities[index].qty = min;
                                          }
                                          setState(() {});
                                        },
                                        padding: ButtonSize().itemQtyButton(),
                                        fontWeight: FontWeight.w300,
                                        radius: 5,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      amenities[index].qty.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Helvetica',
                                        fontSize: 18,
                                        color: eerieBlack,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: RegularButton(
                                        disabled: false,
                                        text: '+',
                                        onTap: () {
                                          // listAmen[index]['qty']++;
                                          setState(() {
                                            int plus = amenities[index].qty!;
                                            plus++;
                                            amenities[index].qty = plus;
                                          });
                                        },
                                        padding: ButtonSize().itemQtyButton(),
                                        fontWeight: FontWeight.w300,
                                        radius: 5,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          index < amenities.length - 1
                              ? const Divider(
                                  color: sonicSilver,
                                  thickness: 0.5,
                                )
                              : const SizedBox(),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RegularButton(
                        text: 'Confirm',
                        disabled: false,
                        onTap: () {
                          // Amenities amen = Amenities();
                          selectedAmen = amenities
                              .where((element) => element.qty! > 0)
                              .toList();
                          widget.setListAmenities!(selectedAmen);
                          // print(selectedAmen);
                          Navigator.of(context).pop();
                        },
                        padding: ButtonSize().mediumSize(),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
