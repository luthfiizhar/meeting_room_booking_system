import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/user_admin_page/user_admin_page.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/black_checkbox.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';

class AddUserAdminDialog extends StatefulWidget {
  AddUserAdminDialog({
    super.key,
    UserAdmin? userAdmin,
  }) : userAdmin = userAdmin ?? UserAdmin();

  UserAdmin userAdmin;

  @override
  State<AddUserAdminDialog> createState() => _AddUserAdminDialogState();
}

class _AddUserAdminDialogState extends State<AddUserAdminDialog> {
  ReqAPI apiReq = ReqAPI();
  final formKey = GlobalKey<FormState>();
  final TextEditingController _nip = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneCode = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  FocusNode nipNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode phoneCodeNode = FocusNode();
  FocusNode phoneNumberNode = FocusNode();
  FocusNode buildingNode = FocusNode();

  String nip = "";
  String email = "";
  String phoneCode = "";
  String phoneNumber = "";
  String buildingValue = "1";
  List buildingList = [];

  List<Roles> roleList = [
    // Roles(isChecked: false, name: "System Admin", value: "1"),
    // Roles(isChecked: false, name: "Auditorium Admin", value: "2"),
    // Roles(isChecked: false, name: "Housekeeping", value: "3"),
    // Roles(isChecked: false, name: "Building Maintenance", value: "4"),
    // Roles(isChecked: false, name: "General Affairs", value: "5"),
  ];

  List<DropdownMenuItem> buildingItems(List items) {
    List<DropdownMenuItem> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item['BuildingID'].toString(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                item['BuildingName'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return _menuItems;
  }

  List<double> _getCustomItemsHeights(List items) {
    List<double> _itemsHeights = [];
    for (var i = 0; i < (items.length * 2) - 1; i++) {
      if (i.isEven) {
        _itemsHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _itemsHeights.add(15);
      }
    }
    return _itemsHeights;
  }

  initBuilding() {
    apiReq.getBuildingList().then((value) {
      print(value);
      if (value["Status"].toString() == "200") {
        setState(() {
          buildingList = value['Data'];
        });
      } else if (value['Status'].toString() == "401") {
        showDialog(
          context: context,
          builder: (context) => TokenExpiredDialog(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialogBlack(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Failed connect to API',
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  Future initRoleList() {
    return apiReq.getUserRoleList().then((value) {
      if (value['Status'].toString() == "200") {
        List roleResult = value['Data'];
        for (var element in roleResult) {
          roleList.add(Roles(
            isChecked: false,
            name: element['Name'],
            value: element['Value'],
          ));
        }
        setState(() {});
      } else if (value['Status'].toString() == "401") {
        showDialog(
          context: context,
          builder: (context) => TokenExpiredDialog(
            title: value['Title'],
            contentText: value['Message'],
            isSuccess: false,
          ),
        );
      }
    });
  }

  initDataEdit() {
    print(widget.userAdmin);
    nip = widget.userAdmin.nip;
    _nip.text = nip;
    email = widget.userAdmin.email;
    _email.text = email;
    buildingValue = widget.userAdmin.buildingId;
    List tempRole = widget.userAdmin.roleList;
    phoneCode =
        widget.userAdmin.phoneCode == "-" ? "" : widget.userAdmin.phoneCode;
    _phoneCode.text = phoneCode;
    phoneNumber =
        widget.userAdmin.phoneNumber == "-" ? "" : widget.userAdmin.phoneNumber;
    _phoneNumber.text = phoneNumber;
    for (var element in tempRole) {
      for (var element2 in roleList) {
        if (element['Role'] == element2.value) {
          element2.isChecked = true;
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initBuilding();
    initRoleList().then((value) {
      if (widget.userAdmin.isEdit) {
        initDataEdit();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    nipNode.removeListener(() {});
    emailNode.removeListener(() {});
    phoneCodeNode.removeListener(() {});
    phoneNumberNode.removeListener(() {});
    buildingNode.removeListener(() {});
    nipNode.dispose();
    emailNode.dispose();
    phoneCodeNode.dispose();
    phoneNumberNode.removeListener(() {});
    buildingNode.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 400,
          maxWidth: 500,
          minHeight: 550,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 25,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add New Admin',
                    style: helveticaText.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: eerieBlack,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  inputField(
                    'NIP',
                    SizedBox(
                      width: 200,
                      child: BlackInputField(
                        controller: _nip,
                        enabled: true,
                        focusNode: nipNode,
                        onSaved: (newValue) {
                          nip = newValue.toString();
                        },
                        validator: (value) =>
                            value == "" ? "This field is required" : null,
                        hintText: 'NIP here...',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  inputField(
                    'Email',
                    Expanded(
                      child: BlackInputField(
                        controller: _email,
                        focusNode: emailNode,
                        enabled: true,
                        onSaved: (newValue) {
                          email = newValue.toString();
                        },
                        validator: (value) =>
                            value == "" ? "This field is required" : null,
                        hintText: 'Email here...',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  inputField(
                    'Phone',
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: BlackInputField(
                              controller: _phoneCode,
                              focusNode: phoneCodeNode,
                              prefixIcon: const Icon(Icons.add),
                              enabled: true,
                              onSaved: (newValue) {
                                phoneCode = newValue.toString();
                              },
                              validator: (value) => value == "" ? "" : null,
                              // hintText: 'Phone code',
                              contentPadding: const EdgeInsets.only(
                                top: 18,
                                bottom: 15,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: BlackInputField(
                              controller: _phoneNumber,
                              focusNode: phoneNumberNode,
                              enabled: true,
                              onSaved: (newValue) {
                                phoneNumber = newValue.toString();
                              },
                              validator: (value) => value == "" ? "" : null,
                              hintText: 'Phone number here...',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  inputField(
                    'Building',
                    SizedBox(
                      width: 250,
                      child: BlackDropdown(
                        items: buildingItems(buildingList),
                        focusNode: buildingNode,
                        customHeights: _getCustomItemsHeights(buildingList),
                        value: buildingValue,
                        onChanged: (value) {
                          buildingValue = value;
                        },
                        enabled: true,
                        hintText: 'Choose',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  checkboxField(
                    'Role',
                    Expanded(
                      child: Wrap(
                        spacing: 15,
                        direction: Axis.vertical,
                        children: roleList.map((e) {
                          return BlackCheckBox(
                            selectedValue: e.isChecked,
                            onChanged: (value) {
                              setState(() {
                                if (e.isChecked) {
                                  e.isChecked = false;
                                } else {
                                  e.isChecked = true;
                                }
                              });
                            },
                            filled: true,
                            label: e.name,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TransparentButtonBlack(
                        text: 'Cancel',
                        disabled: false,
                        padding: ButtonSize().mediumSize(),
                        onTap: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      RegularButton(
                        text: 'Confirm',
                        disabled: false,
                        padding: ButtonSize().mediumSize(),
                        onTap: () {
                          UserAdmin userAdmin = UserAdmin();
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            userAdmin.nip = nip;
                            userAdmin.email = email;
                            userAdmin.phoneCode = phoneCode;
                            userAdmin.phoneNumber = phoneNumber;
                            userAdmin.buildingId = buildingValue;
                            List selectedRole = roleList
                                .where((element) => element.isChecked)
                                .toList();
                            for (var element in roleList
                                .where((element) => element.isChecked)
                                .toList()) {
                              userAdmin.roleList.add('"${element.value}"');
                            }

                            print(userAdmin);
                            if (widget.userAdmin.isEdit) {
                              apiReq.updateUserAdmin(userAdmin).then((value) {
                                if (value['Status'].toString() == "200") {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogBlack(
                                      title: value['Title'],
                                      contentText: value['Message'],
                                      isSuccess: true,
                                    ),
                                  ).then((value) {
                                    Navigator.of(context).pop();
                                  });
                                } else if (value['Status'].toString() ==
                                    "401") {
                                  showDialog(
                                    context: context,
                                    builder: (context) => TokenExpiredDialog(
                                      title: value['Title'],
                                      contentText: value['Message'],
                                      isSuccess: false,
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogBlack(
                                      title: value['Title'],
                                      contentText: value['Message'],
                                      isSuccess: false,
                                    ),
                                  );
                                }
                              }).onError((error, stackTrace) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialogBlack(
                                    title: "Error addUserAdmin",
                                    contentText: error.toString(),
                                    isSuccess: false,
                                  ),
                                );
                              });
                            } else {
                              apiReq.addUserAdmin(userAdmin).then((value) {
                                if (value['Status'].toString() == "200") {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogBlack(
                                      title: value['Title'],
                                      contentText: value['Message'],
                                      isSuccess: true,
                                    ),
                                  ).then((value) {
                                    Navigator.of(context).pop();
                                  });
                                } else if (value['Status'].toString() ==
                                    "401") {
                                  showDialog(
                                    context: context,
                                    builder: (context) => TokenExpiredDialog(
                                      title: value['Title'],
                                      contentText: value['Message'],
                                      isSuccess: false,
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialogBlack(
                                      title: value['Title'],
                                      contentText: value['Message'],
                                      isSuccess: false,
                                    ),
                                  );
                                }
                              }).onError((error, stackTrace) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialogBlack(
                                    title: "Error addUserAdmin",
                                    contentText: error.toString(),
                                    isSuccess: false,
                                  ),
                                );
                              });
                            }
                          }
                        },
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

  Widget inputField(String label, Widget widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: helveticaText.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: davysGray,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        widget,
      ],
    );
  }

  Widget checkboxField(String label, Widget widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: helveticaText.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: davysGray,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        widget,
      ],
    );
  }
}

class Roles {
  Roles({
    this.value = "",
    this.name = "",
    this.isChecked = false,
  });
  String value;
  String name;
  bool isChecked;

  Map<String, dynamic> toJson() => {
        '"Value"': '"$value"',
        '"Name"': '"$name"',
        '"isChecked"': '"$isChecked"'
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
