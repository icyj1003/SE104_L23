/*
Name: My Request
Last Modified: 12/7/21
Description: Màn hình yêu cầu đã gửi
Notes: 
*/

import 'package:exchange/constants.dart';
import 'package:exchange/classes/request.dart';
import 'package:exchange/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../database.dart';
import 'book_detail.dart';

class MyRequest extends StatefulWidget {
  final String userId;
  const MyRequest({Key key, this.userId}) : super(key: key);

  @override
  _MyRequestState createState() => _MyRequestState();
}

class _MyRequestState extends State<MyRequest> {
  List<Request> res = [];
  void updateMyRequest() {
    getMyRequest(widget.userId).then((value) => this.setState(() {
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

  _snackBar(String content) => SnackBar(content: Text(content));

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
          'Yêu cầu đã gửi: ${res.length}',
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
                                              id: res[index].book.owner)))
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
                                'Bạn muốn của ${res[index].user.getName()}',
                                style: GoogleFonts.lato(fontSize: 12),
                              ),
                              GestureDetector(
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
                                child: SizedBox(
                                    width: 200,
                                    child: Text(
                                      '${res[index].book.title}',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.lato(fontSize: 16),
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              if (res[index].status == 0)
                                TextButton(
                                    onPressed: () {
                                      Request re = res[index];
                                      re.changeStatus(2);
                                      updateRequest(re);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(_snackBar(
                                              'Đã huỷ yêu cầu trao đổi!'));
                                      updateMyRequest();
                                    },
                                    child: SizedBox(
                                      width: 50,
                                      child: Text(
                                        'Huỷ yêu cầu',
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ))
                              else
                                SizedBox(
                                  width: 60,
                                  child: Text(
                                    res[index].status == 1
                                        ? 'Đã chấp nhận'
                                        : "Đã huỷ",
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: res[index].status == 1
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                )
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
