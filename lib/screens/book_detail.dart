/*
Name: Book Details
Last Modified: 7/7/21
Description: Màn hình chi tiết sách
Notes: 
*/

import 'package:exchange/classes/request.dart';
import 'package:exchange/constants.dart';
import 'package:exchange/database.dart';
import 'package:exchange/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../classes/book.dart';
import 'profile.dart';

class Detail extends StatefulWidget {
  final bool renderUser;
  final Book book;
  final String userId;
  const Detail({
    Key key,
    @required this.userId,
    @required this.book,
    @required this.renderUser,
  }) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  User ownerProfile = User(fullname: '...', avatar: defaultAvatar);
  @override
  void initState() {
    getProfile(widget.book.owner).then((value) => this.setState(() {
          this.ownerProfile = value;
        }));
    super.initState();
  }

  _snackbar(String content) => SnackBar(content: Text(content));

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).padding.top +
                      AppBar().preferredSize.height),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: width * book_width_ratio * 1.5,
                      height: height * book_height_ratio * 1.5,
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
                            widget.book.url,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace stackTrace) {
                              return Image.network(defaultCover,
                                  fit: BoxFit.cover);
                            },
                            fit: BoxFit.cover,
                          ))),
                  SizedBox(width: 20),
                  SizedBox(
                      width:
                          width - 20 * 2 - width * book_width_ratio * 1.5 - 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.book.title,
                            style: bigBookTitle,
                          ),
                          Text(
                            widget.book.author,
                            style: bigAuthorName,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 85,
                            height: 29,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Align(
                              alignment: Alignment.center,
                              child: widget.book.status == 0
                                  ? (TextButton(
                                      onPressed:
                                          widget.book.owner != widget.userId
                                              ? () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                                title: const Text(
                                                                    'Gửi yêu cầu trao đổi'),
                                                                content: Text(
                                                                    'Bạn muốn gửi yêu cầu trao đổi ${widget.book.title} đến ${ownerProfile.getName()}?'),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              _snackbar('Huỷ yêu cầu!'));
                                                                    },
                                                                    child: Text(
                                                                      'Huỷ bỏ',
                                                                      style: GoogleFonts.roboto(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Request ex = Request(
                                                                          bookId: widget
                                                                              .book
                                                                              .id,
                                                                          userId: widget
                                                                              .userId,
                                                                          date:
                                                                              DateFormat('dd/MM/yyyy').format(DateTime.now()));
                                                                      addRequest(
                                                                          ex);
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              _snackbar('Đã gửi yêu cầu trao đổi!'));
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      'Xác nhận',
                                                                      style: GoogleFonts.roboto(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.green),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ));
                                                }
                                              : null,
                                      child: Text(
                                          widget.userId == widget.book.owner
                                              ? 'Sẵn sàng'
                                              : 'Trao đổi',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500)),
                                    ))
                                  : _getButton(),
                            ),
                          )
                        ],
                      )),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: width,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Thể loại'),
                          Text(
                            '${getCat(widget.book.category)}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    VerticalDivider(
                      thickness: 1,
                      color: Colors.black,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Điều kiện'),
                          Text(
                            '${getCond(widget.book.condition - 1)}',
                            style: GoogleFonts.roboto(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    VerticalDivider(
                      thickness: 1,
                      color: Colors.black,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Số trang'),
                          Text(
                            '${widget.book.npages}',
                            style: GoogleFonts.roboto(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Mô tả',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.book.description,
                style: smallDescription,
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  !widget.renderUser
                      // ignore: unnecessary_statements
                      ? 0
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile(
                                  userId: widget.userId,
                                  id: ownerProfile.id))).then((_) => null);
                },
                child: Container(
                  width: width,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(ownerProfile.avatar),
                            backgroundColor: Colors.transparent,
                          )),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Quyển sách này của',
                              style: GoogleFonts.lato(fontSize: 18),
                            ),
                            Text(
                              ownerProfile.getName(),
                              style: GoogleFonts.lato(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getButton() {
    return TextButton(
      onPressed: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(_snackbar('Sách không có sẵn!'));
      },
      child: Text('Unavailable',
          style: TextStyle(
              fontSize: 12, color: Colors.red, fontWeight: FontWeight.w500)),
    );
  }
}
