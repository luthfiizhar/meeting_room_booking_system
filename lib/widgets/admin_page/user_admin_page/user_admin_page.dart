import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/search_term.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/user_admin_page/add_admin_dialog.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/confirmation_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/input_field/search_input_field.dart';

class AdminUserPage extends StatefulWidget {
  const AdminUserPage({super.key});

  @override
  State<AdminUserPage> createState() => _AdminUserPageState();
}

class _AdminUserPageState extends State<AdminUserPage> {
  ReqAPI apiReq = ReqAPI();
  TextEditingController _search = TextEditingController();
  FocusNode searchNode = FocusNode();
  FocusNode showPerRowsNode = FocusNode();

  SearchTerm searchTerm = SearchTerm(
    keyWords: "",
    max: "5",
    pageNumber: "1",
    orderBy: "EmpNIP",
    orderDir: "ASC",
  );

  int selectedIndexArea = 0;

  List<UserAdmin> adminList = [];
  // User userAdmin
  // List<Amenities> facilities = [];
  int totalResult = 0;

  List showPerPageList = ["5", "10", "20", "50", "100"];

  int currentPaginatedPage = 1;
  List availablePage = [1];
  List showedPage = [1];

  countPagination(int totalRow) {
    print('total row -> $totalRow');
    setState(() {
      availablePage.clear();
      if (totalRow == 0) {
        currentPaginatedPage = 1;
        showedPage = [1];
        availablePage = [1];
      }
      var totalPage = totalRow / int.parse(searchTerm.max);
      for (var i = 0; i < totalPage.ceil(); i++) {
        availablePage.add(i + 1);
      }
      print(availablePage);
      // print(showedPage);
      showedPage = availablePage.take(5).toList();
    });
  }

  onTapHeader(String orderBy) {
    setState(() {
      if (searchTerm.orderBy == orderBy) {
        switch (searchTerm.orderDir) {
          case "ASC":
            searchTerm.orderDir = "DESC";
            break;
          case "DESC":
            searchTerm.orderDir = "ASC";
            break;
          default:
        }
      }
      searchTerm.orderBy = orderBy;
      updateList().then((value) {
        currentPaginatedPage = 1;
        countPagination(totalResult);
      });
    });
  }

  closeDetail(index) {
    setState(() {
      adminList[index].isCollapse = false;
    });
  }

  onClickListUser(int index) {
    setState(() {
      // closeDetail();
      for (var element in adminList) {
        element.isCollapse = false;
      }
      if (!adminList[index].isCollapse) {
        adminList[index].isCollapse = true;
      } else if (adminList[index].isCollapse) {
        adminList[index].isCollapse = false;
      }
    });
  }

  Future updateList() {
    adminList.clear();
    setState(() {});
    return apiReq.getUserAdminList(searchTerm).then((value) {
      if (value['Status'] == '200') {
        List result = value['Data']['List'];
        for (var element in result) {
          adminList.add(UserAdmin(
            name: element['EmpName'],
            nip: element['EmpNIP'],
            roleList: element['Role'],
            phoneCode: element['CountryCode'],
            phoneNumber: element['PhoneNumber'],
            place: "Head Office",
            email: element['Email'],
            buildingId: element['BuildingID'].toString(),
            isCollapse: false,
          ));
        }
        print("admin List --> $adminList");
        // adminList = value['Data'];
        totalResult = value['Data']['TotalRows'];
        // countPagination(value['Data']['TotalRows']);
        // showedPage = availablePage.take(5).toList();
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
          ),
        );
      }
    }).onError((error, stackTrace) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogBlack(
          title: 'Failed connect to API',
          contentText: error.toString(),
        ),
      );
    });
  }

  resetState() {
    updateList().then((value) {
      countPagination(totalResult);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updateList().then((value) {
      countPagination(totalResult);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double paginationWidth = availablePage.length <= 5
        ? ((45 * (showedPage.length.toDouble())))
        : ((55 * (showedPage.length.toDouble())));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Text(
                'Admin List',
                style: helveticaText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: davysGray,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AddUserAdminDialog(),
                ).then((value) {
                  updateList().then((value) {
                    countPagination(totalResult);
                  });
                });
              },
              child: SizedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                      color: orangeAccent,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Add Admin',
                      style: helveticaText.copyWith(
                        fontSize: 16,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                        color: orangeAccent,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 220,
              child: SearchInputField(
                controller: _search,
                enabled: true,
                obsecureText: false,
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search here',
                focusNode: searchNode,
                maxLines: 1,
                onFieldSubmitted: (value) {
                  setState(() {
                    searchTerm.keyWords = value;

                    updateList().then((value) {
                      countPagination(totalResult);
                    });
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        //HEADER
        Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  onTapHeader("EmpNIP");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'NIP',
                        style: helveticaText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: davysGray,
                        ),
                      ),
                    ),
                    iconSort("EmpNIP"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  onTapHeader("EmpName");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Name',
                        style: helveticaText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: davysGray,
                        ),
                      ),
                    ),
                    iconSort("EmpName"),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                // onTap: () {
                //   onTapHeader("Role");
                //   //ROLE
                // },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Role',
                        style: helveticaText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: davysGray,
                        ),
                      ),
                    ),
                    // iconSort("Role"),
                    // const SizedBox(
                    //   width: 20,
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        //HEADER END
        const SizedBox(
          height: 12,
        ),
        const Divider(
          color: spanishGray,
          thickness: 1,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: adminList.length,
          itemBuilder: (context, index) {
            return UserAdminListContainer(
              index: index,
              user: adminList[index],
              onClose: closeDetail,
              onClick: onClickListUser,
              resetState: resetState,
            );
          },
        ),
        const SizedBox(
          height: 30,
        ),
        //FOOTER PAGINATION
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              // color: Colors.amber,
              width: 220,
              child: Row(
                children: [
                  Text(
                    'Show:',
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 120,
                    child: BlackDropdown(
                      focusNode: showPerRowsNode,
                      onChanged: (value) {
                        setState(() {
                          currentPaginatedPage = 1;
                          searchTerm.pageNumber = "1";
                          searchTerm.max = value!.toString();
                          // apiReq
                          //     .getMyBookingList(searchTerm)
                          //     .then((value) {
                          //   myBookList = value['Data']['List'];
                          //   countPagination(value['Data']['TotalRows']);
                          //   showedPage = availablePage.take(5).toList();
                          // });
                          updateList().then((value) {
                            countPagination(totalResult);
                          });
                        });
                      },
                      value: searchTerm.max,
                      items: showPerPageList.map((e) {
                        return DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        );
                      }).toList(),
                      // DropdownMenuItem(
                      //   child: Text('10'),
                      //   value: 10,
                      // ),
                      // DropdownMenuItem(
                      //   child: Text('50'),
                      //   value: 50,
                      // ),
                      // DropdownMenuItem(
                      //   child: Text('100'),
                      //   value: 100,
                      // ),
                      enabled: true,
                      hintText: 'Choose',
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: eerieBlack,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  InkWell(
                    onTap: currentPaginatedPage - 1 > 0
                        ? () {
                            setState(() {
                              currentPaginatedPage = currentPaginatedPage - 1;
                              if (availablePage.length > 5 &&
                                  currentPaginatedPage == showedPage[0] &&
                                  currentPaginatedPage != 1) {
                                showedPage.removeLast();
                                showedPage.insert(0, currentPaginatedPage - 1);
                              }
                              searchTerm.pageNumber =
                                  currentPaginatedPage.toString();

                              // apiReq
                              //     .getMyBookingList(searchTerm)
                              //     .then((value) {
                              //   myBookList = value['Data']['List'];
                              //   countPagination(
                              //       value['Data']['TotalRows']);
                              // });
                              updateList().then((value) {
                                // countPagination(totalResult);
                                setState(() {});
                              });
                            });
                          }
                        : null,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // border: Border.all(
                        //   color: grayx11,
                        //   width: 1,
                        // ),
                      ),
                      child: const Icon(
                        Icons.chevron_left_sharp,
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: paginationWidth, //275,
                    height: 35,
                    child: Row(
                      children: [
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: showedPage.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: InkWell(
                                onTap: currentPaginatedPage == showedPage[index]
                                    ? null
                                    : () {
                                        setState(() {
                                          currentPaginatedPage =
                                              showedPage[index];
                                          if (availablePage.length > 5 &&
                                              index == showedPage.length - 1) {
                                            if (currentPaginatedPage !=
                                                availablePage.last) {
                                              showedPage.removeAt(0);
                                              showedPage.add(
                                                  currentPaginatedPage + 1);
                                            }
                                          }
                                          if (availablePage.length > 5 &&
                                              index == 0 &&
                                              currentPaginatedPage != 1) {
                                            showedPage.removeLast();
                                            showedPage.insert(
                                                0, currentPaginatedPage - 1);
                                          }
                                        });
                                        searchTerm.pageNumber =
                                            currentPaginatedPage.toString();
                                        // apiReq
                                        //     .getMyBookingList(
                                        //         searchTerm)
                                        //     .then((value) {
                                        //   setState(() {
                                        //     myBookList =
                                        //         value['Data']['List'];
                                        //     countPagination(
                                        //         value['Data']
                                        //             ['TotalRows']);
                                        //   });
                                        // });
                                        updateList().then((value) {
                                          // countPagination(totalResult);
                                          setState(() {});
                                        });
                                      },
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 8.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: showedPage[index] ==
                                            currentPaginatedPage
                                        ? eerieBlack
                                        : null,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      showedPage[index].toString(),
                                      style: helveticaText.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2,
                                        color: showedPage[index] ==
                                                currentPaginatedPage
                                            ? culturedWhite
                                            : davysGray,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Visibility(
                          visible: availablePage.length <= 5 ||
                                  currentPaginatedPage == availablePage.last
                              ? false
                              : true,
                          child: Container(
                            width: 35,
                            height: 35,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 8.5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '...',
                                style: helveticaText.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                  color: davysGray,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: currentPaginatedPage != availablePage.last
                        ? () {
                            setState(() {
                              currentPaginatedPage = currentPaginatedPage + 1;
                              if (currentPaginatedPage == showedPage.last &&
                                  currentPaginatedPage != availablePage.last) {
                                showedPage.removeAt(0);
                                showedPage.add(currentPaginatedPage + 1);
                              }
                              searchTerm.pageNumber =
                                  currentPaginatedPage.toString();

                              // apiReq
                              //     .getMyBookingList(searchTerm)
                              //     .then((value) {
                              //   myBookList = value['Data']['List'];
                              //   countPagination(
                              //       value['Data']['TotalRows']);
                              // });
                              updateList().then((value) {
                                // countPagination(totalResult);
                                setState(() {});
                              });
                            });
                          }
                        : null,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // border: Border.all(
                        //   color: grayx11,
                        //   width: 1,
                        // ),
                      ),
                      child: const Icon(
                        Icons.chevron_right_sharp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
        //END FOOTER
      ],
    );
  }

  Widget iconSort(String orderBy) {
    return SizedBox(
      width: 20,
      height: 25,
      child: orderBy != searchTerm.orderBy
          ? Stack(
              children: const [
                Visibility(
                  child: Positioned(
                    top: 0,
                    left: 0,
                    child: Icon(
                      Icons.keyboard_arrow_down_sharp,
                      size: 16,
                    ),
                  ),
                ),
                Visibility(
                  child: Positioned(
                    bottom: 0,
                    left: 0,
                    child: Icon(
                      Icons.keyboard_arrow_up_sharp,
                      size: 16,
                    ),
                  ),
                )
              ],
            )
          : searchTerm.orderDir == "ASC"
              ? const Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.keyboard_arrow_down_sharp,
                    size: 16,
                  ),
                )
              : const Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.keyboard_arrow_up_sharp,
                    size: 16,
                  ),
                ),
    );
  }
}

class UserAdminListContainer extends StatefulWidget {
  UserAdminListContainer({
    super.key,
    this.user,
    this.onClose,
    this.onClick,
    this.index,
    this.resetState,
  });

  // bool isCollapsed;
  UserAdmin? user;
  Function? onClose;
  Function? onClick;
  Function? resetState;
  int? index;

  @override
  State<UserAdminListContainer> createState() => _UserAdminListContainerState();
}

class _UserAdminListContainerState extends State<UserAdminListContainer> {
  ReqAPI apiReq = ReqAPI();
  String name = "";
  String email = "";
  String nip = "";
  String role = "";
  String place = "";
  String phoneCode = "";
  String phoneNumber = "";

  initiate() {
    setState(() {
      // print(widget.user!.roleList);
      name = widget.user!.name;
      email = widget.user!.email;
      nip = widget.user!.nip;
      // role = widget.user!.role;
      place = widget.user!.place;
      phoneCode = widget.user!.phoneCode;
      phoneNumber = widget.user!.phoneNumber;
    });
  }

  @override
  void initState() {
    super.initState();
    initiate();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.user!.isCollapse) {
          widget.onClose!(widget.index);
        } else {
          widget.onClick!(widget.index!);
        }
      },
      child: Column(
        children: [
          widget.index != 0
              ? const Divider(
                  color: grayx11,
                  thickness: 0.5,
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 13,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    nip,
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: davysGray,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    name,
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  ),
                ),
                Expanded(
                  child: Wrap(
                    children: widget.user!.roleList
                        .asMap()
                        .map((index, element) => MapEntry(
                              index,
                              Text(
                                '${element['Name']}  ${index == widget.user!.roleList.length - 1 ? "" : ", "}',
                                style: helveticaText.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                  color: davysGray,
                                ),
                              ),
                            ))
                        .values
                        .toList(),
                    // children: [
                    //   Text(
                    //     role,
                    //     style: helveticaText.copyWith(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.w300,
                    //       color: davysGray,
                    //     ),
                    //   ),
                    // ],
                  ),
                ),
                SizedBox(
                  width: 20,
                  child: widget.user!.isCollapse
                      ? const Icon(
                          Icons.keyboard_arrow_down_sharp,
                        )
                      : const Icon(
                          Icons.keyboard_arrow_right_sharp,
                        ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: widget.user!.isCollapse ? true : false,
            child: detail(),
          ),
        ],
      ),
    );
  }

  Widget detail() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 25,
        bottom: 7,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.mail_outline,
                    color: orangeAccent,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    email,
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 30,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.phone,
                    color: orangeAccent,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "+$phoneCode $phoneNumber",
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 30,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.home_filled,
                    color: orangeAccent,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    place,
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  )
                ],
              ),
            ],
          ),
          Wrap(
            spacing: 10,
            children: [
              InkWell(
                onTap: () {
                  widget.user!.isEdit = true;
                  showDialog(
                    context: context,
                    builder: (context) => AddUserAdminDialog(
                      userAdmin: widget.user,
                    ),
                  ).then((value) {
                    widget.resetState!();
                  });
                },
                child: const Icon(
                  Icons.edit,
                  color: orangeAccent,
                ),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const ConfirmDialogBlack(
                      title: 'Confirmation',
                      contentText: 'Are you sure want delete this user?',
                    ),
                  ).then((value) {
                    if (value) {
                      apiReq.deleteUserAdmin(widget.user!.nip).then((result) {
                        if (result['Status'].toString() == "200") {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialogBlack(
                              title: result['Title'],
                              contentText: result['Message'],
                            ),
                          ).then((value) {
                            // Navigator.of(context).pop();
                            widget.resetState!();
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
                              title: result['Title'],
                              contentText: result['Message'],
                              isSuccess: false,
                            ),
                          );
                        }
                      }).onError((error, stackTrace) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialogBlack(
                            title: "Error deleteUserAdmin",
                            contentText: error.toString(),
                            isSuccess: false,
                          ),
                        );
                      });
                    }
                  });
                },
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: orangeAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserAdmin {
  UserAdmin({
    this.username = "",
    this.name = "",
    this.nip = "",
    this.role = "",
    this.place = "",
    this.phoneCode = "",
    this.phoneNumber = "",
    this.email = "",
    this.isCollapse = false,
    this.buildingId = "",
    this.isEdit = false,
    List? roleList,
  }) : roleList = roleList ?? [];
  String username;
  String name;
  String nip;
  String role;
  String place;
  String phoneCode;
  String phoneNumber;
  String buildingId;
  String email;
  List roleList;
  bool isCollapse;
  bool isEdit;

  Map<String, dynamic> toJson() => {
        '"UserName"': '"$username"',
        '"Name"': '"$name"',
        '"NIP"': '"$nip"',
        '"Role"': '"$role"',
        '"BuildingName"': '"$place"',
        '"BuildingID"': '"$buildingId"',
        '"PhoneCode"': '"$phoneCode"',
        '"PhoneNumber"': '"$phoneNumber"',
        '"Email"': '"$email"',
        '"RoleList"': '"$roleList"',
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
