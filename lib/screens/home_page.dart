/*
Name: Home Page
Last Modified: 12/7/21
Description: Màn hình chính
Notes: 
*/

import 'package:exchange/screens/history.dart';
import 'package:exchange/screens/my_requests.dart';
import 'package:exchange/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../classes/book.dart';
import '../constants.dart';
import '../components/booklist.dart';
import '../database.dart';
import '../classes/user.dart';
import 'book_detail.dart';
import 'requests.dart';
import 'package:unorm_dart/unorm_dart.dart' as unorm;
import 'package:tiengviet/tiengviet.dart';

class HomePage extends StatefulWidget {
  final User mainProfile;
  const HomePage({Key key, this.mainProfile}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> books = [];
  List<User> users = [];
  List<Book> sachKHKT = [];
  List<Book> sachCTPL = [];
  List<Book> sachVHNT = [];
  List<Book> sachVHXH = [];
  List<Book> sachGT = [];
  List<Book> sachTT = [];
  List<Book> sachTL = [];
  List<Book> sachTN = [];
  User myProfile;
  void updateBooks() {
    books = [];
    sachKHKT = [];
    sachCTPL = [];
    sachVHNT = [];
    sachVHXH = [];
    sachGT = [];
    sachTT = [];
    sachTL = [];
    sachTN = [];
    getAllBooks().then((books) => this.setState(() {
          this.books = books;
          for (Book book in books) {
            if (book.owner != widget.mainProfile.id && book.status == 0) {
              switch (book.category) {
                case 0:
                  sachCTPL.add(book);
                  break;
                case 1:
                  sachKHKT.add(book);
                  break;
                case 2:
                  sachVHNT.add(book);
                  break;
                case 3:
                  sachVHXH.add(book);
                  break;
                case 4:
                  sachGT.add(book);
                  break;
                case 5:
                  sachTT.add(book);
                  break;
                case 6:
                  sachTL.add(book);
                  break;
                case 7:
                  sachTN.add(book);
                  break;
                default:
                  break;
              }
            }
          }
        }));
  }

  void updateUser() {
    getAllUsers().then((users) => this.setState(() {
          this.users = users;
        }));
    getProfile(widget.mainProfile.id).then((value) => this.setState(() {
          this.myProfile = value;
        }));
  }

  @override
  void initState() {
    updateUser();
    updateBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (myProfile == null) myProfile = widget.mainProfile;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(color: mainColor),
            child: ListView(children: [
              DrawerHeader(
                decoration: BoxDecoration(color: mainColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(myProfile.avatar),
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      myProfile.fullname,
                      style:
                          GoogleFonts.roboto(fontSize: 20, color: Colors.white),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              Card(
                color: mainColor,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile(
                                    userId: myProfile.id,
                                    id: myProfile.id,
                                  ))).then((_) => refresh());
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.account_box,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Hồ sơ của tôi',
                        style: GoogleFonts.roboto(
                            fontSize: 20, color: Colors.white),
                      ),
                    )),
              ),
              Card(
                color: mainColor,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Noti(
                                    userId: myProfile.id,
                                  ))).then((_) => refresh());
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.auto_stories,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Danh sách yêu cầu',
                        style: GoogleFonts.roboto(
                            fontSize: 20, color: Colors.white),
                      ),
                    )),
              ),
              Card(
                color: mainColor,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyRequest(
                                    userId: myProfile.id,
                                  ))).then((_) => refresh());
                    },
                    child: ListTile(
                        leading: Icon(
                          Icons.featured_play_list,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Yêu cầu của tôi',
                          style: GoogleFonts.roboto(
                              fontSize: 20, color: Colors.white),
                        ))),
              ),
              Card(
                color: mainColor,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => History(
                                    usedId: myProfile.id,
                                  ))).then((_) => refresh());
                    },
                    child: ListTile(
                        leading: Icon(
                          Icons.history,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Lịch sử trao đổi',
                          style: GoogleFonts.roboto(
                              fontSize: 20, color: Colors.white),
                        ))),
              ),
              Card(
                color: mainColor,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Đăng xuất',
                          style: GoogleFonts.roboto(
                              fontSize: 20, color: Colors.white),
                        ))),
              ),
            ]),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            IconButton(
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => SearchResults(
                  //               userId: myProfile.id,
                  //             )));
                  showSearch(
                      context: context,
                      delegate: Searching(books, widget.mainProfile.id));
                },
                icon: Icon(Icons.search))
          ],
          centerTitle: true,
          title: Text(
            'Xin chào ${myProfile.fullname == 'Chưa cập nhật' ? 'bạn' : myProfile.getName()}',
            style: titleStyle,
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              makeTitle('Văn học nghệ thuật', null, null),
              BookListWidget(
                renderUser: true,
                refresh: refresh,
                books: sachVHNT,
                width: width,
                height: height,
                userId: myProfile.id,
              ),
              SizedBox(height: 40),
              makeTitle('Khoa học công nghệ – Kinh tế', null, null),
              BookListWidget(
                renderUser: true,
                refresh: refresh,
                books: sachKHKT,
                width: width,
                height: height,
                userId: myProfile.id,
              ),
              SizedBox(height: 40),
              makeTitle('Truyện, Tiểu thuyết', null, null),
              BookListWidget(
                renderUser: true,
                refresh: refresh,
                books: sachTT,
                width: width,
                height: height,
                userId: myProfile.id,
              ),
              SizedBox(height: 40),
              makeTitle('Chính trị - Pháp luật', null, null),
              BookListWidget(
                renderUser: true,
                refresh: refresh,
                books: sachCTPL,
                width: width,
                height: height,
                userId: myProfile.id,
              ),
              SizedBox(height: 40),
              makeTitle('Giáo trình', null, null),
              BookListWidget(
                renderUser: true,
                refresh: refresh,
                books: sachGT,
                width: width,
                height: height,
                userId: myProfile.id,
              ),
              SizedBox(height: 40),
              makeTitle('Văn hóa xã hội – Lịch sử', null, null),
              BookListWidget(
                renderUser: true,
                refresh: refresh,
                books: sachVHXH,
                width: width,
                height: height,
                userId: myProfile.id,
              ),
              SizedBox(height: 40),
              makeTitle('Tâm lý, tâm linh, tôn giáo', null, null),
              BookListWidget(
                renderUser: true,
                refresh: refresh,
                books: sachTL,
                width: width,
                height: height,
                userId: myProfile.id,
              ),
              SizedBox(height: 40),
              makeTitle('Thiếu nhi', null, null),
              BookListWidget(
                renderUser: true,
                refresh: refresh,
                books: sachTN,
                width: width,
                height: height,
                userId: myProfile.id,
              ),
            ],
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
                      'see all',
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
  void refresh() {
    print('Refresh màn hình chính');
    updateBooks();
    updateUser();
  }
}

class Searching extends SearchDelegate {
  final List<Book> books;
  final String userId;
  Searching(this.books, this.userId);
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back));
  }

  List<Book> suggestions;
  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
              width: 30,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    suggestions[index].url,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return Image.network(defaultCover, fit: BoxFit.cover);
                    },
                    fit: BoxFit.cover,
                  ))),
          title: Text('${suggestions[index].title}',
              style: GoogleFonts.roboto(fontSize: 20),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Detail(
                          renderUser: true,
                          userId: userId,
                          book: suggestions[index],
                        )));
          },
        );
      },
      itemCount: suggestions.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    suggestions = [];
    if (query != '') {
      suggestions.addAll(books.where((element) =>
          TiengViet.parse(unorm.nfc(element.title.toLowerCase()))
              .contains(TiengViet.parse(unorm.nfc(query.toLowerCase()))) &&
          element.owner != userId &&
          element.status != 2));
    } else
      suggestions = [];
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
              width: 30,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    suggestions[index].url,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return Image.network(defaultCover, fit: BoxFit.cover);
                    },
                    fit: BoxFit.cover,
                  ))),
          title: Text(suggestions[index].title,
              style: GoogleFonts.roboto(fontSize: 20),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Detail(
                          renderUser: true,
                          userId: userId,
                          book: suggestions[index],
                        )));
          },
        );
      },
      itemCount: suggestions.length,
    );
  }
}
