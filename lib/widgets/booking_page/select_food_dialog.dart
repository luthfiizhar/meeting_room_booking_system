import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/model/amenities_class.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';

class SelectFoodDialog extends StatefulWidget {
  SelectFoodDialog({
    super.key,
    this.setListFood,
    this.listFood,
  });

  Function? setListFood;
  List? listFood;

  @override
  State<SelectFoodDialog> createState() => _SelectFoodDialogState();
}

class _SelectFoodDialogState extends State<SelectFoodDialog> {
  List listFood = [];
  List<FoodAmenities> foodAmen = [];
  List<InputFieldQtyFood> inputFood = [];

  Future setFoodAmen() async {
    for (var element in widget.listFood!) {
      foodAmen.add(
        FoodAmenities(
            amenitiesId: element['FoodAmenitiesID'].toString(),
            amenitiesName: element['AmenitiesName'],
            qty: element['Amount'],
            photo: element['ImageURL']),
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setFoodAmen().then(
      (value) {
        for (var element in foodAmen) {
          inputFood.add(InputFieldQtyFood(
            // name: element.amenitiesName!,
            // qty: element.qty!,
            food: element,
          ));
        }
        setState(() {});
      },
    );
    print('food Amne');
    print(foodAmen);
  }

  List selectedFood = [];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      // shape: OutlinedBorder,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 500,
          minHeight: 200,
          minWidth: 370,
          maxWidth: 370,
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
                    'Select Food & Beverages',
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
                    itemCount: inputFood.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              bottom: index < inputFood.length - 1 ? 5 : 0,
                              top: index != 0 ? 5 : 0,
                            ),
                            child: inputFood[index],
                            // child: Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Expanded(
                            //       child: Text(
                            //         foodAmen[index].amenitiesName!,
                            //         style: helveticaText.copyWith(
                            //           fontSize: 18,
                            //           color: eerieBlack,
                            //           fontWeight: FontWeight.w300,
                            //         ),
                            //       ),
                            //     ),
                            //     Builder(builder: (context) {
                            //       TextEditingController _qty =
                            //           TextEditingController();
                            //       return InputFieldQtyFood(
                            //         qtyController: _qty,
                            //         qty: foodAmen[index].qty!,
                            //       );
                            //     }),
                            //   ],
                            // ),
                          ),
                          index < inputFood.length - 1
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
                          List<FoodAmenities> temp = [];
                          selectedFood = inputFood
                              .where((element) => element.food.qty! > 0)
                              .toList();
                          inputFood
                              .where((element) => element.food.qty! > 0)
                              .forEach((element) {
                            temp.add(
                              FoodAmenities(
                                amenitiesName: element.food.amenitiesName,
                                amenitiesId: element.food.amenitiesId,
                                photo: element.food.photo,
                                qty: element.food.qty,
                              ),
                            );
                          });
                          // for (var element in temp) {
                          //   temp.add(FoodAmenities(amenitiesName: element.));
                          // }
                          print(selectedFood);
                          widget.setListFood!(temp);
                          Navigator.of(context).pop();
                        },
                        padding: ButtonSize().mediumSize(),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InputFieldQtyFood extends StatefulWidget {
  InputFieldQtyFood({
    super.key,
    FoodAmenities? food,
  }) : food = food ?? FoodAmenities();

  TextEditingController? qtyController = TextEditingController();
  // int qty;
  // String name;
  FoodAmenities food;
  FocusNode? focusNode = FocusNode();

  @override
  State<InputFieldQtyFood> createState() => _InputFieldQtyFoodState();
}

class _InputFieldQtyFoodState extends State<InputFieldQtyFood> {
  Future setController() async {
    widget.qtyController = TextEditingController();
  }

  @override
  void initState() {
    super.initState();
    // setController().then((value) {
    widget.qtyController!.text = widget.food.qty.toString();
    widget.focusNode!.addListener(() {
      if (!widget.focusNode!.hasFocus) {
        if (widget.qtyController!.text == "") {
          widget.qtyController!.text = "0";
          setState(() {});
        } else {
          widget.food.qty = int.parse(widget.qtyController!.text);
        }
      }
    });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.food.amenitiesName!,
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
                    int min = widget.food.qty!;
                    if (min > 0) {
                      min--;
                    } else {
                      min = 0;
                    }
                    widget.food.qty = min;
                    widget.qtyController!.text = min.toString();
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
                controller: widget.qtyController,
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
                    plus = widget.food.qty!;
                    plus++;
                    widget.food.qty = plus;
                    widget.qtyController!.text = plus.toString();
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
