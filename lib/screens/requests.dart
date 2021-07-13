/*
Name: Received Requests
Last Modified: 7/7/21
Description: Màn hình yêu cầu nhận được
Notes: 
*/
import 'package:exchange/classes/book.dart';
import 'package:exchange/classes/exchange.dart';
import 'package:exchange/constants.dart';
import 'package:exchange/classes/request.dart';
import 'package:exchange/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../database.dart';
import 'book_detail.dart';

class Noti extends StatefulWidget {
  final String userId;
  const Noti({Key key, this.userId}) : super(key: key);

  @override
  _NotiState createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  List<Request> res = [];
  void updateMyRequest() {
    getAllRequest(widget.userId).then((value) => this.setState(() {
          res = value;
        }));
    Future.delayed(
        Duration(
          seconds: 1,
        ), () {
      res.sort((b, a) {
        return DateFormat('dd/MM/yyyy')
            .parse(a.date)
            .compareTo(DateFormat('dd/MM/yyyy').parse(b.date));
      });
      setState(() {});
    });
  }

  @override
  void initState() {
    updateMyRequest();
    super.initState();
  }

  _snackBar(String content) =>
      SnackBar(duration: Duration(seconds: 1), content: Text(content));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                updateMyRequest();
                ScaffoldMessenger.of(context)
                    .showSnackBar(_snackBar('Đã làm mới'));
              },
              icon: Icon(
                Icons.replay_outlined,
                color: Colors.black,
              ))
        ],
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        title: Text(
          'Danh sách ${res.length} yêu cầu',
          style: titleStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
              res.length,
              (index) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Profile(
                                              userId: widget.userId,
                                              id: res[index].userId)))
                                  .then((_) => null);
                            },
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                  res[index].user.avatar == null
                                      ? defaultAvatar
                                      : res[index].user.avatar),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${res[index].date}',
                                  style: GoogleFonts.lato(fontSize: 12)),
                              Text(
                                '${res[index].user.getName()} muốn ',
                                style: GoogleFonts.lato(fontSize: 14),
                              ),
                              SizedBox(
                                  width: 200,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Detail(
                                                    renderUser: false,
                                                    userId: widget.userId,
                                                    book: res[index].book,
                                                  )));
                                    },
                                    child: Text(
                                      '${res[index].book.title}',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.lato(fontSize: 18),
                                    ),
                                  )),
                            ],
                          ),
                          Column(
                            children: res[index].status == 0
                                ? [
                                    TextButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title: const Text(
                                                        'Đồng ý yêu cầu trao đổi'),
                                                    content: Text(
                                                        'Bạn đồng ý cho ${res[index].user.getName()} mượn ${res[index].book.title}?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  _snackBar(
                                                                      'Đã huỷ'));
                                                        },
                                                        child: Text(
                                                          'Huỷ bỏ',
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Book a =
                                                              res[index].book;
                                                          a.changeStatus();
                                                          a.setId(res[index]
                                                              .bookId);
                                                          for (Request re
                                                              in res) {
                                                            if (re.bookId ==
                                                                    res[index]
                                                                        .bookId &&
                                                                re.id !=
                                                                    res[index]
                                                                        .id) {
                                                              Request newRe =
                                                                  re;

                                                              newRe
                                                                  .changeStatus(
                                                                      2);
                                                              updateRequest(
                                                                  newRe);
                                                            }
                                                          }
                                                          Request re =
                                                              res[index];
                                                          re.changeStatus(1);
                                                          Exchange ex = Exchange(
                                                              requestId: re.id,
                                                              from: DateFormat(
                                                                      'dd/MM/yyyy')
                                                                  .format(DateTime
                                                                      .now()),
                                                              to: "");
                                                          addExchange(ex);
                                                          updateRequest(re);
                                                          updateBook(a);
                                                          updateMyRequest();
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  _snackBar(
                                                                      'Đã đồng ý yêu cầu'));
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Đồng ý',
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      ),
                                                    ],
                                                  ));
                                        },
                                        child: Text(
                                          'Đồng ý',
                                          style: TextStyle(color: Colors.green),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title: const Text(
                                                        'Từ chối yêu cầu'),
                                                    content: Text(
                                                        'Bạn từ chối cho ${res[index].user.getName()} mượn ${res[index].book.title}?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  _snackBar(
                                                                      'Đã huỷ'));
                                                        },
                                                        child: Text(
                                                          'Huỷ bỏ',
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Request re =
                                                              res[index];
                                                          re.changeStatus(2);
                                                          updateRequest(re);
                                                          updateMyRequest();
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  _snackBar(
                                                                      'Đã từ chối'));
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Từ chối',
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .green),
                                                        ),
                                                      ),
                                                    ],
                                                  ));
                                          // Request re = res[index];
                                          // re.changeStatus(2);
                                          // updateRequest(re);
                                          // updateMyRequest();
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(
                                          //         _snackBar('Đã từ chối'));
                                        },
                                        child: Text(
                                          'Từ chối',
                                          style: TextStyle(color: Colors.red),
                                        ))
                                  ]
                                : [
                                    res[index].status == 1
                                        ? SizedBox(
                                            width: 60,
                                            child: Text(
                                              'Đã phê duyệt',
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          )
                                        : SizedBox(
                                            width: 60,
                                            child: Text(
                                              'Đã kết thúc',
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                    res[index].status == 1
                                        ? TextButton(
                                            onPressed: () {
                                              Book a = res[index].book;
                                              a.changeStatus();
                                              a.setId(res[index].bookId);
                                              updateBook(a);
                                              Request re = res[index];
                                              re.changeStatus(2);
                                              updateRequest(re);
                                              updateMyRequest();
                                            },
                                            child: Text(
                                              'Kết thúc',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ))
                                        : SizedBox()
                                  ],
                          )
                        ],
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
