class Book {
  String id;
  String author;
  int category;
  int condition;
  String date;
  String description;
  int npages;
  String owner;
  int status;
  String title;
  String url;

  void changeStatus() {
    if (this.status == 1) {
      this.status = 0;
    } else
      this.status = 1;
  }

  Book(
      {this.author,
      this.category,
      this.condition,
      this.date,
      this.description,
      this.npages,
      this.owner,
      this.status,
      this.title,
      this.url});
  void setId(String id) {
    this.id = id;
  }

  void setStatus(int id) {
    this.status = id;
  }

  Book.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    category = json['category'];
    condition = json['condition'];
    date = json['date'];
    description = json['description'];
    npages = json['npages'];
    owner = json['owner'];
    status = json['status'];
    title = json['title'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['category'] = this.category;
    data['condition'] = this.condition;
    data['date'] = this.date;
    data['description'] = this.description;
    data['npages'] = this.npages;
    data['owner'] = this.owner;
    data['status'] = this.status;
    data['title'] = this.title;
    data['url'] = this.url;
    return data;
  }
}

Book createBook(record) {
  Map<String, dynamic> attributes = {
    'title': '',
    'author': '',
    'category': 1,
    'condition': 0,
    'date': '',
    'description': '',
    'npages': 0,
    'owner': '',
    'status': 0,
    'url': ''
  };
  record.forEach((key, value) => {attributes[key] = value});
  Book book = Book.fromJson(attributes);
  return book;
}

String getCat(int cat) {
  List myCategory = [
    'Chính trị - Pháp luật',
    'Khoa học công nghệ – Kinh tế',
    'Văn học nghệ thuật',
    'Văn hóa xã hội – Lịch sử',
    'Giáo trình',
    'Truyện - Tiểu thuyết',
    'Tâm lý - Tâm linh - Tôn giáo',
    'Sách thiếu nhi'
  ];
  return myCategory[cat];
}

String getCond(int cond) {
  List myCond = ['Rất cũ', 'Cũ', 'Trung Bình', 'Khá mới', 'Rất mới'];
  return myCond[cond];
}
