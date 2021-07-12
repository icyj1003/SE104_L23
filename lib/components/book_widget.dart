/*
Name: Widget Book
Last Modified: 7/7/21
Description: Định nghĩa Widget Book
Notes: 
*/

import 'dart:async';
import 'package:exchange/database.dart';
import 'package:exchange/screens/book_edit.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
import '../classes/book.dart';
import '../constants.dart';
import '../screens/book_detail.dart';
import 'package:focused_menu/focused_menu.dart';

class BookWidget extends StatelessWidget {
  const BookWidget(
      {Key key,
      @required this.index,
      @required this.renderUser,
      @required this.book,
      @required this.width,
      @required this.userId,
      @required this.refresh,
      @required this.height})
      : super(key: key);
  final Function refresh;
  final bool renderUser;
  final int index;
  final Book book;
  final double width;
  final double height;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(content: Text('Đã xoá thành công'));
    return FocusedMenuHolder(
      child: Padding(
        padding: index == 0
            ? const EdgeInsets.only(left: 10, right: 10)
            : const EdgeInsets.only(right: 10),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Detail(
                          renderUser: renderUser,
                          userId: userId,
                          book: book,
                        ))).then((_) {
              if (renderUser != false) {
                refresh();
              }
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        book.url,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace stackTrace) {
                          return Image.network(defaultCover, fit: BoxFit.cover);
                        },
                        fit: BoxFit.cover,
                      ))),
              SizedBox(height: 10),
              SizedBox(
                width: width,
                height: 10,
                child: Text(
                  book.author,
                  style: smallAuthorName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: width,
                height: 20,
                child: Text(
                  book.title,
                  style: smallBookTitle,
                  overflow: TextOverflow.visible,
                  maxLines: 4,
                ),
              )
            ],
          ),
        ),
      ),
      menuWidth: width,
      blurSize: 5.0,
      menuItemExtent: 45,
      menuBoxDecoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      duration: Duration(milliseconds: 100),
      animateMenuItems: true,
      blurBackgroundColor: Colors.white,
      openWithTap: false,
      menuOffset: 0,
      bottomOffsetHeight: 80.0,
      menuItems: userId == book.owner
          ? [
              FocusedMenuItem(
                  title: Text(
                    "Chính sửa",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailingIcon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  backgroundColor: mainColor,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditBook(
                                  book: book,
                                ))).then((_) => refresh());
                  }),
              FocusedMenuItem(
                  title: Text(
                    "Chi tiết",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailingIcon: Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                  backgroundColor: mainColor,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Detail(
                                  renderUser: renderUser,
                                  userId: userId,
                                  book: book,
                                ))).then((_) => refresh());
                  }),
              FocusedMenuItem(
                  title: Text(
                    "Xoá",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailingIcon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  backgroundColor: mainColor,
                  onPressed: () {
                    deleteBook(book.id);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    refresh();
                  })
            ]
          : [
              FocusedMenuItem(
                  title: Text(
                    "Thích/Bỏ",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailingIcon: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                  backgroundColor: mainColor,
                  onPressed: () {
                    favorite(userId, book.id);
                    Timer(Duration(seconds: 2), refresh);
                  }),
              FocusedMenuItem(
                  title: Text(
                    "Chi tiết",
                    style: TextStyle(color: Colors.white),
                  ),
                  trailingIcon: Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                  backgroundColor: mainColor,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Detail(
                                  renderUser: renderUser,
                                  userId: userId,
                                  book: book,
                                ))).then((_) => refresh());
                  }),
            ],
      onPressed: () {},
    );
  }
}
