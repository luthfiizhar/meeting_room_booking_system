import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/model/search_term.dart';
import 'package:meeting_room_booking_system/pages/user/my_book_page.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';

class ListPagination extends StatefulWidget {
  ListPagination({
    super.key,
    this.currentPage = 1,
    this.availablePage,
    this.showedPage,
    this.nextPage,
    this.prevPage,
    this.nextNumber,
    this.prevNumber,
    this.searchTerm,
  });

  int currentPage;
  List? availablePage;
  List? showedPage;
  Function? prevPage;
  Function? nextPage;
  Function? nextNumber;
  Function? prevNumber;
  Function? onChangeShow;
  MyListBody? searchTerm;

  @override
  State<ListPagination> createState() => _ListPaginationState();
}

class _ListPaginationState extends State<ListPagination> {
  FocusNode showPerRowsNode = FocusNode();
  List showPerPageList = ["5", "10", "20", "50", "100"];

  int currentPaginatedPage = 1;
  List availablePage = [1, 2, 3, 4, 5];
  List showedPage = [1, 2, 3, 4, 5];

  initiate() {
    setState(() {
      currentPaginatedPage = widget.currentPage;
      availablePage = widget.availablePage!;
      showedPage = widget.showedPage!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiate();
    showPerRowsNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    showPerRowsNode.removeListener(() {});
    showPerRowsNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                      widget.searchTerm!.max = value!.toString();
                      // getMyBookingList(searchTerm).then((value) {
                      //   myBookList = value['Data']['List'];
                      //   countPagination(value['Data']['TotalRows']);
                      //   showedPage = availablePage.take(5).toList();
                      // });
                    });
                  },
                  value: widget.searchTerm!.max,
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
                          widget.searchTerm!.pageNumber =
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
                                      currentPaginatedPage = showedPage[index];
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
                                    widget.searchTerm!.pageNumber =
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
                                    // print(showedPage);
                                    // print(
                                    //     'current ${widget.searchTerm!.pageNumber}');
                                  },
                            child: Container(
                              width: 35,
                              height: 35,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 8.5,
                              ),
                              decoration: BoxDecoration(
                                color: showedPage[index] == currentPaginatedPage
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
                          widget.searchTerm!.pageNumber =
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
    );
  }
}
