import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/widgets/banner/black_banner.dart';
import 'package:meeting_room_booking_system/widgets/banner/landscape_black_banner.dart';
import 'package:meeting_room_booking_system/widgets/banner/landscape_white_banner.dart';
import 'package:meeting_room_booking_system/widgets/button/regular_button.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:meeting_room_booking_system/widgets/my_book_page/filter_search_bar.dart';
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
  setDatePickerStatus(bool value) {}

  double listLengthExample = 58;
  double rowPerPage = 10;
  double firstPaginated = 0;
  int currentPaginatedPage = 1;
  List availablePage = [];
  List showedPage = [];

  FocusNode showPerRowsNode = FocusNode();

  // final Uri url = Uri.parse('https://flutter.dev');

  // Future<void> _launchUrl() async {
  //   if (!await launchUrl(url)) {
  //     throw 'Could not launch $url';
  //   }
  // }
  late MyBookTableSource sourceData;

  List<MyBook> myBookList = <MyBook>[];

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

  countPagination() {
    var totalPage = listLengthExample / rowPerPage;
    print(totalPage.ceil());
    for (var i = 0; i < totalPage.ceil(); i++) {
      availablePage.add(i + 1);
    }

    // showedPage = availablePage
    //     .getRange(firstPaginated.toInt(), firstPaginated.toInt() + 1)
    //     .toList();
    showedPage = availablePage.take(5).toList();
    print(availablePage);
    print(showedPage);
    print(showedPage.last);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myBookList = getMyBookList();

    countPagination();
    // sourceData = MyBookTableSource(myBook: myBookList);
  }

  getMyBookList() {
    return [
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
      MyBook('01', 'Event 1', 'date', 'location', 'time', 'status'),
    ];
  }

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return LayoutPageWeb(
      index: 3,
      scrollController: scrollController,
      setDatePickerStatus: setDatePickerStatus,
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
                  height: 20,
                ),
                Text(
                  'My Booking List',
                  style: helveticaText.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                FilterSearchBar(
                  index: 0,
                ),
                const SizedBox(
                  height: 30,
                ),
                //Header Table
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Event',
                        style: helveticaText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: davysGray,
                        ),
                      ),
                    ),
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
                ListView.builder(
                  itemCount: 2,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        index != 0
                            ? const Divider(
                                color: grayx11,
                                thickness: 0.5,
                              )
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 17,
                            bottom: 17,
                          ),
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Ruang Kerja Marketing KWI (+ Intern)',
                                    style: helveticaText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: davysGray,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '5 November 2022',
                                    style: helveticaText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: davysGray,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '103',
                                    style: helveticaText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: davysGray,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '09:00 - 10:00',
                                    style: helveticaText.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: davysGray,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Wrap(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Checked in',
                                        style: helveticaText.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: davysGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                  child: Icon(
                                    Icons.chevron_right_sharp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                              onChanged: (value) {},
                              value: 100,
                              items: const [
                                DropdownMenuItem(
                                  child: Text('10'),
                                  value: 10,
                                ),
                                DropdownMenuItem(
                                  child: Text('50'),
                                  value: 50,
                                ),
                                DropdownMenuItem(
                                  child: Text('100'),
                                  value: 100,
                                ),
                              ],
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
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: grayx11,
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.chevron_left_sharp,
                            ),
                          ),
                          // const SizedBox(
                          //   width: 10,
                          // ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 270,
                            height: 35,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: showedPage.length + 1,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 13,
                                      vertical: 8.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: index + 1 == currentPaginatedPage
                                          ? eerieBlack
                                          : greenAcent,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: index == showedPage.length
                                        ? Text(
                                            '...',
                                            style: helveticaText.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              height: 1.2,
                                              color: davysGray,
                                            ),
                                          )
                                        : Text(
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
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: grayx11,
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.chevron_right_sharp,
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

  filterSearchSection() {
    return Container(
      child: Row(
        children: [],
      ),
    );
  }
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
