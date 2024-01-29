import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/button/button_size.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_black.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_button_white.dart';
import 'package:meeting_room_booking_system/widgets/checkboxes/black_checkbox.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';
import 'package:meeting_room_booking_system/widgets/input_field/white_input_field.dart';

class ConfirmBookingPhoneDialog extends StatefulWidget {
  ConfirmBookingPhoneDialog({super.key, Function? submit})
      : submit = submit ?? (() {});

  Function submit;

  @override
  State<ConfirmBookingPhoneDialog> createState() =>
      _ConfirmBookingPhoneDialogState();
}

class _ConfirmBookingPhoneDialogState extends State<ConfirmBookingPhoneDialog> {
  bool useProfileData = true;

  TextEditingController _avaya = TextEditingController();
  TextEditingController _phoneCode = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();

  FocusNode avayaNode = FocusNode();
  FocusNode phoneCodeNode = FocusNode();
  FocusNode phoneNumberNode = FocusNode();

  String avaya = "";
  String phoneCode = "";
  String phoneNumber = "";

  String avayaProfile = "";
  String phoneCodeProfile = "";
  String phoneNumberProfile = "";

  final formKey = GlobalKey<FormState>();

  Future initGetUserProfile() {
    return ReqAPI().getUserProfile().then((value) {
      // print("User Profile -> $value");
      if (value['Status'].toString() == "200") {
        setState(() {
          // name = value['Data']['EmpName'];
          // nip = value['Data']['EmpNIP'];
          // email = value['Data']['Email'];
          avaya = value['Data']['AvayaNumber'] ?? "";
          phoneCode = value['Data']['CountryCode'];
          phoneNumber = value['Data']['PhoneNumber'];
          avayaProfile = value['Data']['AvayaNumber'] ?? "";
          phoneCodeProfile = value['Data']['CountryCode'];
          phoneNumberProfile = value['Data']['PhoneNumber'];
          // phoneOptions = value['Data']['DisplayPhoneNumber'];

          _avaya.text = avaya;
          _phoneCode.text = phoneCode;
          _phoneNumber.text = phoneNumber;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initGetUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 620,
          maxWidth: 620,
        ),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 35),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Contact Detail",
                style: helveticaText.copyWith(
                  fontSize: 24,
                  height: 28 / 24,
                  color: eerieBlack,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Please fill your personal info, so other people can easily contact you about your booking.",
                style: helveticaText.copyWith(
                  fontSize: 18,
                  height: 25 / 18,
                  color: eerieBlack,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              BlackCheckBox(
                selectedValue: useProfileData,
                onChanged: (value) {
                  useProfileData = !useProfileData;
                  if (useProfileData) {
                    _avaya.text = phoneNumberProfile;
                    _phoneCode.text = phoneCodeProfile;
                    _phoneNumber.text = phoneNumberProfile;
                  } else {
                    _avaya.text = "";
                    _phoneCode.text = "";
                    _phoneNumber.text = "";
                  }
                  setState(() {});
                },
                label: "Use my profile data",
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: avayaSection(),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  SizedBox(
                    width: 272,
                    child: phoneSection(),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TransparentButtonBlack(
                    text: "Cancel",
                    disabled: false,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    padding: ButtonSize().mediumSize(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RegularButton(
                    text: "Submit",
                    disabled: false,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        ReqAPI()
                            .validatePhoneDialog(avaya, phoneNumber, phoneCode)
                            .then((value) {
                          if (value["Status"].toString() == "200") {
                            widget.submit(avaya, phoneNumber, phoneCode);
                            Navigator.of(context).pop(1);
                            // print("oke");
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
                              title: "Failed",
                              contentText: error.toString(),
                              isSuccess: false,
                            ),
                          );
                        });
                      }
                    },
                    padding: ButtonSize().mediumSize(),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget avayaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Avaya:",
          style: helveticaText.copyWith(
            fontSize: 18,
            height: 21 / 18,
            color: eerieBlack,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        BlackInputField(
          controller: _avaya,
          enabled: true,
          focusNode: avayaNode,
          obsecureText: false,
          hintText: "Type here...",
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onSaved: (value) {
            avaya = value.toString();
          },
          validator: (value) =>
              value == "" && _phoneNumber.text == "" ? "Avaya required" : null,
        ),
      ],
    );
  }

  Widget phoneSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Phone:",
          style: helveticaText.copyWith(
            fontSize: 18,
            height: 21 / 18,
            color: eerieBlack,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 60,
              child: BlackInputField(
                controller: _phoneCode,
                enabled: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                // contentPadding: const EdgeInsets.only(
                //     right: 10, left: 10, top: 18, bottom: 15),
                focusNode: phoneCodeNode,
                obsecureText: false,
                // prefixIcon: const Icon(
                //   Icons.add,
                //   size: 16,
                // ),
                hintText: "Code",
                onSaved: (value) {
                  phoneCode = value.toString();
                },
                validator: (value) =>
                    _phoneNumber.text == "" && _avaya.text == "" ? "" : null,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: SizedBox(
                child: BlackInputField(
                  controller: _phoneNumber,
                  enabled: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  focusNode: phoneNumberNode,
                  obsecureText: false,
                  hintText: "Phone number here",
                  onSaved: (value) {
                    phoneNumber = value.toString();
                  },
                  validator: (value) => value == "" && _avaya.text == ""
                      ? "Phone number required"
                      : null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
