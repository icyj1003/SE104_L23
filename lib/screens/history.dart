/*
Name: History
Last Modified: 12/7/21
Description: Màn hình lịch sử trao đổi
Notes: 
*/
import 'package:exchange/classes/exchange.dart';
import 'package:exchange/constants.dart';
import 'package:exchange/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class History extends StatefulWidget {
  final String usedId;
  const History({Key key, @required this.usedId}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Exchange> exs = [];
  List<Exchange> shows = [];
  String button = "Chọn";
  DateTime now = DateTime.now();
  void refresh() {
    getMyExchange(widget.usedId).then((value) => this.setState(() {
          this.exs = value;
        }));
  }

  @override
  void initState() {
    shows = [];
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Trao đổi theo tháng',
            style: GoogleFonts.montserrat(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      showMonthPicker(
                        context: context,
                        initialDate: now,
                        locale: Locale("en"),
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            shows = [];
                            now = date;

                            for (Exchange ex in exs) {
                              DateTime temp =
                                  DateFormat('dd/MM/yyyy').parse(ex.from);
                              if (temp.month == now.month &&
                                  temp.year == now.year) {
                                shows.add(ex);
                              }
                            }
                            button = now.month.toString() +
                                " - " +
                                now.year.toString() +
                                ": Có ${shows.length} trao đổi";
                          });
                        }
                      });
                    },
                    child: Text(
                      button,
                      style: titleStyle,
                    )),
                Column(
                  children: List.generate(
                      shows.length,
                      (index) => Card(
                              child: ListTile(
                            leading: shows[index].fromId == widget.usedId
                                ? Icon(
                                    Icons.south_west,
                                    size: 50,
                                    color: Color(0xff4d908e),
                                  )
                                : Icon(
                                    Icons.north_east,
                                    size: 50,
                                    color: Color(0xffa01a58),
                                  ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(shows[index].to != ""
                                    ? "${shows[index].from} đến ${shows[index].to}"
                                    : shows[index].from),
                                Text(shows[index].fromId == widget.usedId
                                    ? "Nhận từ ${shows[index].toUser}"
                                    : "Trao đến ${shows[index].fromUser}"),
                                Text(
                                  shows[index].title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ))),
                )
              ],
            ),
          ),
        ));
  }
}
