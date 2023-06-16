import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';

class EmailSuggestionContainer extends StatefulWidget {
  EmailSuggestionContainer({
    super.key,
    this.contactList,
    this.isEmpty = true,
    this.emptyMessage = "",
    this.filter = "",
    this.selectGuest,
  });

  List? contactList;
  bool isEmpty;
  String emptyMessage;
  String filter;
  Function? selectGuest;

  @override
  State<EmailSuggestionContainer> createState() =>
      _EmailSuggestionContainerState();
}

class _EmailSuggestionContainerState extends State<EmailSuggestionContainer> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 400,
        maxWidth: 400,
        minHeight: 0,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: eerieBlack,
            borderRadius: BorderRadius.circular(10),
          ),
          child: widget.isEmpty
              ? SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Name / Email not found.',
                      style: helveticaText.copyWith(
                        color: white,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.contactList!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            widget.selectGuest!(
                                widget.contactList![index]['Email']);
                          },
                          child: EmailSuggestionListBody(
                            name: widget.contactList![index]['FullName'],
                            email: widget.contactList![index]['Email'],
                          ),
                        ),
                        index == widget.contactList!.length - 1
                            ? const SizedBox()
                            : const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Divider(
                                  color: culturedWhite,
                                  thickness: 0.5,
                                ),
                              )
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class EmailSuggestionListBody extends StatelessWidget {
  EmailSuggestionListBody({
    super.key,
    this.name = "",
    this.email = "",
  });

  String name;
  String email;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: helveticaText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            email,
            style: helveticaText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: culturedWhite,
            ),
          ),
        ],
      ),
    );
  }
}
