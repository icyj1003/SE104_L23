/*
Name: Profile
Last Modified: 7/7/21
Description: Màn hình hiển thị thông tin người dùng
Notes: 
*/

import 'package:exchange/classes/request.dart';
import 'package:exchange/components/booklist.dart';
import 'package:exchange/constants.dart';
import 'package:exchange/database.dart';
import 'package:exchange/classes/favorite.dart';
import 'package:exchange/screens/add_book.dart';
import 'package:exchange/screens/profile_edit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../classes/book.dart';
import '../classes/user.dart';
import 'profile_edit.dart';
import 'add_book.dart';

class Profile extends StatefulWidget {
  final String userId;
  final String id;
  const Profile({Key key, @required this.userId, @required this.id})
      : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user = User();
  List<Book> myBooks = [];
  List<Book> myFavorites = [];
  void updateUser() {
    getProfile(widget.id).then((value) => this.setState(() {
          this.user = value;
        }));
  }

  List<Request> res = [];
  void updateMyRequest() {
    getAllRequest(widget.userId).then((value) => this.setState(() {
          res = value;
        }));
    Future.delayed(
        Duration(
          seconds: 1,
        ), () {
      setState(() {});
    });
  }

  void updateBooks() {
    myBooks = [];
    myFavorites = [];
    getFavorites(widget.userId).then((favors) => this.setState(() {
          for (Favorite favor in favors) {
            if (favor.userId == widget.userId) {
              getBook(favor.bookId).then((value) => myFavorites.add(value));
            }
          }
        }));
    getAllBooks().then((books) => this.setState(() {
          for (Book book in books) {
            if (book.owner == widget.id && book.status != 2) myBooks.add(book);
          }
        }));
  }

  void updateFavor() {}

  @override
  void initState() {
    updateMyRequest();
    updateUser();
    updateBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final height = MediaQuery.of(context).size.height;
    if (user.id == null) {
      user = User(
          address: 'Đang tải ... ',
          fullname: 'Đang tải ... ',
          dob: 'Đang tải ... ',
          avatar:
              'https://vnn-imgs-a1.vgcloud.vn/image1.ictnews.vn/_Files/2020/03/17/trend-avatar-1.jpg',
          school: 'Đang tải ... ',
          phone: 'Đang tải ... ',
          sex: 0,
          email: 'Đang tải ... ',
          password: 'Đang tải ... ');
      user.setId('Đang tải ... ');
    }
    return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.white,
        //AppBar
        appBar: AppBar(
          actions: widget.id == widget.userId
              ? [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile(
                                      profile: user,
                                    ))).then((_) => refresh());
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ))
                ]
              : null,
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            widget.id == widget.userId ? 'Hồ sơ của tôi' : 'Hồ sơ người dùng',
            style: titleStyle,
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context)),
        ),
        body: SingleChildScrollView(
          //physics: BouncingScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                //Tên người dùng
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 1, color: Colors.black, spreadRadius: 1)
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(user.avatar),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //Tên người dùng
                Text(
                  user.fullname,
                  style: GoogleFonts.openSans(
                      fontSize: 25, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                //Thông tin cá nhân
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                      width: width,
                      height: 300,
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getField('Tên người dùng', widget.id),
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                            getField(
                              'Họ tên',
                              user.fullname,
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                            getField('Giới tính', "${getSex(user.sex)}"),
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                            getField('Ngày sinh', user.dob),
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                            getField('Điện thoại', user.phone),
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                            getField('Email', user.email),
                            Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                            getField('Địa chỉ', user.address),
                          ],
                        ),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                //Thông số
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: width,
                    height: 60,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sách',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${myBooks.length}',
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        VerticalDivider(
                          thickness: 1,
                          color: Colors.white,
                          indent: 10,
                          endIndent: 10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Thích',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                myFavorites.length.toString(),
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //Sách
                user.id == widget.userId
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          makeTitle('Sách của tôi', 'Thêm sách', () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddBook(
                                          userId: widget.userId,
                                        ))).then((_) => refresh());
                          }),
                          BookListWidget(
                              renderUser: false,
                              refresh: refresh,
                              books: myBooks,
                              width: width,
                              height: height,
                              res: res,
                              userId: widget.userId),
                          SizedBox(
                            height: 30,
                          ),
                          makeTitle('Sách đã thích', null, null),
                          BookListWidget(
                              renderUser: true,
                              refresh: refresh,
                              width: width,
                              books: myFavorites,
                              height: height,
                              userId: widget.userId),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          makeTitle('Sách hiện có', null, null),
                          BookListWidget(
                              renderUser: false,
                              refresh: null,
                              width: width,
                              books: myBooks,
                              height: height,
                              userId: widget.userId),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
              ],
            ),
          ),
        ));
  }

  Widget makeTitle(String title, String sub, Function() onTap) => Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
        child: sub == null
            ? Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: onTap,
                    child: Text(
                      sub,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  )
                ],
              ),
      );
  Widget getField(String title, String content) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.openSans(color: Colors.white, fontSize: 15)),
          SelectableText(content,
              style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600))
        ]);
  }

  void refresh() {
    updateBooks();
    updateUser();
  }
}
