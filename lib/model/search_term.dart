class SearchTerm {
  SearchTerm({
    this.keyWords = "",
    this.max = "5",
    this.pageNumber = "1",
    this.orderBy = "",
    this.orderDir = "DESC",
    this.status = "",
    List? rating,
  }) : rating = rating ?? [];

  String keyWords;
  String max;
  String pageNumber;
  String orderBy;
  String orderDir;
  String status;
  List? rating;

  @override
  String toString() {
    return "{keywords:$keyWords, max:$max, pageNumber:$pageNumber, orderBy:$orderBy, orderDir:$orderDir, rating: $rating}";
  }
}
