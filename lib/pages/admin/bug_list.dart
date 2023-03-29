import 'dart:math';
import 'dart:html' as html;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/main_model.dart';
import 'package:meeting_room_booking_system/model/search_term.dart';
import 'package:meeting_room_booking_system/widgets/button/transparent_black_bordered_button.dart';
import 'package:meeting_room_booking_system/widgets/detail_picture.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/input_field/search_input_field.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:provider/provider.dart';

class BugListPage extends StatefulWidget {
  const BugListPage({super.key});

  @override
  State<BugListPage> createState() => _BugListPageState();
}

class _BugListPageState extends State<BugListPage> {
  MainModel mainModel = MainModel();
  ReqAPI apiReq = ReqAPI();
  ScrollController scrollController = ScrollController();
  TextEditingController _search = TextEditingController();
  FocusNode showPerRowsNode = FocusNode();

  SearchTerm searchTerm = SearchTerm(status: "ACTIVE");

  List<Bug> bugList = [];

  List typeList = [];

  bool isLoading = false;

  int currentPaginatedPage = 1;
  List availablePage = [1];
  List showedPage = [1];
  List showPerPageList = ["5", "10", "20", "50", "100"];
  int resultRows = 0;

  countPagination(int totalRow) {
    // print('total row -> $totalRow');
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
      // print(availablePage);
      // print(showedPage);
      showedPage = availablePage.take(5).toList();
    });
  }

  resetAll(bool value) {}

  resetState() {}

  onChangeStatus(String status) {
    searchTerm.status = status;
    updateList().then((value) {
      countPagination(resultRows);
      setState(() {});
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
      // print("SearchTerm ---> $searchTerm");
      // bugListInit().then((value) {
      //   setState(() {});
      // });
    });
  }

  Future updateList() {
    bugList.clear();
    initTabCount();
    isLoading = true;
    setState(() {});
    return apiReq.bugList(searchTerm).then((value) {
      isLoading = false;
      setState(() {});
      if (value['Status'].toString() == "200") {
        List listResult = value['Data']['List'];
        resultRows = value['Data']['TotalRows'];
        for (var element in listResult) {
          bugList.add(
            Bug(
              idBug: element['ReportID'],
              description: element['Description'],
              empNIP: element['EmpNIP'],
              empName: element['EmpName'],
              createdAt: element['Created_At'],
              photo: element['Photo'],
              isSolved: element['Status'] == "RESOLVED" ? true : false,
            ),
          );
        }
        setState(() {});
      } else if (value['Status'].toString() == "401") {
        showDialog(
          context: context,
          builder: (context) => TokenExpiredDialog(
            title: value['Title'],
            contentText: value['Message'],
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
          title: 'Error getBugList',
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  onClickBugItem(int index) {
    // feedbackItem.where((element) => element.index != index).forEach((element) {
    //   if (element.feedback!.expanded) {
    //     element.feedback!.expanded = false;
    //   }
    //   setState(() {});
    // });
    for (var element in bugList) {
      element.isExpanded = false;
    }
    if (!bugList[index].isExpanded) {
      // print('if false');
      bugList[index].isExpanded = true;
    } else if (bugList[index].isExpanded) {
      // print('if true');
      bugList[index].isExpanded = false;
    }
    setState(() {});
  }

  closeDetail(index) {
    setState(() {
      bugList[index].isExpanded = false;
    });
  }

  initTabCount() {
    apiReq.bugTabCount().then((value) {
      print(value);
      if (value['Status'] == "200") {
        setState(() {
          // mainModel.updateApprovalCountList(value['Data']);
          typeList = value['Data'];
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
          title: 'Failed connect API',
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    updateList().then((value) {
      countPagination(resultRows);
    });

    showPerRowsNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double paginationWidth = availablePage.length <= 5
        ? ((45 * (showedPage.length.toDouble())))
        : ((55 * (showedPage.length.toDouble())));
    return LayoutPageWeb(
      scrollController: scrollController,
      index: 0,
      model: mainModel,
      setDatePickerStatus: resetAll,
      resetState: resetState,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 1100,
          maxWidth: 1100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              'Bug Report List',
              style: helveticaText.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: eerieBlack,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            FilterSearchBarReportList(
              index: 0,
              searchController: _search,
              statusApproval: "ACTIVE",
              getRoomStatus: onChangeStatus,
              typeList: typeList,
              tabCount: initTabCount,
            ),
            const SizedBox(
              height: 30,
            ),
            //HEADER
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      onTapHeader("BugID");
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'ID',
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
                  flex: 3,
                  child: InkWell(
                    onTap: () {
                      onTapHeader("Description");
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Description',
                            style: helveticaText.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: davysGray,
                            ),
                          ),
                        ),
                        iconSort("Rating"),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      onTapHeader("Created_At");
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Submitted',
                            style: helveticaText.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: davysGray,
                            ),
                          ),
                        ),
                        iconSort("Created_At"),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 150,
                ),
              ],
            ),
            //HEADER ENDa
            const SizedBox(
              height: 12,
            ),
            const Divider(
              color: spanishGray,
              thickness: 1,
            ),
            const SizedBox(
              height: 12,
            ),
            isLoading
                ? const SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: eerieBlack,
                      ),
                    ),
                  )
                : bugList.isEmpty
                    ? Center(
                        child: SizedBox(
                          width: 900,
                          height: 200,
                          child: Center(
                            child: Text(
                              'Sorry, there are no rating at the moment.',
                              style: helveticaText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                color: davysGray,
                              ),
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: bugList.length,
                        itemBuilder: (context, index) => BugContainerList(
                          bug: bugList[index],
                          index: index,
                          close: closeDetail,
                          onClick: onClickBugItem,
                          updateList: updateList,
                        ),
                      ),
            const SizedBox(
              height: 60,
            ),
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
                              updateList().then((value) {
                                countPagination(resultRows);
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
                                  currentPaginatedPage =
                                      currentPaginatedPage - 1;
                                  if (availablePage.length > 5 &&
                                      currentPaginatedPage == showedPage[0] &&
                                      currentPaginatedPage != 1) {
                                    showedPage.removeLast();
                                    showedPage.insert(
                                        0, currentPaginatedPage - 1);
                                  }
                                  searchTerm.pageNumber =
                                      currentPaginatedPage.toString();
                                  updateList().then((value) {});
                                });
                              }
                            : null,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Icon(
                            Icons.chevron_left_sharp,
                          ),
                        ),
                      ),
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
                                    onTap: currentPaginatedPage ==
                                            showedPage[index]
                                        ? null
                                        : () {
                                            setState(() {
                                              currentPaginatedPage =
                                                  showedPage[index];
                                              if (availablePage.length > 5 &&
                                                  index ==
                                                      showedPage.length - 1) {
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
                                                showedPage.insert(0,
                                                    currentPaginatedPage - 1);
                                              }
                                            });
                                            searchTerm.pageNumber =
                                                currentPaginatedPage.toString();
                                            updateList().then((value) {});
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
                                  currentPaginatedPage =
                                      currentPaginatedPage + 1;
                                  if (currentPaginatedPage == showedPage.last &&
                                      currentPaginatedPage !=
                                          availablePage.last) {
                                    showedPage.removeAt(0);
                                    showedPage.add(currentPaginatedPage + 1);
                                  }
                                  searchTerm.pageNumber =
                                      currentPaginatedPage.toString();
                                  updateList().then((value) {});
                                });
                              }
                            : null,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
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
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
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

class BugContainerList extends StatefulWidget {
  BugContainerList({
    super.key,
    Bug? bug,
    this.index = 0,
    this.onClick,
    this.close,
    this.expanded = false,
    this.updateList,
  }) : bug = bug ?? Bug();

  Bug? bug;
  int index;
  Function? onClick;
  Function? close;
  bool expanded;
  Function? updateList;

  @override
  State<BugContainerList> createState() => _BugContainerListState();
}

class _BugContainerListState extends State<BugContainerList> {
  TransparentButtonBugList? solvedButton = TransparentButtonBugList();
  ReqAPI apiReq = ReqAPI();
  @override
  Widget build(BuildContext context) {
    solvedButton = TransparentButtonBugList(
      text: 'Solved',
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 32,
      ),
      fontSize: 14,
      disabled: false,
      onTap: () {
        apiReq.solveBug(widget.bug!.idBug).then((value) {
          if (value['Status'].toString() == "200") {
            showDialog(
              context: context,
              builder: (context) => AlertDialogBlack(
                title: value['Title'],
                contentText: value['Message'],
                isSuccess: true,
              ),
            ).then((value) {
              widget.updateList!();
            });
          } else if (value['Status'].toString() == "401") {
            showDialog(
              context: context,
              builder: (context) => TokenExpiredDialog(
                title: value['Title'],
                contentText: value['Message'],
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
              title: "Error solveReport",
              contentText: error.toString(),
              isSuccess: false,
            ),
          );
        });
      },
    );

    return Column(
      children: [
        widget.index == 0
            ? const SizedBox()
            : const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 18,
                ),
                child: Divider(
                  color: grayx11,
                  thickness: 0.5,
                ),
              ),
        InkWell(
          splashFactory: NoSplash.splashFactory,
          hoverColor: Colors.transparent,
          onTap: () {
            if (widget.bug!.isExpanded) {
              widget.close!(widget.index);
            } else {
              widget.onClick!(widget.index);
            }
          },
          child: !widget.bug!.isExpanded
              ? Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        widget.bug!.idBug,
                        style: helveticaText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: davysGray,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 50,
                        ),
                        child: Text(
                          widget.bug!.description,
                          style: helveticaText.copyWith(
                            fontSize: 16,
                            color: davysGray,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        widget.bug!.createdAt,
                        style: helveticaText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: davysGray,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.bug!.isSolved
                              ? Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  runAlignment: WrapAlignment.end,
                                  spacing: 10,
                                  children: [
                                    const ImageIcon(
                                      AssetImage(
                                        'assets/icons/check_icon.png',
                                      ),
                                      color: greenAcent,
                                    ),
                                    Text(
                                      'Solved',
                                      style: helveticaText.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: davysGray,
                                      ),
                                    )
                                  ],
                                )
                              : solvedButton!,
                          // const SizedBox(width: 30,)
                          const Icon(Icons.keyboard_arrow_right_sharp),
                        ],
                      ),
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.bug!.idBug,
                          style: helveticaText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: davysGray,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_sharp),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.bug!.description,
                            style: helveticaText.copyWith(
                              fontSize: 16,
                              color: davysGray,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    widget.bug!.photo!.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 20,
                              children: widget.bug!.photo!
                                  .map(
                                    (e) => SizedBox(
                                      height: 150,
                                      width: 200,
                                      child: CachedNetworkImage(
                                        imageUrl: e['ImageURL'],
                                        alignment: Alignment.centerLeft,
                                        imageBuilder: (context, imageProvider) {
                                          return InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    PictureDetail(
                                                  urlImage: e['ImageURL'],
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 150,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  7.5,
                                                ),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                        : SizedBox(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Submitted: ${widget.bug!.empNIP} - ${widget.bug!.empName} / ${widget.bug!.createdAt}",
                          style: helveticaText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: sonicSilver,
                          ),
                        ),
                        widget.bug!.isSolved
                            ? Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                runAlignment: WrapAlignment.end,
                                spacing: 10,
                                children: [
                                  const ImageIcon(
                                    AssetImage(
                                      'assets/icons/check_icon.png',
                                    ),
                                    color: greenAcent,
                                  ),
                                  Text(
                                    'Solved',
                                    style: helveticaText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      color: davysGray,
                                    ),
                                  )
                                ],
                              )
                            : solvedButton!,
                      ],
                    )
                  ],
                ),
        ),
      ],
    );
  }
}

class Bug {
  Bug({
    this.idBug = "",
    this.description = "",
    this.createdAt = "",
    this.isExpanded = false,
    this.isSolved = false,
    this.empNIP = "",
    this.empName = "",
    this.developerNIP = "",
    this.developerName = "",
    List? photo,
  }) : photo = photo ?? [];
  String idBug;
  String description;
  String createdAt;
  String empNIP;
  String empName;
  String developerNIP;
  String developerName;
  List? photo;
  bool isExpanded;
  bool isSolved;
}

class FilterSearchBarReportList extends StatefulWidget {
  FilterSearchBarReportList({
    super.key,
    this.index,
    this.statusApproval,
    this.getRoomStatus,
    this.search,
    this.searchController,
    List? typeList,
    this.tabCount,
    // this.filterList,
    // this.updateFilter,
    // this.mainModel,
  }) : typeList = typeList ?? [];

  int? index;
  String? statusApproval;
  Function? getRoomStatus;
  Function? search;
  TextEditingController? searchController;
  List? filterList;
  List typeList;
  Function? tabCount;
  MainModel? mainModel;

  @override
  State<FilterSearchBarReportList> createState() =>
      _FilterSearchBarReportListState();
}

class _FilterSearchBarReportListState extends State<FilterSearchBarReportList> {
  ReqAPI apiReq = ReqAPI();
  MainModel mainModel = MainModel();
  int? index;
  bool _hovering = false;
  bool onSelected = false;
  FocusNode searchNode = FocusNode();
  String? statusApproval;

  List? typeList = [];

  TextEditingController? _search = TextEditingController();

  List<Color> color = [blueAccent, greenAcent, orangeAccent, violetAccent];
  late int indexColor;
  late Color selectedColor = blueAccent;
  final _random = Random();

  Future initMainModel() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mainModel = Provider.of<MainModel>(context, listen: false);
    });
  }

  @override
  void initState() {
    super.initState();
    initMainModel().then((_) {
      index = widget.index;
      statusApproval = widget.statusApproval;
      indexColor = _random.nextInt(color.length);
      selectedColor = color[indexColor];

      widget.tabCount;
      setState(() {});
      // apiReq.bugTabCount().then((value) {
      //   print(value);
      //   if (value['Status'] == "200") {
      //     setState(() {
      //       // mainModel.updateApprovalCountList(value['Data']);
      //       typeList = value['Data'];
      //     });
      //   } else if (value['Status'].toString() == "401") {
      //     showDialog(
      //       context: context,
      //       builder: (context) => TokenExpiredDialog(
      //         title: value['Title'],
      //         contentText: value['Message'],
      //         isSuccess: false,
      //       ),
      //     );
      //   } else {
      //     showDialog(
      //       context: context,
      //       builder: (context) => AlertDialogBlack(
      //         title: value['Title'],
      //         contentText: value['Message'],
      //         isSuccess: false,
      //       ),
      //     );
      //   }
      // }).onError((error, stackTrace) {
      //   showDialog(
      //     context: context,
      //     builder: (context) => AlertDialogBlack(
      //       title: 'Failed connect API',
      //       contentText: error.toString(),
      //       isSuccess: false,
      //     ),
      //   );
      // });
    });
  }

  void onHighlight(String type) {
    switch (type) {
      case "ACTIVE":
        changeHighlight(0, type);
        widget.getRoomStatus!(type);
        break;
      case "RESOLVED":
        changeHighlight(1, type);
        widget.getRoomStatus!(type);
        break;
    }
  }

  void changeHighlight(int newIndex, String status) {
    setState(() {
      index = newIndex;
      statusApproval = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.pink,
      padding: EdgeInsets.zero,
      height: 61,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 60,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: grayx11,
                  width: 0.5,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            // bottom: 0,
            // left: 0,
            child: Container(
              // color: Colors.amber,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // width: 500,
                    child: Row(
                      children: widget.typeList.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            right: 50,
                          ),
                          child: FilterSearchBarReportListItem(
                            title: e['Status'],
                            type: e['Status'],
                            bookingCount: e['Total'].toString(),
                            onHighlight: onHighlight,
                            color: selectedColor,
                            selected: statusApproval == e['Status'],
                          ),
                        );
                      }).toList(),
                      // children: [
                      //   FilterSearchBarReportListItem(
                      //     title: 'Request',
                      //     type: 'Request',
                      //     onHighlight: onHighlight,
                      //     selected: index == 0,
                      //     color: selectedColor,
                      //   ),
                      //   const SizedBox(
                      //     width: 50,
                      //   ),
                      //   FilterSearchBarReportListItem(
                      //     title: 'Approved',
                      //     type: 'Approved',
                      //     onHighlight: onHighlight,
                      //     selected: index == 1,
                      //     color: selectedColor,
                      //   ),
                      //   const SizedBox(
                      //     width: 50,
                      //   ),
                      //   FilterSearchBarReportListItem(
                      //     title: 'Declined',
                      //     type: 'Declined',
                      //     onHighlight: onHighlight,
                      //     selected: index == 2,
                      //     color: selectedColor,
                      //   ),
                      // ],
                    ),
                  ),
                  Container(
                    width: 200,
                    // color: Colors.green,
                    // child: Text('haha'),
                    child: SearchInputField(
                      controller: widget.searchController!,
                      obsecureText: false,
                      enabled: true,
                      maxLines: 1,
                      focusNode: searchNode,
                      hintText: 'Search',
                      onFieldSubmitted: (value) => widget.search!(),
                      prefixIcon: const ImageIcon(
                        AssetImage('assets/icons/search_icon.png'),
                      ),
                    ),
                  )
                  // Expanded(
                  //   child: Container(
                  //     //   child: WhiteInputField(
                  //     //     controller: _search!,
                  //     //     enabled: true,
                  //     //     obsecureText: false,
                  //     //   ),
                  //     child: Text('haha'),
                  //   ),
                  // ),

                  // BlackInputField(
                  //   controller: _search!,
                  //   enabled: true,
                  //   obsecureText: false,
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterSearchBarReportListItem extends StatelessWidget {
  const FilterSearchBarReportListItem({
    super.key,
    this.title,
    this.type,
    this.selected,
    this.onHighlight,
    this.color,
    this.bookingCount,
  });

  final String? title;
  final String? type;
  final bool? selected;
  final Function? onHighlight;
  final Color? color;
  final String? bookingCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onHighlight!(type);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
        child: FilterSearchBarReportListInteractiveItem(
          text: title,
          selected: selected,
          type: type,
          color: color!,
          bookingCount: bookingCount,
        ),
      ),
    );
  }
}

class FilterSearchBarReportListInteractiveItem extends MouseRegion {
  static final appContainer =
      html.window.document.querySelectorAll('flt-glass-pane')[0];

  // bool selected;

  FilterSearchBarReportListInteractiveItem({
    Widget? child,
    String? text,
    bool? selected,
    String? type,
    Color? color,
    String? bookingCount,
  }) : super(
          onHover: (PointerHoverEvent evt) {
            appContainer.style.cursor = 'pointer';
          },
          onExit: (PointerExitEvent evt) {
            appContainer.style.cursor = 'default';
          },
          child: FilterSearchBarReportListInteractiveText(
            text: text!,
            selected: selected!,
            color: color!,
            bookingCount: bookingCount,
          ),
        );
}

class FilterSearchBarReportListInteractiveText extends StatefulWidget {
  final String? text;
  final bool? selected;
  final Color color;
  String? bookingCount;

  FilterSearchBarReportListInteractiveText(
      {@required this.text,
      this.selected,
      this.color = blueAccent,
      this.bookingCount});

  @override
  FilterSearchBarReportListInteractiveTextState createState() =>
      FilterSearchBarReportListInteractiveTextState();
}

class FilterSearchBarReportListInteractiveTextState
    extends State<FilterSearchBarReportListInteractiveText> {
  bool _hovering = false;
  bool onSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => _hovered(true),
      onExit: (_) => _hovered(false),
      child: Container(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide.none,
                right: BorderSide.none,
                top: BorderSide.none,
                bottom: _hovering
                    ? BorderSide(
                        color: widget.color,
                        width: 3,
                        style: BorderStyle.solid,
                      )
                    : (widget.selected!)
                        ? BorderSide(
                            color: widget.color,
                            width: 3,
                            style: BorderStyle.solid,
                          )
                        : BorderSide.none,
              ),
            ),
            child: Wrap(
              children: [
                Text(
                  widget.text!,
                  style: _hovering
                      ? filterSearchBarText.copyWith(
                          color: widget.color, //eerieBlack,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                        )
                      : (widget.selected!)
                          ? filterSearchBarText.copyWith(
                              color: widget.color,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            )
                          : filterSearchBarText.copyWith(
                              color: davysGray,
                              fontWeight: FontWeight.w300,
                              height: 1.3,
                            ),
                ),
                const SizedBox(
                  width: 10,
                ),
                widget.bookingCount == "0"
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: sonicSilver,
                          ),
                          child: Text(
                            widget.bookingCount!,
                            style: helveticaText.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: culturedWhite,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _hovered(bool hovered) {
    setState(() {
      _hovering = hovered;
    });
  }
}
