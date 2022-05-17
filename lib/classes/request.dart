import 'package:exchange/classes/book.dart';
import 'package:exchange/classes/user.dart';

class Request {
  String userId;
  String bookId;
  String date;
  String id;
  Book book;
  User user;
  int status;

  void setId(String id) {
    this.id = id;
  }

  void setBook(Book book) {
    this.book = book;
  }

  void setUser(User user) {
    this.user = user;
  }

  void changeStatus(int i) {
    this.status = i;
  }

  Request({this.userId, this.bookId, this.date, this.status = 0});

  Request.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    bookId = json['book_id'];
    date = json['date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['book_id'] = this.bookId;
    data['date'] = this.date;
    data['status'] = this.status;
    return data;
  }
}

Request createRequest(record) {
  Map<String, dynamic> attributes = {
    "user_id": '',
    "book_id": '',
    "date": '',
    "status": 0
  };
  record.forEach((key, value) => {attributes[key] = value});
  Request user = Request.fromJson(attributes);
  return user;
}
