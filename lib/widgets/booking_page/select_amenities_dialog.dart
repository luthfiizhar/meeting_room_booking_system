import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
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
  List<Amenities>? listAmen;

  @override
  State<SelectAmenitiesDialog> createState() => _SelectAmenitiesDialogState();
}

class _SelectAmenitiesDialogState extends State<SelectAmenitiesDialog> {
  List listAmen = [];
  List<Amenities> amenities = [];

  List selectedAmen = [];
  List<SelectQtyFacilityInputField> inputList = [];

  Future initListAmen() async {
    for (var element in widget.listAmen!) {
      amenities.add(
        Amenities(
            // amenitiesId: element['AmenitiesID'] ?? element.amenitiesId,
            // amenitiesName: element['AmenitiesName'] ?? element.amenitiesName,
            // qty: element['Default'] ?? element.qty,
            // photo: element['ImageURL'] ?? element.photo,
            // defaultAmount: element['Default'] ?? element.defaultAmount),
            amenitiesId: element.amenitiesId,
            amenitiesName: element.amenitiesName,
            qty: element.qty,
            photo: element.photo,
            defaultAmount: element.defaultAmount),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.listAmen!);
    initListAmen().then((value) {
      for (var element in amenities) {
        inputList.add(
          SelectQtyFacilityInputField(
            facility: element,
          ),
        );
      }
      setState(() {});
    });
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
                    itemCount: inputList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              bottom: index < inputList.length - 1 ? 5 : 0,
                              top: index != 0 ? 5 : 0,
                            ),
                            child: inputList[index],
                            // child: Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Expanded(
                            //       child: Text(
                            //         amenities[index].amenitiesName!,
                            //         style: const TextStyle(
                            //           height: 1.3,
                            //           fontFamily: 'Helvetica',
                            //           fontSize: 18,
                            //           color: eerieBlack,
                            //           fontWeight: FontWeight.w300,
                            //         ),
                            //       ),
                            //     ),
                            //     Row(
                            //       children: [
                            //         SizedBox(
                            //           width: 25,
                            //           height: 25,
                            //           child: RegularButton(
                            //             disabled: false,
                            //             text: '-',
                            //             onTap: () {
                            //               int min = amenities[index].qty!;
                            //               if (amenities[index].defaultAmount! ==
                            //                   0) {
                            //                 if (min > 0) {
                            //                   min--;
                            //                   amenities[index].qty = min;
                            //                 } else {
                            //                   min = 0;
                            //                   amenities[index].qty = min;
                            //                 }
                            //               }

                            //               setState(() {});
                            //             },
                            //             padding: ButtonSize().itemQtyButton(),
                            //             fontWeight: FontWeight.w300,
                            //             radius: 5,
                            //           ),
                            //         ),
                            //         const SizedBox(
                            //           width: 20,
                            //         ),
                            //         Text(
                            //           amenities[index].qty.toString(),
                            //           style: const TextStyle(
                            //             fontFamily: 'Helvetica',
                            //             fontSize: 18,
                            //             color: eerieBlack,
                            //             fontWeight: FontWeight.w300,
                            //           ),
                            //         ),
                            //         const SizedBox(
                            //           width: 20,
                            //         ),
                            //         SizedBox(
                            //           width: 25,
                            //           height: 25,
                            //           child: RegularButton(
                            //             disabled: false,
                            //             text: '+',
                            //             onTap: () {
                            //               // listAmen[index]['qty']++;
                            //               setState(() {
                            //                 int plus = amenities[index].qty!;
                            //                 plus++;
                            //                 amenities[index].qty = plus;
                            //               });
                            //             },
                            //             padding: ButtonSize().itemQtyButton(),
                            //             fontWeight: FontWeight.w300,
                            //             radius: 5,
                            //           ),
                            //         )
                            //       ],
                            //     ),
                            //   ],
                            // ),
                          ),
                          index < inputList.length - 1
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
                          List<Amenities> amen = [];
                          inputList
                              .where((element) => element.facility.qty! > 0)
                              .forEach((element) {
                            amen.add(
                              Amenities(
                                amenitiesId: element.facility.amenitiesId,
                                amenitiesName: element.facility.amenitiesName,
                                qty: element.facility.qty,
                                photo: element.facility.photo,
                              ),
                            );
                          });

                          widget.setListAmenities!(amen);
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

class SelectQtyFacilityInputField extends StatefulWidget {
  SelectQtyFacilityInputField({
    super.key,
    Amenities? facility,
  }) : facility = facility ?? Amenities();

  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  Amenities facility;

  @override
  State<SelectQtyFacilityInputField> createState() =>
      _SelectQtyFacilityInputFieldState();
}

class _SelectQtyFacilityInputFieldState
    extends State<SelectQtyFacilityInputField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.text = widget.facility.qty.toString();

    widget.focusNode.addListener(() {
      if (!widget.focusNode.hasFocus) {
        if (widget.controller.text == "") {
          widget.controller.text = "0";
          setState(() {});
        } else {
          widget.facility.qty = int.parse(widget.controller.text);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.facility.amenitiesName!,
            style: helveticaText.copyWith(
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
                  setState(() {
                    int min = widget.facility.qty!;
                    if (min > 0) {
                      min--;
                    } else {
                      min = 0;
                    }
                    widget.facility.qty = min;
                    widget.controller.text = min.toString();
                  });
                },
                padding: ButtonSize().itemQtyButton(),
                fontWeight: FontWeight.w300,
                radius: 5,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 50,
              child: TextFormField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: davysGray,
                      width: 1,
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: eerieBlack,
                      width: 1,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  isDense: true,
                  isCollapsed: true,
                ),
                textAlign: TextAlign.center,
                style: helveticaText.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
                // onChanged: (value) {
                //   if (value == "") {
                //     widget.qtyController!.text = "0";
                //   }
                // },
              ),
            ),
            // Text(
            //   foodAmen[index].qty.toString(),
            //   style: helveticaText.copyWith(
            //     fontSize: 18,
            //     color: eerieBlack,
            //     fontWeight: FontWeight.w300,
            //   ),
            // ),
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
                  int plus;
                  setState(() {
                    plus = widget.facility.qty!;
                    plus++;
                    widget.facility.qty = plus;
                    widget.controller.text = plus.toString();
                  });
                },
                padding: ButtonSize().itemQtyButton(),
                fontWeight: FontWeight.w300,
                radius: 5,
              ),
            )
          ],
        )
        // Builder(builder: (context) {
        //   TextEditingController _qty = TextEditingController();
        //   return InputFieldQtyFood(
        //     qtyController: _qty,
        //     qty: foodAmen[index].qty!,
        //   );
        // }),
      ],
    );
  }
}
