/*
Name: Sign in
Last Modified: 7/7/21
Description: Màn hình đăng nhập
Notes: 
*/

import 'package:exchange/database.dart';
import 'package:exchange/screens/home_page.dart';
import 'package:exchange/screens/signup.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../classes/user.dart';

class Signin extends StatefulWidget {
  const Signin({
    Key key,
  }) : super(key: key);
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  String _inputUserName = '';
  AutovalidateMode _valid;
  String _inputPassword = '';
  TextEditingController _controllerUser = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  User myProfile;
  @override
  void initState() {
    _valid = AutovalidateMode.onUserInteraction;
    super.initState();
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
              height: height * 1 / 3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: greatingText1),
              )),
          Container(
              width: width,
              height: height * 2 / 3,
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
                            if (myProfile == null) {
                              return 'Tên người dùng không tồn tại!';
                            } else
                              return null;
                          }
                        },
                        controller: _controllerUser,
                        onChanged: (userInputUserName) =>
                            setState(() => _inputUserName = userInputUserName),
                        decoration: InputDecoration(
                            labelText: 'Tên người dùng',
                            hintText: 'Nhập tên người dùng',
                            labelStyle: bigFieldTitle),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value.length > maxPasswordLength ||
                              value.length < minPasswordLength) {
                            return 'Nhập vào 6-32 ký tự.';
                          } else if (myProfile != null) {
                            if (_inputPassword != myProfile.password) {
                              return 'Mật khẩu không đúng';
                            } else
                              return null;
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
                      SizedBox(height: 40),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage(
                                            mainProfile: myProfile,
                                          )));
                              _controllerUser.clear();
                              _controllerPassword.clear();
                              setState(() {
                                _valid = AutovalidateMode.onUserInteraction;
                              });
                            } else {
                              setState(() {
                                _valid = AutovalidateMode.onUserInteraction;
                              });
                            }
                          },
                          child: Text('Đăng nhập', style: bigButtonStyle),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Bạn chưa có tài khoản? '),
                          GestureDetector(
                            child: Text(
                              'Đăng ký ngay',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                  color: mainColor),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Signup()));
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
