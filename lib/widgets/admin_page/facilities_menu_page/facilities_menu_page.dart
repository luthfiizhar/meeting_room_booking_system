import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/amenities_class.dart';
import 'package:meeting_room_booking_system/model/search_term.dart';
import 'package:meeting_room_booking_system/widgets/admin_page/facilities_menu_page/add_facility_dialog.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/confirmation_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/input_field/black_input_field.dart';
import 'package:meeting_room_booking_system/widgets/input_field/search_input_field.dart';
import 'package:responsive_framework/responsive_framework.dart';

class FacilitiesMenuPage extends StatefulWidget {
  const FacilitiesMenuPage({super.key});

  @override
  State<FacilitiesMenuPage> createState() => _FacilitiesMenuPageState();
}

class _FacilitiesMenuPageState extends State<FacilitiesMenuPage> {
  ReqAPI apiReq = ReqAPI();
  TextEditingController _search = TextEditingController();
  FocusNode searchNode = FocusNode();
  FocusNode showPerRowsNode = FocusNode();

  SearchTerm searchTerm = SearchTerm(max: "20");

  int selectedIndexArea = 0;

  int totalResult = 0;

  List facilitiesList = [];
  List<Amenities> facility = [];

  List showPerPageList = ["5", "10", "20", "50", "100"];

  int currentPaginatedPage = 1;
  List availablePage = [1];
  List showedPage = [1];

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
      print(availablePage);
      // print(showedPage);
      showedPage = availablePage.take(5).toList();
    });
  }

  onTapHeader(String orderBy) {}

  Future updateList() {
    facility.clear();
    return apiReq.getFacilitiesTableList(searchTerm).then((value) {
      if (value['Status'] == '200') {
        print(value);
        facilitiesList = value['Data']['List'];
        totalResult = value['Data']['TotalRows'];
        for (var element in facilitiesList) {
          facility.add(
            Amenities(
              amenitiesId: element['AmenitiesID'].toString(),
              amenitiesName: element['AmenitiesName'],
              type: element['Value'],
              photo: element['ImageURL'],
              typeName: element['AmenitiesType'],
            ),
          );
        }
        // countPagination(value['Data']['TotalRows']);
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
      setState(() {});
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
                'Facility List',
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
                  builder: (context) => AddNewFacilityDialog(
                    isEdit: false,
                  ),
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
                      'Add Facility',
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
                prefixIcon: Icon(
                  Icons.search,
                  color: davysGray,
                ),
                hintText: 'Search here',
                focusNode: searchNode,
                maxLines: 1,
                onFieldSubmitted: (value) {
                  setState(() {
                    searchTerm.keyWords = value;
                    updateList().then((value) {
                      setState(() {});
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
        // Wrap(
        //   runSpacing: 10,
        //   children: facilitiesList
        //       .asMap()
        //       .map(
        //         (index, value) => MapEntry(
        //           index,
        //           index % 2 == 0
        //               ? Container(
        //                   height: 290,
        //                   width: 200,
        //                   color: blueAccent,
        //                 )
        //               : const Padding(
        //                   padding: EdgeInsets.symmetric(
        //                     horizontal: 7,
        //                   ),
        //                   child: SizedBox(
        //                     height: 290,
        //                     child: VerticalDivider(
        //                       color: davysGray,
        //                       thickness: 0.5,
        //                     ),
        //                   ),
        //                 ),
        //         ),
        //       )
        //       .values
        //       .toList(),
        // ),
        facility.isEmpty
            ? SizedBox(
                width: double.infinity,
                height: 230,
                child: Center(
                  child: Text(
                    'No Facility available in the system.',
                    style: helveticaText.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: davysGray,
                    ),
                  ),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3 / 4,
                  crossAxisCount: 4,
                ),
                itemCount: facility.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 295,
                    width: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: platinum,
                        width: 0.5,
                      ),
                    ),
                    child: FacilitiesListContainer(
                      resetState: resetState,
                      facility: facility[index],
                    ),
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
                          searchTerm.pageNumber =
                              currentPaginatedPage.toString();
                          searchTerm.max = value!.toString();
                          updateList().then((value) {
                            countPagination(totalResult);
                            setState(() {});
                          });
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
                              updateList().then((value) {
                                setState(() {});
                              });
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
                    width: paginationWidth,
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
                                        updateList().then((value) {
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
                              updateList().then((value) {
                                setState(() {});
                              });
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
        //END FOOTER
      ],
    );
  }

  BoxDecoration myBoxDecoration(int index, int gridViewCrossAxisCount) {
    // index = index + 1;
    return BoxDecoration(
      color: Colors.transparent,
      border: Border(
          left: BorderSide(
            //                   <--- left side
            color: index % gridViewCrossAxisCount != 0
                ? Colors.black12
                : Colors.transparent,
            width: 1.5,
          ),
          top: BorderSide(
            //                   <--- left side
            color: index > gridViewCrossAxisCount
                ? Colors.black12
                : Colors.transparent,
            width: 1.5,
          ),
          bottom: BorderSide()),
    );
  }
}

class FacilitiesListContainer extends StatelessWidget {
  FacilitiesListContainer({
    super.key,
    this.resetState,
    Amenities? facility,
  }) : facility = facility ?? Amenities();

  ReqAPI apiReq = ReqAPI();
  Function? resetState;
  Amenities? facility;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
        bottom: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              width: 200,
              height: 175,
              child: facility!.photo! == ""
                  ? const SizedBox()
                  : CachedNetworkImage(
                      imageUrl: facility!.photo!,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          padding: const EdgeInsets.all(15),
                          width: 200,
                          height: 175,
                          // decoration: BoxDecoration(
                          //   image: DecorationImage(
                          //     image: imageProvider,
                          //     fit: BoxFit.contain,
                          //     alignment: Alignment.center,
                          //   ),
                          // ),
                          child: Center(
                            child: Image(
                              image: imageProvider,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  facility!.amenitiesName!,
                  style: helveticaText.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: davysGray,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  facility!.typeName!,
                  style: helveticaText.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: sonicSilver,
                  ),
                ),
                const SizedBox(
                  height: 33,
                ),
                Wrap(
                  spacing: 10,
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AddNewFacilityDialog(
                            isEdit: true,
                            amenities: facility,
                          ),
                        ).then((value) {
                          resetState!();
                        });
                      },
                      child: const Icon(
                        Icons.edit,
                        color: orangeAccent,
                        size: 18,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const ConfirmDialogBlack(
                            title: 'Confirmation',
                            contentText:
                                'Are you sure want delete this facility?',
                          ),
                        ).then((value) {
                          if (value) {
                            apiReq
                                .deleteFacilities(facility!.amenitiesId!)
                                .then((value) {
                              if (value['Status'].toString() == "200") {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialogBlack(
                                    title: value['Title'],
                                    contentText: value['Message'],
                                  ),
                                ).then((value) {
                                  resetState!();
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
                                  title: "Error deleteFacilities",
                                  contentText: error.toString(),
                                ),
                              );
                            });
                          }
                        });
                      },
                      child: const Icon(
                        Icons.delete_outline_outlined,
                        color: orangeAccent,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
