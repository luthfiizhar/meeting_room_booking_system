import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';

class SelectAmenitiesDialog extends StatefulWidget {
  SelectAmenitiesDialog({
    super.key,
    this.setListAmenities,
  });

  Function? setListAmenities;

  @override
  State<SelectAmenitiesDialog> createState() => _SelectAmenitiesDialogState();
}

class _SelectAmenitiesDialogState extends State<SelectAmenitiesDialog> {
  List listAmen = [
    {'name': 'TV', 'qty': 0},
    {'name': 'Camera', 'qty': 0},
    {'name': 'Cable Roll', 'qty': 0},
    {'name': 'Digital Flip Chart', 'qty': 0},
    {'name': 'Flip Chart', 'qty': 0},
    {'name': 'Laser Pointer', 'qty': 0},
    {'name': 'Screen Projector (LCD)', 'qty': 0},
    {'name': 'Cable Extension', 'qty': 0}
  ];

  List selectedAmen = [];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      // shape: OutlinedBorder,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 550,
          minHeight: 520,
          minWidth: 450,
          maxWidth: 450,
        ),
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
              children: [
                const Text(
                  'Select Amenities',
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
                  itemCount: listAmen.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            bottom: index < listAmen.length - 1 ? 5 : 0,
                            top: index != 0 ? 5 : 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  listAmen[index]['name'],
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
                                        if (listAmen[index]['qty'] > 0) {
                                          listAmen[index]['qty']--;
                                        } else {
                                          listAmen[index]['qty'] = 0;
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
                                    listAmen[index]['qty'].toString(),
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
                                        listAmen[index]['qty']++;
                                        setState(() {});
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
                        index < listAmen.length - 1
                            ? Divider(
                                color: sonicSilver,
                                thickness: 0.5,
                              )
                            : SizedBox(),
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
                        selectedAmen = listAmen
                            .where((element) => element['qty'] > 0)
                            .toList();
                        print(selectedAmen);
                        widget.setListAmenities!(selectedAmen);
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
    );
  }
}
