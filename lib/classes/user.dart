class User {
  String password;
  String fullname;
  int sex;
  String id;
  String dob;
  String phone;
  String email;
  String address;
  String avatar;
  String school;
  String date;

  User(
      {this.password,
      this.fullname,
      this.sex,
      this.dob,
      this.phone,
      this.email,
      this.address,
      this.avatar,
      this.school,
      this.date});
  void setId(String id) {
    this.id = id;
  }

  String getName() {
    List fname = this.fullname.split(' ');
    return fname[fname.length - 1];
  }

  User.fromJson(Map<String, dynamic> json) {
    password = json['password'];
    fullname = json['fullname'];
    sex = json['sex'];
    dob = json['dob'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    avatar = json['avatar'];
    school = json['school'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    data['fullname'] = this.fullname;
    data['sex'] = this.sex;
    data['dob'] = this.dob;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['address'] = this.address;
    data['avatar'] = this.avatar;
    data['school'] = this.school;
    data['date'] = this.date;
    return data;
  }
}

User createUser(record) {
  Map<String, dynamic> attributes = {
    'address': '',
    'avatar': '',
    'dob': '',
    'email': '',
    'fullname': '',
    'password': '',
    'phone': '',
    'school': '',
    'sex': 0
  };
  record.forEach((key, value) => {attributes[key] = value});
  User user = User.fromJson(attributes);
  return user;
}

String getSex(int sex) {
  List mySex = ['Nữ', 'Nam', 'Khác'];
  return mySex[sex];
}
