import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/widgets/banner/black_banner.dart';
import 'package:meeting_room_booking_system/widgets/banner/landscape_black_banner.dart';
import 'package:meeting_room_booking_system/widgets/banner/landscape_white_banner.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:meeting_room_booking_system/widgets/my_book_page/filter_search_bar.dart';
import 'package:meeting_room_booking_system/widgets/my_book_page/my_book_list.dart';
import 'package:meeting_room_booking_system/widgets/navigation_bar/navigation_bar.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'dart:html' as html;

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({Key? key}) : super(key: key);

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  ReqAPI apiReq = ReqAPI();
  setDatePickerStatus(bool value) {}

  TextEditingController _search = TextEditingController();

  double listLengthExample = 58;
  double rowPerPage = 10;
  double firstPaginated = 0;
  int currentPaginatedPage = 1;
  List availablePage = [1];
  List showedPage = [1];

  String roomType = "MeetingRoom";

  MyListBody searchTerm = MyListBody();

  FocusNode showPerRowsNode = FocusNode();

  // final Uri url = Uri.parse('https://flutter.dev');

  // Future<void> _launchUrl() async {
  //   if (!await launchUrl(url)) {
  //     throw 'Could not launch $url';
  //   }
  // }
  late MyBookTableSource sourceData;

  // List<MyBook> myBookList = <MyBook>[];
  List myBookList = [];
  List showPerPageList = ["5", "10", "20", "50", "100"];

  bool sort = true;
  List? filterData = [
    {'01', 'Event 1', 'date', 'location', 'time', 'status'},
    {'02', 'Event 1', 'date', 'location', 'time', 'status'},
    {'03', 'Event 1', 'date', 'location', 'time', 'status'},
    {'04', 'Event 1', 'date', 'location', 'time', 'status'},
    {'05', 'Event 1', 'date', 'location', 'time', 'status'},
    {'06', 'Event 1', 'date', 'location', 'time', 'status'},
    {'07', 'Event 1', 'date', 'location', 'time', 'status'},
    {'08', 'Event 1', 'date', 'location', 'time', 'status'},
    {'09', 'Event 1', 'date', 'location', 'time', 'status'},
    {'10', 'Event 1', 'date', 'location', 'time', 'status'},
    {'11', 'Event 1', 'date', 'location', 'time', 'status'},
    {'12', 'Event 1', 'date', 'location', 'time', 'status'},
  ];

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
    });
  }

  updateList() {
    apiReq.getMyBookingList(searchTerm).then((value) {
      // print(value);
      setState(() {
        if (value['Status'] == "200") {
          myBookList = value['Data']['List'];

          countPagination(value['Data']['TotalRows']);
          showedPage = availablePage.take(5).toList();
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
      });
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
    // myBookList = getMyBookList();

    // sourceData = MyBookTableSource(myBook: myBookList);
    updateList();
  }

  roomTypeChanged(String value) {
    setState(() {
      currentPaginatedPage = 1;
      searchTerm.pageNumber = currentPaginatedPage.toString();
      searchTerm.roomType = value;
      roomType = value;
      // apiReq.getMyBookingList(searchTerm).then((value) {
      //   myBookList = value['Data']['List'];
      //   countPagination(value['Data']['TotalRows']);
      //   showedPage = availablePage.take(5).toList();
      // });
      updateList();
      // print(searchTerm.roomType);
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
      // apiReq.getMyBookingList(searchTerm).then((value) {
      //   setState(() {
      //     myBookList = value['Data']['List'];
      //     countPagination(value['Data']['TotalRows']);
      //   });
      // });
      updateList();
    });
    // print("Order By ${searchTerm.orderBy} ${searchTerm.orderDir}");
  }

  searchMyBook() {
    setState(() {
      currentPaginatedPage = 1;
      searchTerm.keyWords = _search.text;
      searchTerm.pageNumber = currentPaginatedPage.toString();
      // apiReq.getMyBookingList(searchTerm).then((value) {
      //   print(value);
      //   myBookList = value['Data']['List'];
      //   countPagination(value['Data']['TotalRows']);
      //   showedPage = availablePage.take(5).toList();
      // });
      updateList();
    });
  }

  ScrollController scrollController = ScrollController();

  resetState() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(() {});
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double paginationWidth = availablePage.length <= 5
        ? ((45 * (showedPage.length.toDouble())))
        : ((55 * (showedPage.length.toDouble())));
    return LayoutPageWeb(
      index: 3,
      scrollController: scrollController,
      setDatePickerStatus: setDatePickerStatus,
      resetState: resetState,
      child: ConstrainedBox(
        constraints: pageConstraints,
        child: Container(
          // color: Colors.grey,
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
                  'My Event List',
                  style: helveticaText.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                FilterSearchBar(
                  index: 0,
                  roomType: roomType,
                  getRoomType: roomTypeChanged,
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
                    SizedBox(
                      width: 125,
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
                    SizedBox(
                      width: 225,
                      child: InkWell(
                        onTap: () {
                          onTapHeader("Status");
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Status',
                                style: helveticaText.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: davysGray,
                                ),
                              ),
                            ),
                            iconSort("Status"),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
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
                myBookList.isEmpty
                    ? Container(
                        height: 200,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'No Booking Available',
                            style: helveticaText.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: davysGray,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: myBookList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return MyBookListContainer(
                            index: index,
                            eventName: myBookList[index]['Summary'],
                            date: myBookList[index]['BookingDate'],
                            location: myBookList[index]['RoomName'],
                            time: myBookList[index]['BookingTime'],
                            status: myBookList[index]['Status'],
                            bookingId: myBookList[index]['BookingID'],
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
                                  updateList();
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
                                          currentPaginatedPage ==
                                              showedPage[0] &&
                                          currentPaginatedPage != 1) {
                                        showedPage.removeLast();
                                        showedPage.insert(
                                            0, currentPaginatedPage - 1);
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
                                      updateList();
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
                                                  if (availablePage.length >
                                                          5 &&
                                                      index ==
                                                          showedPage.length -
                                                              1) {
                                                    if (currentPaginatedPage !=
                                                        availablePage.last) {
                                                      showedPage.removeAt(0);
                                                      showedPage.add(
                                                          currentPaginatedPage +
                                                              1);
                                                    }
                                                  }
                                                  if (availablePage.length >
                                                          5 &&
                                                      index == 0 &&
                                                      currentPaginatedPage !=
                                                          1) {
                                                    showedPage.removeLast();
                                                    showedPage.insert(
                                                        0,
                                                        currentPaginatedPage -
                                                            1);
                                                  }
                                                });
                                                searchTerm.pageNumber =
                                                    currentPaginatedPage
                                                        .toString();
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
                                        showedPage
                                            .add(currentPaginatedPage + 1);
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
                                      updateList();
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

                // SfDataGrid(
                //   rowsPerPage: 5,
                //   columnWidthMode: ColumnWidthMode.auto,
                //   source: sourceData,
                //   columns: [
                //     GridColumn(
                //       minimumWidth: 300,
                //       columnName: 'event',
                //       label: Text('Event'),
                //     ),
                //     GridColumn(
                //       columnName: 'date',
                //       label: Text('Date'),
                //     ),
                //     GridColumn(
                //       columnName: 'location',
                //       label: Text('Location'),
                //     ),
                //     GridColumn(
                //       columnName: 'time',
                //       label: Text('Time'),
                //     ),
                //     GridColumn(
                //       columnName: 'status',
                //       label: Text('Status'),
                //     ),
                //     GridColumn(
                //       columnName: 'action',
                //       label: Text(''),
                //     ),
                //   ],
                // ),
                // BlackBanner(
                //   title: 'Link your Google account',
                //   subtitle: '& enjoy your benefits.',
                //   imagePath: 'assets/banner_pict_google.png',
                // ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: PaginatedDataTable(
                //         rowsPerPage: 5,
                //         showFirstLastButtons: true,
                //         availableRowsPerPage: const [
                //           5,
                //           10,
                //           50,
                //         ],
                //         columns: [
                //           DataColumn(
                //             label: Text('Event'),
                //           ),
                //           DataColumn(
                //             label: Text('Date'),
                //           ),
                //           DataColumn(
                //             label: Text('Location'),
                //           ),
                //           DataColumn(
                //             label: Text('Time'),
                //           ),
                //           DataColumn(
                //             label: Text('Status'),
                //           ),
                //           DataColumn(
                //             label: Text('Action'),
                //           ),
                //         ],
                //         source: MyBookTableSource(
                //           myData: filterData,
                //           count: filterData!.length,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(
                  height: 20,
                ),
                // BlackBannerLandscape(
                //   title: 'Link your Google account',
                //   subtitle: '& enjoy your benefits.',
                //   imagePath: 'assets/banner_pict_google.png',
                // ),
                // SizedBox(
                //   height: 20,
                // ),
                // WhiteBannerLandscape(
                //   title: 'Link your Google account',
                //   subtitle: '& enjoy your benefits.',
                //   imagePath: 'assets/banner_pict_google.png',
                // ),
                // SizedBox(
                //   height: 40,
                // ),
                // RegularButton(
                //   text: 'Open Window',
                //   disabled: false,
                //   onTap: () async {
                //     // html.window.open(
                //     //     'https://stackoverflow.com/questions/ask', 'new window');
                //     if (await launchUrl(url)) {
                //       await launchUrl(
                //         url,
                //         mode: LaunchMode.externalApplication,
                //         webOnlyWindowName: '_blank',
                //       );
                //     } else {
                //       throw 'Could not launch $url';
                //     }
                //   },
                // )
              ],
            ),
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

  filterSearchSection() {
    return Container(
      child: Row(
        children: [],
      ),
    );
  }
}

class MyListBody {
  MyListBody({
    this.roomType = "MeetingRoom",
    this.keyWords = "",
    this.max = "5",
    this.pageNumber = "1",
    this.orderBy = "BookingDate",
    this.orderDir = "DESC",
  });

  String roomType;
  String keyWords;
  String max;
  String pageNumber;
  String orderBy;
  String orderDir;
}

class MyBook {
  MyBook(
    this.eventId,
    this.eventName,
    this.date,
    this.location,
    this.time,
    this.status,
  );

  String? eventId;
  String? eventName;
  String? date;
  String? location;
  String? time;
  String? status;
}

// class MyBookTableSource extends DataGridSource {
//   MyBookTableSource({
//     required List<MyBook> myBook,
//   }) {
//     dataGridRows = myBook
//         .map<DataGridRow>(
//           (e) => DataGridRow(
//             cells: [
//               DataGridCell(
//                 columnName: 'name',
//                 value: e.eventName,
//               ),
//               DataGridCell(
//                 columnName: 'date',
//                 value: e.date,
//               ),
//               DataGridCell(
//                 columnName: 'location',
//                 value: e.location,
//               ),
//               DataGridCell(
//                 columnName: 'time',
//                 value: e.time,
//               ),
//               DataGridCell(
//                 columnName: 'status',
//                 value: e.status,
//               ),
//               DataGridCell(
//                 columnName: 'action',
//                 value: Icon(
//                   Icons.chevron_right_sharp,
//                 ),
//               ),
//             ],
//           ),
//         )
//         .toList();
//   }

//   List<DataGridRow> dataGridRows = [];

//   @override
//   List<DataGridRow> get rows => dataGridRows;

//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((e) {
//       return Container(
//         child: Text(e.value.toString()),
//       );
//     }).toList());
//   }
// }

class MyBookTableSource extends DataTableSource {
  var myData;
  final count;
  MyBookTableSource({
    required this.myData,
    required this.count,
  });
  @override
  DataRow? getRow(int index) {
    // TODO: implement getRow
    if (index < rowCount) {
      return recentFileDataRow(myData![index]);
    } else
      return null;
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => count;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

  DataRow recentFileDataRow(var data) {
    return DataRow(
      cells: [
        DataCell(Text("Test")),
        DataCell(Text("test")),
        DataCell(Text("test")),
        DataCell(Text("Test")),
        DataCell(Text("test")),
        DataCell(Text("test")),
      ],
    );
  }
}
