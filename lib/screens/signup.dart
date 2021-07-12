/*
Name: Sign in
Last Modified: 7/7/21
Description: Màn hình đăng ký
Notes: 
*/

import 'package:exchange/classes/user.dart';
import 'package:exchange/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../database.dart';

class Signup extends StatefulWidget {
  const Signup({Key key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  String _inputUserName = '';
  String _inputEmail = '';
  String _inputPassword = '';
  String _inputPhone = '';
  String _inputName = '';
  int _inputSex = 0;
  User myProfile;
  AutovalidateMode _valid;
  DateTime _dob = DateTime.now();
  TextEditingController _controllerUser = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerPasswordRepeat = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerPhone = TextEditingController();
  @override
  void initState() {
    _valid = AutovalidateMode.onUserInteraction;
    super.initState();
  }

  _sackBar(String content) {
    return SnackBar(content: Text(content));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: mainColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
              width: width,
              height: height * 1 / 6,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: greatingText2))),
          Container(
              width: width,
              height: height * 5 / 6,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Form(
                autovalidateMode: _valid,
                key: _formKey,
                child: ListView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    children: [
                      // * Tên đăng nhập
                      TextFormField(
                        validator: (value) {
                          if (value.length > maxUserNameLength ||
                              value.length < minUserNameLength) {
                            return 'Nhập vào 6-32 ký tự.';
                          } else {
                            getProfile(_inputUserName)
                                .then((value) => this.setState(() {
                                      this.myProfile = value;
                                    }));
                            if (myProfile != null)
                              return 'Tên người dùng đã tồn tại';
                            else
                              return null;
                          }
                        },
                        controller: _controllerUser,
                        onChanged: (userInputUserName) {
                          setState(() {
                            _inputUserName = userInputUserName;
                          });
                          getProfile(_inputUserName)
                              .then((value) => this.setState(() {
                                    this.myProfile = value;
                                  }));
                        },
                        decoration: InputDecoration(
                            labelText: 'Tên người dùng',
                            hintText: 'Nhập tên người dùng',
                            labelStyle: bigFieldTitle),
                      ),
                      // * Email
                      TextFormField(
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
                        onChanged: (userInputEmail) =>
                            setState(() => _inputEmail = userInputEmail),
                        decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Nhập địa chỉ email của bạn',
                            labelStyle: bigFieldTitle),
                      ),
                      // * Họ tên
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Họ tên không được bỏ trống';
                          } else
                            return null;
                        },
                        controller: _controllerName,
                        onChanged: (userInputName) =>
                            setState(() => _inputName = userInputName),
                        decoration: InputDecoration(
                            labelText: 'Họ và tên',
                            hintText: 'Nhập vào họ và tên của bạn',
                            labelStyle: bigFieldTitle),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // * GIỚI TÍNH + NGÀY SINH
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ngày sinh', style: bigFieldTitle),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: _dob,
                                    firstDate: DateTime(1960),
                                    lastDate: DateTime(2025),
                                    builder:
                                        (BuildContext context, Widget child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          colorScheme: ColorScheme.light(
                                              primary: mainColor),
                                          buttonTheme: ButtonThemeData(
                                              textTheme:
                                                  ButtonTextTheme.primary),
                                        ),
                                        child: child,
                                      );
                                    },
                                  ).then((value) => this.setState(() {
                                        if (value != null) this._dob = value;
                                      }));
                                },
                                child: Text(
                                  DateFormat('dd/MM/yyyy').format(_dob),
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Giới tính', style: bigFieldTitle),
                              SizedBox(
                                width: 20,
                              ),
                              DropdownButton(
                                  value: _inputSex,
                                  icon: const Icon(Icons.arrow_downward),
                                  iconSize: 15,
                                  elevation: 10,
                                  style: const TextStyle(color: Colors.black),
                                  onChanged: (value) {
                                    setState(() {
                                      _inputSex = value;
                                    });
                                  },
                                  items: List.generate(
                                      3,
                                      (index) => DropdownMenuItem(
                                          value: index,
                                          child: Text(
                                            getSex(index),
                                            style: GoogleFonts.roboto(
                                                fontSize: 15),
                                          )))),
                            ],
                          ),
                          SizedBox(
                            width: 30,
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
                        onChanged: (value) =>
                            setState(() => _inputPhone = value),
                        decoration: InputDecoration(
                            labelText: 'Số điện thoại',
                            labelStyle: bigFieldTitle),
                      ),
                      //* Mật khẩu
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
                        onChanged: (userInputPassword) =>
                            setState(() => _inputPassword = userInputPassword),
                        decoration: InputDecoration(
                            labelText: 'Mật khẩu',
                            hintText: 'Nhập mật khẩu',
                            labelStyle: bigFieldTitle),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value != _inputPassword) {
                            return 'Mật khẩu nhập lại không khớp';
                          } else
                            return null;
                        },
                        controller: _controllerPasswordRepeat,
                        decoration: InputDecoration(
                            labelText: 'Nhập lại mật khẩu',
                            hintText: 'Nhập mật khẩu',
                            labelStyle: bigFieldTitle),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: width,
                        height: height * 0.075,
                        decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: TextButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            final isValid = _formKey.currentState.validate();
                            if (isValid) {
                              _formKey.currentState.save();
                              User newUser = User(
                                  fullname: _inputName,
                                  dob: DateFormat('dd/MM/yyyy').format(_dob),
                                  date: DateFormat('dd/MM/yyyy')
                                      .format(DateTime.now()),
                                  password: _inputPassword,
                                  email: _inputEmail,
                                  sex: _inputSex,
                                  phone: _inputPhone,
                                  address: 'Chưa cập nhật',
                                  school: 'Chưa cập nhật',
                                  avatar: defaultAvatar);
                              newUser.setId(_inputUserName);
                              addUser(newUser);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  _sackBar('Đăng ký thành công!'));
                              Navigator.pop(context);
                              _controllerEmail.clear();
                              _controllerPassword.clear();
                              _controllerPasswordRepeat.clear();
                              _controllerUser.clear();
                              _controllerName.clear();
                              setState(() {
                                _valid = AutovalidateMode.onUserInteraction;
                              });
                            } else {
                              setState(() {
                                _valid = AutovalidateMode.onUserInteraction;
                              });
                            }
                          },
                          child: Text(
                            'Đăng ký',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Bạn đã có tài khoản? '),
                          GestureDetector(
                            child: Text(
                              'Đăng nhập',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                  color: mainColor),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Signin()));
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ]),
              ))
        ],
      )),
    );
  }
}
