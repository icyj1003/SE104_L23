//
class Favorite {
  String userId;
  String bookId;
  String getUser() => this.userId;
  String getBook() => this.bookId;

  String id;

  Favorite({this.userId, this.bookId});
  void setId(String id) {
    this.id = id;
  }

  Favorite.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    bookId = json['book_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['book_id'] = this.bookId;
    return data;
  }
}

Favorite createFavorite(record) {
  Map<String, dynamic> attributes = {
    'user_id': '',
    'book_id': '',
  };
  record.forEach((key, value) => {attributes[key] = value});
  Favorite book = Favorite.fromJson(attributes);
  return book;
}
