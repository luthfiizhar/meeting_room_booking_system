import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';

class SelectFoodDialog extends StatefulWidget {
  SelectFoodDialog({
    super.key,
    this.setListFood,
  });

  Function? setListFood;

  @override
  State<SelectFoodDialog> createState() => _SelectFoodDialogState();
}

class _SelectFoodDialogState extends State<SelectFoodDialog> {
  List listFood = [
    {'name': 'Water', 'qty': 0},
    {'name': 'Tea', 'qty': 0},
    {'name': 'Coffe', 'qty': 0},
    {'name': 'Food', 'qty': 0},
  ];

  List selectedFood = [];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      // shape: OutlinedBorder,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 345,
          minHeight: 345,
          minWidth: 370,
          maxWidth: 370,
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
                  itemCount: listFood.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            bottom: index < listFood.length - 1 ? 5 : 0,
                            top: index != 0 ? 5 : 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  listFood[index]['name'],
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
                                        if (listFood[index]['qty'] > 0) {
                                          listFood[index]['qty']--;
                                        } else {
                                          listFood[index]['qty'] = 0;
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
                                    listFood[index]['qty'].toString(),
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
                                        listFood[index]['qty']++;
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
                        index < listFood.length - 1
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
                        selectedFood = listFood
                            .where((element) => element['qty'] > 0)
                            .toList();
                        print(selectedFood);
                        widget.setListFood!(selectedFood);
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
