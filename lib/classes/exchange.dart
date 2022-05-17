class Exchange {
  String id;
  String requestId;
  String from;
  String to;
  String fromUser;
  String toUser;
  String title;
  String fromId;
  void setFromId(String id) {
    this.fromId = id;
  }

  void setTo(String to) {
    this.to = to;
  }

  void setId(String id) {
    this.id = id;
  }

  void setTitle(String id) {
    this.title = id;
  }

  void setFromUser(String name) {
    this.fromUser = name;
  }

  void setToUser(String name) {
    this.toUser = name;
  }

  Exchange({this.requestId, this.from, this.to});

  Exchange.fromJson(Map<String, dynamic> json) {
    requestId = json['request_id'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_id'] = this.requestId;
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}

Exchange createExchange(record) {
  Map<String, dynamic> attributes = {'from': '', 'to': '', 'request_id': ''};
  record.forEach((key, value) => {attributes[key] = value});
  Exchange ex = Exchange.fromJson(attributes);
  return ex;
}
