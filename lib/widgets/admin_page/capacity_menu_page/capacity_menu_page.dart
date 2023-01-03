import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/room.dart';
import 'package:meeting_room_booking_system/model/search_term.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';

class CapacityMenuPage extends StatefulWidget {
  const CapacityMenuPage({super.key});

  @override
  State<CapacityMenuPage> createState() => _CapacityMenuPageState();
}

class _CapacityMenuPageState extends State<CapacityMenuPage> {
  // Room room = Room();
  ReqAPI apiReq = ReqAPI();

  TextEditingController _search = TextEditingController();
  FocusNode searchNode = FocusNode();
  FocusNode showPerRowsNode = FocusNode();

  SearchTerm searchTerm = SearchTerm();

  List areaList = [];

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
    });
  }

  updateList() {
    areaList.clear();
    apiReq.getRoomList(searchTerm).then((value) {
      if (value['Status'].toString() == "200") {
        areaList = value['Data']['List'];
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
    searchTerm.orderBy = "FloorName";
    apiReq.getRoomList(searchTerm).then((value) {
      if (value['Status'] == "200") {
        setState(() {
          // print(value);
          areaList = value['Data']['List'];
          countPagination(value['Data']['TotalRows']);
          showedPage = availablePage.take(5).toList();
        });
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
    searchNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Area Capacity List',
                style: helveticaText.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: davysGray,
                ),
              ),
            ),
            // InkWell(
            //   onTap: () {
            //     // showDialog(
            //     //   context: context,
            //     //   builder: (context) => AddNewFloorDialog(),
            //     // );
            //   },
            //   child: SizedBox(
            //     child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         const Icon(
            //           Icons.add,
            //           color: orangeAccent,
            //           size: 16,
            //         ),
            //         const SizedBox(
            //           width: 10,
            //         ),
            //         Text(
            //           'Add Floor',
            //           style: helveticaText.copyWith(
            //             fontSize: 16,
            //             height: 1.3,
            //             fontWeight: FontWeight.w700,
            //             color: orangeAccent,
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // const SizedBox(
            //   width: 20,
            // ),
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
        //HEADER
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  onTapHeader("AreaName");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Area Name',
                        style: helveticaText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: davysGray,
                        ),
                      ),
                    ),
                    iconSort("AreaName"),
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
                  onTapHeader("Floor");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Floor',
                        style: helveticaText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: davysGray,
                        ),
                      ),
                    ),
                    iconSort("Floor"),
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
                  onTapHeader("Building");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Building',
                        style: helveticaText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: davysGray,
                        ),
                      ),
                    ),
                    iconSort("Building"),
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
                  onTapHeader("Capacity");
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Capacity',
                        style: helveticaText.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: davysGray,
                        ),
                      ),
                    ),
                    iconSort("Capacity"),
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
          itemCount: areaList.length,
          itemBuilder: (context, index) {
            Room room = Room(
              roomId: areaList[index]['RoomID'],
              roomName: areaList[index]['RoomName'],
              floorName: areaList[index]['AreaName'],
              buildingName: areaList[index]['SiteLocation'],
              maxCapacity: areaList[index]['MaxCapacity'].toString(),
              prohibitedFacilities: [],
              defaultFacilities: [],
              areaPhoto: [],
            );
            return AreaCapacityListContainer(
              room: room,
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
        const SizedBox(
          height: 20,
        ),
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

class AreaCapacityListContainer extends StatefulWidget {
  AreaCapacityListContainer({
    super.key,
    this.room,
  });

  Room? room;
  Function? onRemove;

  @override
  State<AreaCapacityListContainer> createState() =>
      _AreaCapacityListContainerState();
}

class _AreaCapacityListContainerState extends State<AreaCapacityListContainer> {
  TextEditingController _capacity = TextEditingController();
  FocusNode capacityNode = FocusNode();
  int? index;

  @override
  void initState() {
    super.initState();

    _capacity.text = widget.room!.maxCapacity;
    capacityNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    capacityNode.removeListener(() {});
    capacityNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.room!.roomName,
                ),
              ),
              Expanded(
                child: Text(
                  widget.room!.floorName,
                ),
              ),
              Expanded(
                child: Text(
                  widget.room!.buildingName,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 75,
                      child: BlackInputField(
                        controller: _capacity,
                        focusNode: capacityNode,
                        enabled: true,
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(
                        width: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: davysGray,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
