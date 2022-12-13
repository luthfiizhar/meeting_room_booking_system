class SearchTerm {
  SearchTerm({
    this.keyWords = "",
    this.max = "5",
    this.pageNumber = "1",
    this.orderBy = "",
    this.orderDir = "DESC",
  });

  String keyWords;
  String max;
  String pageNumber;
  String orderBy;
  String orderDir;
}
