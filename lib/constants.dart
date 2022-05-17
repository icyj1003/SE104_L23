/*
Name: Constances
Last Modified: 7/7/21
Description: Nơi khai báo các hằng số
Notes: 
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const mainColor = Color(0xff29414f);
Text greatingText1 = Text('Xin chào bạn!',
    style: GoogleFonts.montserrat(
        fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white));
Text greatingText2 = Text('Chào mừng bạn!',
    style: GoogleFonts.montserrat(
        fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white));

const int minUserNameLength = 6;
const int maxUserNameLength = 32;
const int minPasswordLength = 6;
const int maxPasswordLength = 32;
final TextStyle titleStyle = GoogleFonts.montserrat(
    fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600);
final TextStyle smallBookTitle = GoogleFonts.roboto(
    color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500);
final TextStyle smallAuthorName = GoogleFonts.roboto(
    color: Colors.black, fontSize: 10, fontWeight: FontWeight.w300);
final TextStyle bigAuthorName = GoogleFonts.roboto(
    color: Colors.white, fontSize: 20, fontWeight: FontWeight.w300);
final TextStyle smallDescription = GoogleFonts.robotoSlab(
    color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300);
final TextStyle bigBookTitle = GoogleFonts.roboto(
    color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500);
final TextStyle bigFieldTitle = GoogleFonts.montserrat(
    color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300);
final TextStyle bigButtonStyle = GoogleFonts.montserrat(
  color: Colors.white,
  fontSize: 30,
  fontWeight: FontWeight.w300,
);
const double book_width_ratio = 130 / 412;
const double book_height_ratio = 208 / 776;
const String defaultAvatar =
    'https://vnn-imgs-a1.vgcloud.vn/image1.ictnews.vn/_Files/2020/03/17/trend-avatar-1.jpg';
const String defaultCover =
    'https://image.freepik.com/free-vector/elegant-white-background-with-shiny-lines_1017-17580.jpg';
const String databaseUrl =
    'https://exchange-2a999-default-rtdb.asia-southeast1.firebasedatabase.app';
const String defaultAppLogo =
    'https://drive.google.com/file/d/1X55BTph4unJQOZTfAlB7yk2UVtU73Ox2/preview';
