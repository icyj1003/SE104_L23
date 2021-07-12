/*
Name: Widget BookList
Last Modified: 7/7/21
Description: Định nghĩa Widget BookList
Notes: 
*/

import 'package:exchange/constants.dart';
import 'package:flutter/material.dart';
import '../classes/book.dart';
import 'book_widget.dart';

class BookListWidget extends StatelessWidget {
  final double width;
  final double height;
  final bool renderUser;
  final List<Book> books;
  final String userId;
  final Function() refresh;
  const BookListWidget({
    Key key,
    @required this.refresh,
    @required this.renderUser,
    @required this.books,
    @required this.width,
    @required this.height,
    @required this.userId,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (books.length == 0)
      return Padding(
        padding: const EdgeInsets.only(left: 10, top: 0, bottom: 30),
        child: SizedBox(
          height: 300,
          child: Text(
            'Trống',
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
      );
    else
      return SizedBox(
        width: width,
        height: 300,
        child: ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List<Widget>.generate(
              books.length,
              (index) => BookWidget(
                  refresh: refresh,
                  renderUser: renderUser,
                  userId: userId,
                  width: width * book_width_ratio,
                  height: height * book_height_ratio,
                  index: index,
                  book: books[index]),
            )),
      );
  }
}
