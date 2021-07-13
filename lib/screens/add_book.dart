/*
Name: Book Adding
Last Modified: 7/7/21
Description: Màn hình thêm sách
Notes: 
*/

import 'package:exchange/constants.dart';
import 'package:exchange/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../classes/book.dart';

class AddBook extends StatefulWidget {
  final String userId;
  const AddBook({
    Key key,
    @required this.userId,
  }) : super(key: key);

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final _formKey = GlobalKey<FormState>();
  String oldTitle;
  int oldnpages;
  String oldAuthor;
  int oldCategory;
  String oldDescription;
  String oldUrl;
  String tempUrl;
  int oldCond;
  @override
  void initState() {
    oldTitle = '';
    oldnpages = 0;
    oldAuthor = '';
    oldCategory = 0;
    oldDescription = '';
    oldUrl = defaultCover;
    tempUrl = defaultCover;
    oldCond = 4;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final snackBar = SnackBar(content: Text('Đã thêm thành công'));
    return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.white,
        //AppBar
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            'Thêm sách',
            style: titleStyle,
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context)),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(children: [
                    Row(
                      children: [
                        Container(
                            width: 130,
                            height: 208,
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
                                  tempUrl,
                                  fit: BoxFit.cover,
                                ))),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            //Tiêu đề
                            SizedBox(
                              height: 60,
                              width: width - 130 - 20 * 3,
                              child: TextFormField(
                                obscureText: false,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Tiêu đề không được bỏ trống';
                                  } else
                                    return null;
                                },
                                onChanged: (value) =>
                                    setState(() => oldTitle = value),
                                decoration: InputDecoration(
                                  labelText: 'Tiêu đề',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                            //Author
                            SizedBox(
                              height: 60,
                              width: width - 130 - 20 * 3,
                              child: TextFormField(
                                obscureText: false,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Tên tác giả không được bỏ trống';
                                  } else
                                    return null;
                                },
                                onChanged: (value) =>
                                    setState(() => oldAuthor = value),
                                decoration: InputDecoration(
                                  labelText: 'Tác giả',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                            //Số trang
                            SizedBox(
                              height: 60,
                              width: width - 130 - 20 * 3,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Vui lòng nhập vào số trang';
                                  } else
                                    return null;
                                },
                                obscureText: false,
                                onChanged: (value) => setState(
                                    () => oldnpages = int.parse(value)),
                                decoration: InputDecoration(
                                  labelText: 'Số trang',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    //Condition
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Tình trạng sách',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        DropdownButton(
                            value: oldCond,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 20,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 1,
                              color: Colors.black,
                            ),
                            onChanged: (value) {
                              setState(() {
                                oldCond = value;
                              });
                            },
                            items: List.generate(
                                5,
                                (index) => DropdownMenuItem(
                                    value: index,
                                    child: Text(getCond(index))))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Thể loại',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        DropdownButton(
                            value: oldCategory,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 20,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 1,
                              color: Colors.black,
                            ),
                            onChanged: (value) {
                              setState(() {
                                oldCategory = value;
                              });
                            },
                            items: List.generate(
                                8,
                                (index) => DropdownMenuItem(
                                    value: index, child: Text(getCat(index))))),
                      ],
                    ),
                    //Description
                    TextFormField(
                      obscureText: false,
                      onChanged: (value) =>
                          setState(() => oldDescription = value),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    //Url
                    TextFormField(
                      obscureText: false,
                      onChanged: (value) => setState(() => oldUrl = value),
                      onEditingComplete: () {
                        setState(() {
                          if (oldUrl != '') {
                            tempUrl = oldUrl;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Link ảnh bìa sách',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //Nút
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: (width - 60) / 2,
                              decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'HUỶ',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ))),
                          Container(
                              width: (width - 60) / 2,
                              decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    final isValid =
                                        _formKey.currentState.validate();
                                    if (isValid) {
                                      _formKey.currentState.save();
                                      print('Tạo id');
                                      print("Title: $oldTitle");
                                      print(oldAuthor);
                                      print(oldnpages);
                                      print(oldCond + 1);
                                      print(oldCategory);
                                      print(oldDescription);
                                      print(oldUrl);
                                      Book editedBook = Book(
                                          author: oldAuthor,
                                          title: oldTitle,
                                          npages: oldnpages,
                                          condition: oldCond + 1,
                                          category: oldCategory,
                                          description: oldDescription.isEmpty
                                              ? 'Không có mô tả'
                                              : oldDescription,
                                          url: oldUrl,
                                          status: 0,
                                          owner: widget.userId,
                                          date: DateFormat('dd/MM/yyyy')
                                              .format(DateTime.now()));
                                      addBook(editedBook);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    'LƯU',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ))),
                        ])
                  ]),
                ),
              ]),
            ),
          ),
        ));
  }

  Widget getField(String title, String content) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.openSans(color: Colors.white, fontSize: 15)),
          Text(content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600))
        ]);
  }
}
