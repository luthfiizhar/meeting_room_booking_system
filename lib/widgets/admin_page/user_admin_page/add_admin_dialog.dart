import 'package:flutter/material.dart';

class AddUserAdminDialog extends StatefulWidget {
  const AddUserAdminDialog({super.key});

  @override
  State<AddUserAdminDialog> createState() => _AddUserAdminDialogState();
}

class _AddUserAdminDialogState extends State<AddUserAdminDialog> {
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
  String buildingValue = "";
  List buildingList = [];

  List<Roles> roleList = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 400,
          minHeight: 550,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 25,
          ),
        ),
      ),
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
}
