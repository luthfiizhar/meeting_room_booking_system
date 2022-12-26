import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/approval_list_content_container.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/filter_search_bar_admin.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';

class AdminListPage extends StatefulWidget {
  const AdminListPage({super.key});

  @override
  State<AdminListPage> createState() => _AdminListPageState();
}

class _AdminListPageState extends State<AdminListPage> {
  ScrollController scrollController = ScrollController();
  TextEditingController _search = TextEditingController();
  String statusApproval = "Requested";
  ListApprovalBody searchTerm = ListApprovalBody();
  FocusNode showPerRowsNode = FocusNode();
  List approvalList = [];
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
    });
  }

  statusRoomChanged(String value) {
    setState(() {
      currentPaginatedPage = 1;
      searchTerm.pageNumber = currentPaginatedPage.toString();
      searchTerm.statusRoom = value;
      statusApproval = value;
      updateList();
      // getAuditoriumApprovalList(searchTerm).then((value) {
      //   myBookList = value['Data']['List'];
      //   countPagination(value['Data']['TotalRows']);
      //   showedPage = availablePage.take(5).toList();
      // });
      print(searchTerm.statusRoom);
    });
  }

  searchMyBook() {
    setState(() {
      currentPaginatedPage = 1;
      searchTerm.keyWords = _search.text;
      searchTerm.pageNumber = currentPaginatedPage.toString();
      updateList();
      // getMyBookingList(searchTerm).then((value) {
      //   print(value);
      //   myBookList = value['Data']['List'];
      //   countPagination(value['Data']['TotalRows']);
      //   showedPage = availablePage.take(5).toList();
      // });
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
      updateList();
      // getMyBookingList(searchTerm).then((value) {
      //   setState(() {
      //     myBookList = value['Data']['List'];
      //     countPagination(value['Data']['TotalRows']);
      //   });
      // });
    });
    print("Order By ${searchTerm.orderBy} ${searchTerm.orderDir}");
  }

  resetState() {
    setState(() {});
  }

  setDatePickerStatus(bool value) {}

  updateList() {
    getAuditoriumApprovalList(searchTerm).then((value) {
      setState(() {
        approvalList = value['Data']['List'];
        countPagination(value['Data']['TotalRows']);
        showedPage = availablePage.take(5).toList();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAuditoriumApprovalList(searchTerm).then((value) {
      approvalList = value['Data']['List'];
      countPagination(value['Data']['TotalRows']);
      showedPage = availablePage.take(5).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double paginationWidth = availablePage.length <= 5
        ? ((45 * (showedPage.length.toDouble())))
        : ((55 * (showedPage.length.toDouble())));
    return LayoutPageWeb(
      index: 0,
      setDatePickerStatus: setDatePickerStatus,
      resetState: resetState,
      scrollController: scrollController,
      child: ConstrainedBox(
        constraints: pageConstraints,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 35,
              ),
              Text(
                'Need Approval List',
                style: helveticaText.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              FilterSearchBarAdmin(
                index: 0,
                statusApproval: statusApproval,
                getRoomStatus: statusRoomChanged,
                search: searchMyBook,
                searchController: _search,
              ),
              const SizedBox(
                height: 30,
              ),
              //Header Table
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        onTapHeader("Summary");
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Event',
                              style: helveticaText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: davysGray,
                              ),
                            ),
                          ),
                          iconSort("Summary"),
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
                        onTapHeader("BookingDate");
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Date',
                              style: helveticaText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: davysGray,
                              ),
                            ),
                          ),
                          iconSort("BookingDate"),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        onTapHeader("RoomName");
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Location',
                              style: helveticaText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: davysGray,
                              ),
                            ),
                          ),
                          iconSort("RoomName"),
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
                        onTapHeader("BookingTime");
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Time',
                              style: helveticaText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: davysGray,
                              ),
                            ),
                          ),
                          iconSort("BookingTime"),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              const Divider(
                color: spanishGray,
                thickness: 1,
              ),
              //Content Table
              approvalList.isEmpty
                  ? Container(
                      height: 200,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'No Approval Needed',
                          style: helveticaText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: davysGray,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: approvalList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ApprovalListContainer(
                          index: index,
                          eventName: approvalList[index]['Summary'],
                          date: approvalList[index]['BookingDate'],
                          location: approvalList[index]['RoomName'],
                          time: approvalList[index]['BookingTime'],
                          status: approvalList[index]['Status'],
                          bookingId: approvalList[index]['BookingID'],
                        );
                      },
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
                                searchTerm.max = value!.toString();
                                updateList();
                                // getMyBookingList(searchTerm).then((value) {
                                //   myBookList = value['Data']['List'];
                                //   countPagination(value['Data']['TotalRows']);
                                //   showedPage = availablePage.take(5).toList();
                                // });
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
                                    updateList();
                                    // getMyBookingList(searchTerm)
                                    //     .then((value) {
                                    //   myBookList = value['Data']['List'];
                                    //   countPagination(
                                    //       value['Data']['TotalRows']);
                                    // });
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
                                                        currentPaginatedPage +
                                                            1);
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
                                                  currentPaginatedPage
                                                      .toString();
                                              updateList();
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
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                        currentPaginatedPage ==
                                            availablePage.last
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
                                    if (currentPaginatedPage ==
                                            showedPage.last &&
                                        currentPaginatedPage !=
                                            availablePage.last) {
                                      showedPage.removeAt(0);
                                      showedPage.add(currentPaginatedPage + 1);
                                    }
                                    searchTerm.pageNumber =
                                        currentPaginatedPage.toString();
                                    updateList();
                                    // getMyBookingList(searchTerm)
                                    //     .then((value) {
                                    //   myBookList = value['Data']['List'];
                                    //   countPagination(
                                    //       value['Data']['TotalRows']);
                                    // });
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
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconSort(String orderBy) {
    return SizedBox(
      width: 20,
      height: 25,
      // child: Stack(
      //   children: [
      //     Visibility(
      //       visible:
      //           searchTerm.orderBy == orderBy && searchTerm.orderDir == "DESC"
      //               ? false
      //               : true,
      //       child: const Positioned(
      //         top: 0,
      //         left: 0,
      //         child: Icon(
      //           Icons.keyboard_arrow_down_sharp,
      //           size: 16,
      //         ),
      //       ),
      //     ),
      //     Visibility(
      //       visible:
      //           searchTerm.orderBy == orderBy && searchTerm.orderDir == "ASC"
      //               ? false
      //               : true,
      //       child: const Positioned(
      //         bottom: 0,
      //         left: 0,
      //         child: Icon(
      //           Icons.keyboard_arrow_up_sharp,
      //           size: 16,
      //         ),
      //       ),
      //     )
      //   ],
      // ),
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

class ListApprovalBody {
  ListApprovalBody({
    this.statusRoom = "Requested",
    this.roomType = "Auditorium",
    this.keyWords = "",
    this.max = "5",
    this.pageNumber = "1",
    this.orderBy = "BookingDate",
    this.orderDir = "DESC",
  });

  String statusRoom;
  String roomType;
  String keyWords;
  String max;
  String pageNumber;
  String orderBy;
  String orderDir;
}
