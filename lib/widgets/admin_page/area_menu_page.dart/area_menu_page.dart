import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/model/search_term.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';

class AreaMenuPage extends StatefulWidget {
  const AreaMenuPage({super.key});

  @override
  State<AreaMenuPage> createState() => _AreaMenuPageState();
}

class _AreaMenuPageState extends State<AreaMenuPage> {
  TextEditingController _search = TextEditingController();
  FocusNode searchNode = FocusNode();
  FocusNode showPerRowsNode = FocusNode();

  SearchTerm searchTerm = SearchTerm();

  int selectedIndexArea = 0;

  List areaList = [
    {'isCollapsed': false},
    {'isCollapsed': false}
  ];

  List showPerPageList = ["5", "10", "20", "50", "100"];

  int currentPaginatedPage = 1;
  List availablePage = [1, 2, 3, 4, 5];
  List showedPage = [1, 2, 3, 4, 5];

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

  onTapHeader(String orderBy) {}

  closeDetail(index) {
    setState(() {
      areaList[index]['isCollapsed'] = false;
    });
  }

  onTapListArea(int index) {
    setState(() {
      // closeDetail();
      for (var element in areaList) {
        element['isCollapsed'] = false;
      }
      if (areaList[index]['isCollapsed'] == true) {
        areaList[index]['isCollapsed'] = false;
      }
      if (areaList[index]['isCollapsed'] == false) {
        areaList[index]['isCollapsed'] = true;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(
              'Area List',
              style: helveticaText.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: davysGray,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // showDialog(
              //   context: context,
              //   builder: (context) => AddNewFloorDialog(),
              // );
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
                    'Add Area',
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
            child: BlackInputField(
              controller: _search,
              enabled: true,
              obsecureText: false,
              prefixIcon: Icon(Icons.search),
              hintText: 'Search here',
              focusNode: searchNode,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      ListView.builder(
        itemCount: areaList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return AreaListContainer(
            index: index,
            isCollapse: areaList[index]['isCollapsed'],
            onTap: onTapListArea,
            close: closeDetail,
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
                            currentPaginatedPage = currentPaginatedPage - 1;
                            if (availablePage.length > 5 &&
                                currentPaginatedPage == showedPage[0] &&
                                currentPaginatedPage != 1) {
                              showedPage.removeLast();
                              showedPage.insert(0, currentPaginatedPage - 1);
                            }
                            searchTerm.pageNumber =
                                currentPaginatedPage.toString();

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
                  width: 275,
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
                                            showedPage
                                                .add(currentPaginatedPage + 1);
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
                                      // getMyBookingList(searchTerm)
                                      //     .then((value) {
                                      //   setState(() {
                                      //     myBookList =
                                      //         value['Data']['List'];
                                      //     countPagination(
                                      //         value['Data']
                                      //             ['TotalRows']);
                                      //   });
                                      // });
                                      print(showedPage);
                                      print('current ${searchTerm.pageNumber}');
                                    },
                              child: Container(
                                width: 35,
                                height: 35,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 8.5,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      showedPage[index] == currentPaginatedPage
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
                      const SizedBox(
                        width: 5,
                      ),
                      Visibility(
                        visible: availablePage.length < 5 ||
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
                const SizedBox(
                  width: 5,
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
    ]);
  }
}

class AreaListContainer extends StatefulWidget {
  AreaListContainer({
    super.key,
    this.roomName = "",
    this.roomType = "",
    this.building = "",
    this.floor = "",
    this.capacity = "",
    this.onTap,
    this.isCollapse = false,
    this.index,
    this.close,
  });

  String roomName;
  String roomType;
  String floor;
  String building;
  String capacity;
  Function? onTap;
  Function? close;
  bool isCollapse;
  int? index;

  @override
  State<AreaListContainer> createState() => _AreaListContainerState();
}

class _AreaListContainerState extends State<AreaListContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.index != 0
            ? const Divider(
                color: grayx11,
                thickness: 0.5,
              )
            : const SizedBox(),
        InkWell(
          onTap: () {
            if (widget.isCollapse) {
              widget.close!(widget.index);
            } else {
              widget.onTap!(widget.index!);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 15,
            ),
            child: summary(),
          ),
        ),
        Visibility(
          visible: widget.isCollapse ? true : false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ),
            child: detail(),
          ),
        ),
      ],
    );
  }

  Widget summary() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: blueAccent,
                radius: 35,
              ),
              const SizedBox(
                width: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '401',
                    style: helveticaText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: davysGray,
                    ),
                  ),
                  Text(
                    'Meeting Room',
                    style: helveticaText.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.home,
                color: orangeAccent,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                '4th Floor, Head Office',
                style: helveticaText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: davysGray,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.people,
                color: orangeAccent,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                '2-6',
                style: helveticaText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: davysGray,
                ),
              )
            ],
          ),
          widget.isCollapse
              ? const Icon(Icons.keyboard_arrow_down_sharp)
              : const Icon(
                  Icons.keyboard_arrow_right_sharp,
                )
        ],
      ),
    );
  }

  Widget detail() {
    return Row(
      children: [
        Container(
          height: 190,
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: davysGray,
          ),
        ),
        const SizedBox(
          width: 40,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailInfo('Room Name: ', '401'),
                    detailInfo('Building: ', 'Head Office'),
                    detailInfo('Floor: ', '2nd'),
                    detailInfo('Type: ', 'Meeting Room'),
                  ],
                ),
                const SizedBox(
                  width: 100,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailInfo('Min Capacity: ', '2'),
                    detailInfo('Max Capacity: ', '6'),
                    detailInfo('Max Book Duration: ', '5 Hour'),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Facilities',
              style: helveticaText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: davysGray,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ],
    );
  }

  Widget detailInfo(String label, String info) {
    final TextStyle labelText = helveticaText.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w300,
      color: davysGray,
      height: 1.3,
    );
    final TextStyle contentText = helveticaText.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: davysGray,
      height: 1.3,
    );
    return RichText(
      text: TextSpan(
        text: label,
        style: labelText,
        children: [
          TextSpan(text: info, style: contentText),
        ],
      ),
    );
  }
}
