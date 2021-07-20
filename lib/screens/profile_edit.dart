/*
Name: Profile Editing
Last Modified: 7/7/21
Description: Màn hình chỉnh sửa thông tin người dùng
Notes: 
*/

import 'package:exchange/constants.dart';
import 'package:exchange/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../classes/user.dart';

class EditProfile extends StatefulWidget {
  final User profile;
  const EditProfile({
    Key key,
    @required this.profile,
  }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String oldName;
  String oldEmail;
  String oldPassword;
  int oldSex;
  String oldPhone;
  String oldAddress;
  String oldAvatar;
  String tempAvatar;
  String oldSchool;
  DateTime oldDob;

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPhone = TextEditingController();
  TextEditingController _controllerAddress = TextEditingController();
  TextEditingController _controllerAvatar = TextEditingController();
  TextEditingController _controllerSchool = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    oldName = widget.profile.fullname;
    oldEmail = widget.profile.email;
    oldPassword = widget.profile.password;
    oldSex = widget.profile.sex;
    oldPhone = widget.profile.phone;
    oldAddress = widget.profile.address;
    oldAvatar = widget.profile.avatar;
    oldSchool = widget.profile.school;
    oldDob = DateFormat('dd/MM/yyyy').parse(widget.profile.dob);
    tempAvatar = oldAvatar;
    _controllerName = TextEditingController(text: oldName);
    _controllerPassword = TextEditingController(text: oldPassword);
    _controllerEmail = TextEditingController(text: oldEmail);
    _controllerPhone = TextEditingController(text: oldPhone);
    _controllerAddress = TextEditingController(text: oldAddress);
    _controllerAvatar = TextEditingController(text: oldAvatar);
    _controllerSchool = TextEditingController(text: oldSchool);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final snackBar = SnackBar(
        duration: Duration(seconds: 1), content: Text('Đã lưu thay đổi'));
    return Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: Colors.white,
        //AppBar
        appBar: AppBar(
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 1, color: Colors.black, spreadRadius: 1)
                  ],
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(tempAvatar),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ],
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            'Chỉnh sửa hồ sơ',
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
                    //Họ tên
                    TextFormField(
                      obscureText: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Họ tên không được bỏ trống';
                        }
                        return null;
                      },
                      controller: _controllerName,
                      onChanged: (value) => setState(() => oldName = value),
                      decoration: InputDecoration(
                        labelText: 'Họ tên',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    //Password
                    TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (value.length > maxPasswordLength ||
                            value.length < minPasswordLength) {
                          return 'Nhập vào 6-32 ký tự.';
                        } else
                          return null;
                      },
                      controller: _controllerPassword,
                      onChanged: (value) => setState(() => oldPassword = value),
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    //Sex
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Giới tính',
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
                            value: oldSex,
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
                                oldSex = value;
                              });
                            },
                            items: List.generate(
                                3,
                                (index) => DropdownMenuItem(
                                    value: index, child: Text(getSex(index))))),
                      ],
                    ),
                    //DOB
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Ngày sinh',
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
                        GestureDetector(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: oldDob,
                              firstDate: DateTime(1960),
                              lastDate: DateTime.now(),
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme:
                                        ColorScheme.light(primary: mainColor),
                                    buttonTheme: ButtonThemeData(
                                        textTheme: ButtonTextTheme.primary),
                                  ),
                                  child: child,
                                );
                              },
                            ).then((value) => this.setState(() {
                                  if (value != null) this.oldDob = value;
                                }));
                          },
                          child: Text(
                            DateFormat('dd/MM/yyyy').format(oldDob),
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                    //Phone
                    TextFormField(
                      obscureText: false,
                      validator: (value) {
                        Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(value))
                          return 'Sai định dạng';
                        else
                          return null;
                      },
                      keyboardType: TextInputType.number,
                      controller: _controllerPhone,
                      onChanged: (value) => setState(() => oldPhone = value),
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    //Email
                    TextFormField(
                      obscureText: false,
                      validator: (value) {
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!emailValid) {
                          return 'Email không hợp lệ.';
                        } else
                          return null;
                      },
                      controller: _controllerEmail,
                      onChanged: (value) => setState(() => oldEmail = value),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    //Address
                    TextFormField(
                      obscureText: false,
                      validator: (value) {
                        return null;
                      },
                      controller: _controllerAddress,
                      onChanged: (value) => setState(() => oldAddress = value),
                      decoration: InputDecoration(
                        labelText: 'Địa chỉ',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    //Avatar
                    TextFormField(
                      obscureText: false,
                      controller: _controllerAvatar,
                      onChanged: (value) => setState(() => oldAvatar = value),
                      onEditingComplete: () {
                        setState(() {
                          tempAvatar = oldAvatar;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Link ảnh đại diện',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    //School
                    TextFormField(
                      obscureText: false,
                      controller: _controllerSchool,
                      onChanged: (value) => setState(() => oldSchool = value),
                      decoration: InputDecoration(
                        labelText: 'Trường',
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
                                      User user = User(
                                          avatar: oldAvatar,
                                          fullname: oldName,
                                          phone: oldPhone,
                                          password: oldPassword,
                                          dob: DateFormat('dd/MM/yyyy')
                                              .format(oldDob),
                                          address: oldAddress,
                                          school: oldSchool,
                                          sex: oldSex,
                                          date: widget.profile.date,
                                          email: oldEmail);
                                      user.setId(widget.profile.id);
                                      updateUser(user);
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
