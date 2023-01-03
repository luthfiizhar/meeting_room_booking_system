import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/constant/custom_scroll_behavior.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/room.dart';
import 'package:meeting_room_booking_system/model/search_term.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/area_menu_page.dart/new_area_dialog.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';

class AreaMenuPage extends StatefulWidget {
  AreaMenuPage({
    super.key,
  });

  @override
  State<AreaMenuPage> createState() => _AreaMenuPageState();
}

class _AreaMenuPageState extends State<AreaMenuPage> {
  ReqAPI apiReq = ReqAPI();
  TextEditingController _search = TextEditingController();
  FocusNode searchNode = FocusNode();
  FocusNode showPerRowsNode = FocusNode();

  SearchTerm searchTerm = SearchTerm();

  int selectedIndexArea = 0;

  List areaList = [];
  List<Room> room = [];

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
      showedPage = availablePage.take(5).toList();
    });
  }

  onTapHeader(String orderBy) {}

  closeDetail(index) {
    setState(() {
      room[index].isCollapsed = false;
    });
  }

  onTapListArea(int index) {
    setState(() {
      // closeDetail();
      for (var element in room) {
        element.isCollapsed = false;
      }
      if (!room[index].isCollapsed) {
        print('if false');
        room[index].isCollapsed = true;
      } else if (room[index].isCollapsed) {
        print('if true');
        room[index].isCollapsed = false;
      }
    });
  }

  updateList() {
    areaList.clear();
    room.clear();
    apiReq.getRoomList(searchTerm).then((value) {
      if (value['Status'].toString() == "200") {
        areaList = value['Data']['List'];
        for (var element in areaList) {
          room.add(Room(
            roomId: element['RoomID'],
            roomName: element['RoomName'],
            roomType: element['RoomType'],
            buildingName: element['SiteLocation'],
            floorName: element['AreaName'],
            minCapacity: element['MinCapacity'].toString(),
            maxCapacity: element['MaxCapacity'].toString(),
            coverPhoto: element['CoverPhoto'],
            maxBookingDuration: element['Duration'].toString(),
            defaultFacilities: element['AvailableAmenities'],
            prohibitedFacilities: element['ForbiddenAmenities'],
            areaPhoto: element['RoomPhotos'],
            isCollapsed: false,
          ));
        }
        countPagination(value['Data']['TotalRows']);
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

    apiReq.getRoomList(searchTerm).then((value) {
      if (value['Status'].toString() == "200") {
        // print(value);
        areaList = value['Data']['List'];
        // for (var element in areaList) {
        //   areaList.add({'isCollapsed': false});
        // }
        for (var element in areaList) {
          room.add(Room(
            roomId: element['RoomID'],
            roomName: element['RoomName'],
            roomType: element['RoomType'],
            buildingName: element['SiteLocation'],
            floorName: element['AreaName'],
            minCapacity: element['MinCapacity'].toString(),
            maxCapacity: element['MaxCapacity'].toString(),
            coverPhoto: element['CoverPhoto'],
            maxBookingDuration: element['Duration'].toString(),
            defaultFacilities: element['AvailableAmenities'],
            prohibitedFacilities: element['ForbiddenAmenities'],
            areaPhoto: element['RoomPhotos'],
            isCollapsed: false,
          ));
        }
        countPagination(value['Data']['TotalRows']);
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
              showDialog(
                context: context,
                builder: (context) => NewAreaDialog(
                  isEdit: false,
                ),
              );
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
        itemCount: room.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return AreaListContainer(
            index: index,
            isCollapse: room[index].isCollapsed,
            onTap: onTapListArea,
            close: closeDetail,
            idRoom: room[index].roomId,
            roomName: room[index].roomName,
            roomType: room[index].roomType,
            maxCapacity: room[index].maxCapacity,
            minCapacity: room[index].minCapacity,
            floor: room[index].floorName,
            building: room[index].buildingName,
            maxDuration: room[index].maxBookingDuration,
            coverPhoto: room[index].coverPhoto,
            facility: room[index].defaultFacilities,
            prohibitedFacility: room[index].prohibitedFacilities,
            photoList: room[index].areaPhoto,
          );
        },
      ),
      const SizedBox(
        height: 60,
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
                                      updateList();
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
      //END FOOTER PAGINATION
    ]);
  }
}

class AreaListContainer extends StatefulWidget {
  AreaListContainer({
    super.key,
    this.idRoom = "",
    this.roomName = "",
    this.roomType = "",
    this.building = "",
    this.floor = "",
    this.minCapacity = "",
    this.maxCapacity = "",
    this.maxDuration = "",
    this.facility,
    this.prohibitedFacility,
    this.coverPhoto = "",
    this.photoList,
    this.onTap,
    this.isCollapse = false,
    this.index,
    this.close,
  });

  String idRoom;
  String roomName;
  String roomType;
  String floor;
  String building;
  String minCapacity;
  String maxCapacity;
  String maxDuration;
  String coverPhoto;

  List? facility;
  List? prohibitedFacility;
  List? photoList;

  bool isCollapse;
  int? index;

  Function? onTap;
  Function? close;

  @override
  State<AreaListContainer> createState() => _AreaListContainerState();
}

class _AreaListContainerState extends State<AreaListContainer> {
  ScrollController facilityScrollController = ScrollController();
  ScrollController prohibitedScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    facilityScrollController.addListener(() {});
    prohibitedScrollController.addListener(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    facilityScrollController.dispose();
    prohibitedScrollController.dispose();
  }

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
                // backgroundImage: NetworkImage(widget.coverPhoto),
              ),
              const SizedBox(
                width: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.roomName,
                    style: helveticaText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: davysGray,
                    ),
                  ),
                  Text(
                    widget.roomType,
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
                '${widget.floor}, ${widget.building}',
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
                '${widget.minCapacity}-${widget.maxCapacity}',
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
    var duration = int.parse(widget.maxDuration) / 3600;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 190,
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: davysGray,
            // image: DecorationImage(
            //   image: Image.network(widget.coverPhoto).image,
            //   fit: BoxFit.cover,
            // ),
          ),
        ),
        const SizedBox(
          width: 40,
        ),
        Expanded(
          child: Column(
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
                      detailInfo('Room Name: ', widget.roomName),
                      detailInfo('Building: ', widget.building),
                      detailInfo('Floor: ', widget.floor),
                      detailInfo('Type: ', widget.roomType),
                    ],
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      detailInfo('Min Capacity: ', widget.minCapacity),
                      detailInfo('Max Capacity: ', widget.maxCapacity),
                      detailInfo('Max Book Duration: ', '$duration Hours'),
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
                  height: 1.6,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: 400,
                child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: Scrollbar(
                    controller: facilityScrollController,
                    child: ListView.builder(
                      controller: facilityScrollController,
                      itemCount: widget.facility!.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(
                          right: 25,
                        ),
                        child: facilities(
                          widget.facility![index]['ImageURL'],
                          widget.facility![index]['AmenitiesName'],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prohibited',
                        style: helveticaText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: davysGray,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        width: 400,
                        child: ScrollConfiguration(
                          behavior: MyCustomScrollBehavior(),
                          child: Scrollbar(
                            controller: prohibitedScrollController,
                            child: ListView.builder(
                              itemCount: widget.prohibitedFacility!.length,
                              controller: prohibitedScrollController,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(
                                  right: 25,
                                ),
                                child: facilities(
                                  widget.prohibitedFacility![index]['ImageURL'],
                                  widget.prohibitedFacility![index]
                                      ['AmenitiesName'],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 85,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.edit,
                              color: orangeAccent,
                              size: 25,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.delete_outline_sharp,
                              color: orangeAccent,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget detailInfo(String label, String info) {
    final TextStyle labelText = helveticaText.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w300,
      color: davysGray,
      height: 1.6,
    );
    final TextStyle contentText = helveticaText.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: davysGray,
      height: 1.6,
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

  Widget facilities(String photo, String name) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: lightGray,
                width: 0.5,
              ),
              image: DecorationImage(
                image: NetworkImage(photo),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            name,
            style: helveticaText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: davysGray,
            ),
          )
        ],
      ),
    );
  }
}

// class Room {
//   Room({
//     this.idRoom = "",
//     this.roomName = "",
//     this.floor = "",
//     this.building = "",
//     this.maxCapacity = "",
//     this.minCapacity = "",
//     this.roomType = "",
//     this.facility,
//     this.coverPhoto = "",
//     this.maxDuration = "",
//     this.photoList,
//     this.prohibitedFacilities,
//     this.isCollapsed = false,
//   });
//   String idRoom;
//   String roomName;
//   String floor;
//   String building;
//   String minCapacity;
//   String maxCapacity;
//   String maxDuration;
//   String roomType;
//   String coverPhoto;
//   List? photoList;
//   List? facility;
//   List? prohibitedFacilities;
//   bool isCollapsed;

//   @override
//   String toString() {
//     // TODO: implement toString
//     return "{idRoom : $idRoom, roomName : $idRoom, facility : $facility,}";
//   }
// }
