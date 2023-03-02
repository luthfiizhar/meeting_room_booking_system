import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room_booking_system/constant/color.dart';
import 'package:meeting_room_booking_system/constant/constant.dart';
import 'package:meeting_room_booking_system/functions/api_request.dart';
import 'package:meeting_room_booking_system/model/main_model.dart';
import 'package:meeting_room_booking_system/model/search_term.dart';
import 'package:meeting_room_booking_system/widgets/dialogs/alert_dialog_black.dart';
import 'package:meeting_room_booking_system/widgets/dropdown/black_dropdown.dart';
import 'package:meeting_room_booking_system/widgets/layout_page.dart';
import 'package:shimmer/shimmer.dart';

class FeedBackListPage extends StatefulWidget {
  const FeedBackListPage({super.key});

  @override
  State<FeedBackListPage> createState() => _FeedBackListPageState();
}

class _FeedBackListPageState extends State<FeedBackListPage> {
  ScrollController scrollController = ScrollController();
  MainModel mainModel = MainModel();
  ReqAPI apiReq = ReqAPI();

  String totalUser = "";
  String totalSubmission = "";
  String averageRating = "";
  String highRating = "";
  String lowRating = "";

  SearchTerm searchTerm = SearchTerm(
    max: "10",
  );

  FocusNode showPerRowsNode = FocusNode();

  List<Feedback> feedbackList = [];

  List filterList = [
    {'rating': 1, 'isSelected': false},
    {'rating': 2, 'isSelected': false},
    {'rating': 3, 'isSelected': false},
    {'rating': 4, 'isSelected': false},
    {'rating': 5, 'isSelected': false},
  ];

  bool isLoading = false;

  int currentPaginatedPage = 1;
  List availablePage = [1];
  List showedPage = [1];
  List showPerPageList = ["5", "10", "20", "50", "100"];
  int resultRows = 0;

  List<FilterRatingContainer> filterContainer = [];

  List<FeedbackListItem> feedbackItem = [];

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

  onClickFeedbackItem(int index) {
    // feedbackItem.where((element) => element.index != index).forEach((element) {
    //   if (element.feedback!.expanded) {
    //     element.feedback!.expanded = false;
    //   }
    //   setState(() {});
    // });
    for (var element in feedbackList) {
      element.expanded = false;
    }
    if (!feedbackList[index].expanded) {
      // print('if false');
      feedbackList[index].expanded = true;
    } else if (feedbackList[index].expanded) {
      // print('if true');
      feedbackList[index].expanded = false;
    }
    setState(() {});
  }

  closeDetail(index) {
    setState(() {
      feedbackList[index].expanded = false;
    });
  }

  onCLickFilter(dynamic filter) {
    // print(filter);
    // searchTerm.rating = [];
    searchTerm.pageNumber = "1";
    currentPaginatedPage = int.parse(searchTerm.pageNumber);
    if (filter['isSelected']) {
      searchTerm.rating!.add(filter['rating']);
    } else {
      searchTerm.rating!.removeWhere((element) => element == filter['rating']);
    }
    // for (var element in filter) {
    //   if (element['isSelected']) {
    //     searchTerm.rating!.add(element['value']);
    //   }
    // }
    // print(searchTerm);
    feedbackListInit().then((value) {
      countPagination(resultRows);
    });
    setState(() {});
  }

  resetAll(bool value) {
    setState(() {});
  }

  resetState() {
    setState(() {});
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
      feedbackListInit().then((value) {
        setState(() {});
      });
    });
  }

  Future feedbackListInit() {
    // print(searchTerm);
    setState(() {
      isLoading = true;
      feedbackList.clear();
    });
    return apiReq.feedbackList(searchTerm).then((value) {
      if (value['Status'].toString() == "200") {
        List listResult = value['Data']['List'];
        resultRows = value['Data']['TotalRows'];
        totalUser = value['Data']['TotalUser'].toString();
        totalSubmission = value['Data']['TotalSubmission'].toString();
        averageRating = value['Data']['AverageRating'].toString();
        highRating = value['Data']['MaxRating'].toString();
        lowRating = value['Data']['MinRating'].toString();
        // print("LIST RESULT $listResult");
        for (var element in listResult) {
          feedbackList.add(Feedback(
            empName: element['EmpName'],
            nip: element['EmpNIP'],
            email: element['Email'],
            phoneNumber: element['PhoneNumber'],
            photo: element['Photo'],
            submittedDateTime: element['Created_At'],
            rating: element['Rating'],
            comment: element['Comments'],
          ));
        }
        for (var i = 0; i < feedbackList.length; i++) {
          feedbackItem.add(FeedbackListItem(
            feedback: feedbackList[i],
            index: i,
            onClick: onClickFeedbackItem,
            close: closeDetail,
            expanded: feedbackList[i].expanded,
          ));
        }
        isLoading = false;
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
          title: "Error getFeedbackList",
          contentText: error.toString(),
          isSuccess: false,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    feedbackListInit().then((value) {
      countPagination(resultRows);
      setState(() {});
    });

    for (var element in filterList) {
      filterContainer.add(
        FilterRatingContainer(
          filter: element,
          onClick: onCLickFilter,
        ),
      );
    }

    showPerRowsNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    showPerRowsNode.removeListener(() {});
    showPerRowsNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double paginationWidth = availablePage.length <= 5
        ? ((45 * (showedPage.length.toDouble())))
        : ((55 * (showedPage.length.toDouble())));

    return LayoutPageWeb(
      index: 1,
      setDatePickerStatus: resetAll,
      scrollController: scrollController,
      model: mainModel,
      topButtonVisible: false,
      resetState: resetState,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 1100,
          maxWidth: 1100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              'User Rating',
              style: helveticaText.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: eerieBlack,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                summaryContainer(
                  'Total User',
                  content: Text(
                    totalUser,
                    style: helveticaText.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: eerieBlack,
                    ),
                  ),
                ),
                const Expanded(
                  child: SizedBox(
                    height: 80,
                    child: VerticalDivider(
                      color: davysGray,
                      width: 1,
                    ),
                  ),
                ),
                summaryContainer(
                  'Total Submission',
                  content: Text(
                    totalSubmission,
                    style: helveticaText.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: eerieBlack,
                    ),
                  ),
                ),
                const Expanded(
                  child: SizedBox(
                    height: 80,
                    child: VerticalDivider(
                      color: davysGray,
                      width: 1,
                    ),
                  ),
                ),
                summaryContainer(
                  'Average Rating',
                  content: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    children: [
                      const Icon(
                        Icons.star,
                        color: yellow,
                        size: 32,
                      ),
                      Text(
                        averageRating,
                        style: helveticaText.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: eerieBlack,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: SizedBox(
                    height: 80,
                    child: VerticalDivider(
                      color: davysGray,
                      width: 1,
                    ),
                  ),
                ),
                summaryContainer(
                  'Highest Rating',
                  content: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    children: [
                      const Icon(
                        Icons.star,
                        color: yellow,
                        size: 32,
                      ),
                      Text(
                        highRating,
                        style: helveticaText.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: eerieBlack,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: SizedBox(
                    height: 80,
                    child: VerticalDivider(
                      color: davysGray,
                      width: 1,
                    ),
                  ),
                ),
                summaryContainer(
                  'Lowest Rating',
                  content: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    children: [
                      const Icon(
                        Icons.star,
                        color: yellow,
                        size: 32,
                      ),
                      Text(
                        lowRating,
                        style: helveticaText.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: eerieBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Text(
                  'Filter:',
                  style: helveticaText.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Wrap(
                  spacing: 10,
                  children: filterContainer
                      .map(
                        (e) => e,
                      )
                      .toList(),
                )
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            //HEADER
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: () {
                      onTapHeader("EmpName");
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'User',
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
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      onTapHeader("Rating");
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Rating',
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
                            'Submitted Date',
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
                  width: 20,
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
                : feedbackList.isEmpty
                    ? Center(
                        child: SizedBox(
                          width: double.infinity,
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
                        itemCount: feedbackList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return FeedbackListItem(
                            feedback: feedbackList[index],
                            index: index,
                            onClick: onClickFeedbackItem,
                            close: closeDetail,
                            expanded: feedbackList[index].expanded,
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
                              feedbackListInit().then((value) {
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
                                  feedbackListInit();
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
                                            feedbackListInit();
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
                                  feedbackListInit();
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

  Widget summaryContainer(String label, {Widget? content}) {
    return SizedBox(
      width: 175,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          content!,
          const SizedBox(
            height: 15,
          ),
          Text(
            label,
            style: helveticaText.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color: davysGray,
            ),
          )
        ],
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

class FeedbackListItem extends StatefulWidget {
  FeedbackListItem({
    super.key,
    this.index = 0,
    Feedback? feedback,
    this.onClick,
    this.close,
    this.expanded = false,
  }) : feedback = feedback ?? Feedback();

  Feedback? feedback;
  int index;
  Function? onClick;
  Function? close;
  bool expanded;

  @override
  State<FeedbackListItem> createState() => _FeedbackListItemState();
}

class _FeedbackListItemState extends State<FeedbackListItem> {
  List<Widget> star = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.feedback!.rating; i++) {
      star.add(
        const Icon(
          Icons.star,
          size: 18,
          color: yellow,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.index == 0
            ? const SizedBox()
            : const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 18,
                ),
                child: Divider(
                  color: davysGray,
                  thickness: 1,
                ),
              ),
        Column(
          children: [
            InkWell(
              splashFactory: NoSplash.splashFactory,
              hoverColor: Colors.transparent,
              onTap: () {
                setState(() {
                  if (widget.expanded) {
                    // widget.expanded = false;
                    widget.close!(widget.index);
                  } else {
                    // widget.expanded = true;
                    widget.onClick!(widget.index);
                  }
                  // widget.onClick!(widget.index);
                  setState(() {});
                });
              },
              child: widget.expanded
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              widget.feedback!.photo == ""
                                  ? Container(
                                      width: 50,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: sonicSilver,
                                      ),
                                      child: Center(
                                        child: Text(
                                          widget.feedback!.empName.characters
                                              .first,
                                          style: helveticaText.copyWith(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            color: white,
                                            height: 1.15,
                                          ),
                                        ),
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: widget.feedback!.photo,
                                      placeholder: (context, url) {
                                        return Shimmer(
                                          gradient: const LinearGradient(
                                            colors: [
                                              platinum,
                                              grayx11,
                                              davysGray
                                            ],
                                          ),
                                          direction: ShimmerDirection.rtl,
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        );
                                      },
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.transparent,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                      errorWidget: (context, url, error) {
                                        return Container(
                                          width: 50,
                                          height: 50,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: sonicSilver,
                                          ),
                                          child: Center(
                                            child: Text(
                                              widget.feedback!.empName
                                                  .characters.first,
                                              style: helveticaText.copyWith(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700,
                                                color: white,
                                                height: 1.15,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                widget.feedback!.empName,
                                style: helveticaText.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: eerieBlack,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${widget.feedback!.email} - ${widget.feedback!.phoneNumber}",
                            textAlign: TextAlign.end,
                            style: helveticaText.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: sonicSilver,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        const SizedBox(
                          width: 20,
                          child: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            size: 32,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              widget.feedback!.photo == ""
                                  ? Container(
                                      width: 50,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: sonicSilver,
                                      ),
                                      child: Center(
                                        child: Text(
                                          widget.feedback!.empName.characters
                                              .first,
                                          style: helveticaText.copyWith(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                            color: white,
                                            height: 1.15,
                                          ),
                                        ),
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: widget.feedback!.photo,
                                      placeholder: (context, url) {
                                        return Shimmer(
                                          gradient: const LinearGradient(
                                            colors: [
                                              platinum,
                                              grayx11,
                                              davysGray
                                            ],
                                          ),
                                          direction: ShimmerDirection.rtl,
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        );
                                      },
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.transparent,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                              const SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.feedback!.empName,
                                      style: helveticaText.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: eerieBlack,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      widget.feedback!.comment,
                                      style: helveticaText.copyWith(
                                        fontSize: 16,
                                        // fontWeight: FontWeight.w300,
                                        color: davysGray,
                                        // height: 1,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: false,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.feedback!.rating.toString(),
                                style: helveticaText.copyWith(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w400,
                                  color: eerieBlack,
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Wrap(
                                children: star.map((e) {
                                  return e;
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            widget.feedback!.submittedDateTime,
                            style: helveticaText.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: eerieBlack,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                          child: Icon(
                            Icons.chevron_right_sharp,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
            ),
            !widget.expanded
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(left: 70),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.feedback!.rating.toString(),
                              style: helveticaText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: eerieBlack,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Wrap(
                              spacing: 10,
                              children: star.map((e) {
                                return e;
                              }).toList(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.feedback!.comment,
                          style: helveticaText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: davysGray,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.feedback!.submittedDateTime,
                          style: helveticaText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: sonicSilver,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}

class FilterRatingContainer extends StatefulWidget {
  FilterRatingContainer({
    super.key,
    this.filter,
    this.onClick,
  });

  dynamic filter;
  Function? onClick;

  @override
  State<FilterRatingContainer> createState() => _FilterRatingContainerState();
}

class _FilterRatingContainerState extends State<FilterRatingContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      hoverColor: Colors.transparent,
      onTap: () {
        if (widget.filter['isSelected']) {
          widget.filter['isSelected'] = false;
        } else {
          widget.filter['isSelected'] = true;
        }
        widget.onClick!(widget.filter);
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: widget.filter['isSelected'] ? eerieBlack : white,
          borderRadius: BorderRadius.circular(20),
          border: widget.filter['isSelected']
              ? Border.all(color: eerieBlack, width: 1)
              : Border.all(color: davysGray, width: 1),
        ),
        child: Wrap(
          children: [
            Text(
              widget.filter['rating'].toString(),
              style: helveticaText.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: widget.filter['isSelected'] ? white : davysGray,
              ),
            ),
            Icon(
              Icons.star,
              size: 20,
              color: widget.filter['isSelected'] ? white : davysGray,
            )
          ],
        ),
      ),
    );
  }
}

class Feedback {
  Feedback({
    this.empName = "",
    this.nip = "",
    this.photo = "",
    this.comment = "",
    this.rating = 0,
    this.expanded = false,
    this.submittedDateTime = "",
    this.email = "",
    this.phoneNumber = "",
  });
  String empName;
  String nip;
  String photo;
  String comment;
  String submittedDateTime;
  String email;
  String phoneNumber;
  int rating;
  bool expanded;
}
