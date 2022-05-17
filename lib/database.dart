/*
Name: Database
Last Modified: 12/7/21
Description: Khai báo các phương thức giao tiếp với cơ sở dữ liệu
Notes: 
*/

import 'package:exchange/classes/exchange.dart';
import 'package:exchange/classes/favorite.dart';
import 'package:exchange/classes/user.dart';
import 'package:exchange/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'classes/book.dart';
import 'classes/request.dart';

final databaseRef = FirebaseDatabase(databaseURL: databaseUrl).reference();
//BOOK
Future<List<Book>> getAllBooks() async {
  DataSnapshot dataSnapshot = await databaseRef.child('books/').once();
  List<Book> books = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      Book book = createBook(value);
      book.setId(key);
      books.add(book);
    });
  }
  return books;
}

Future<Book> getBook(String id) async {
  DataSnapshot dataSnapshot = await databaseRef.child('books/$id').once();
  if (dataSnapshot.value != null) {
    Book book = createBook(dataSnapshot.value);
    book.setId(id);
    return book;
  } else
    return null;
}

void updateBook(Book book) {
  databaseRef.child('books/${book.id}').update(book.toJson());
}

void addBook(Book book) {
  databaseRef.child('books/').push().set(book.toJson());
}

void deleteBook(String id) {
  databaseRef.child('books/$id').remove();
}

//USER
Future<List<User>> getAllUsers() async {
  DataSnapshot dataSnapshot = await databaseRef.child('users/').once();
  List<User> users = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      User user = createUser(value);
      user.setId(key);
      users.add(user);
    });
  }
  return users;
}

void updateUser(User user) {
  databaseRef.child('users/${user.id}').update(user.toJson());
}

void addUser(User user) {
  databaseRef.child('users/${user.id}').set(user.toJson());
}

Future<User> getProfile(String id) async {
  DataSnapshot dataSnapshot = await databaseRef.child('users/$id').once();
  if (dataSnapshot.value != null) {
    User user = createUser(dataSnapshot.value);
    user.setId(id);
    return user;
  } else
    return null;
}

//FAVORITE
Future<List<Favorite>> getFavorites(String userId) async {
  DataSnapshot dataSnapshot = await databaseRef
      .child('favorite/')
      .orderByChild('user_id')
      .equalTo('$userId')
      .once();
  List<Favorite> favors = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      Favorite favor = createFavorite(value);
      favor.setId(key);
      favors.add(favor);
    });
  }
  return favors;
}

Future<void> favorite(String userId, String bookId) async {
  DataSnapshot dataSnapshot = await databaseRef
      .child('favorite/')
      .orderByChild('user_id')
      .equalTo(userId)
      .once();
  List<Favorite> favors = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      Favorite favor = createFavorite(value);
      favor.setId(key);
      favors.add(favor);
    });
  }
  for (Favorite favor in favors) {
    if (favor.bookId == bookId && favor.userId == userId) {
      databaseRef.child('favorite/${favor.id}').remove();
      return null;
    }
  }
  databaseRef
      .child('favorite/')
      .push()
      .set(Favorite(bookId: bookId, userId: userId).toJson());
}

// Request
Future<List<Request>> getAllRequest(String userId) async {
  DataSnapshot dataSnapshot = await databaseRef.child('request/').once();
  List<Request> exs = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) async {
      Request ex = createRequest(value);
      DataSnapshot abc = await databaseRef.child('books/${ex.bookId}').once();
      while (abc.value == null) {}
      if (abc.value['owner'].toString() == userId) {
        ex.setId(key);
        getBook(abc.key).then((value) {
          ex.setBook(createBook(abc.value));
          exs.add(ex);
        });
        getProfile(ex.userId).then((value) {
          ex.setUser(value);
        });
      }
    });
  }
  return exs;
}

Future<String> getTitle(String id) async {
  DataSnapshot data = await databaseRef.child('books/$id/title').once();
  return data.value;
}

Future<String> getName(String id) async {
  DataSnapshot data = await databaseRef.child('users/$id/fullname').once();
  return data.value;
}

Future<String> getUrl(String id) async {
  DataSnapshot data = await databaseRef.child('users/$id/avatar').once();
  return data.value;
}

void addRequest(Request ex) {
  databaseRef.child('request/').push().set(ex.toJson());
}

void deleteRequest(String id) {
  databaseRef.child('request/$id').remove();
}

void updateRequest(Request re) async {
  databaseRef.child('request/${re.id}').update(re.toJson());
  if (re.status == 2) {
    DataSnapshot snapshot = await databaseRef
        .child('exchanges')
        .orderByChild('request_id')
        .equalTo(re.id)
        .limitToFirst(1)
        .once();
    if (snapshot.value != null) {
      snapshot.value.forEach((key, value) {
        Exchange ex = createExchange(value);
        ex.setTo(DateFormat('dd/MM/yyyy').format(DateTime.now()));
        databaseRef.child('exchanges/$key').update(ex.toJson());
      });
    }
  }
}

Future<List<Request>> getMyRequest(String userId) async {
  DataSnapshot dataSnapshot = await databaseRef
      .child('request/')
      .orderByChild('user_id')
      .equalTo(userId)
      .once();
  List<Request> exs = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) async {
      Request ex = createRequest(value);
      DataSnapshot abc = await databaseRef.child('books/${ex.bookId}').once();
      while (abc.value == null) {}
      ex.setId(key);
      getBook(abc.key).then((value) {
        ex.setBook(createBook(abc.value));
        exs.add(ex);
      });
      getProfile(abc.value['owner']).then((value) {
        ex.setUser(value);
      });
    });
  }
  return exs;
}

Future<void> addExchange(Exchange exchange) async {
  databaseRef.child('exchanges/').push().set(exchange.toJson());
}

Future<List<Exchange>> getMyExchange(String userId) async {
  List<Exchange> exs = [];
  DataSnapshot dataSnapshot = await databaseRef
      .child('request/')
      .orderByChild('user_id')
      .equalTo(userId)
      .once();
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) async {
      if (value['status'] != 0) {
        DataSnapshot dataSnapshot1 = await databaseRef
            .child('exchanges/')
            .orderByChild('request_id')
            .equalTo(key)
            .once();
        if (dataSnapshot1.value != null) {
          dataSnapshot1.value.forEach((key1, value1) {
            Exchange ex = createExchange(value1);
            ex.setId(key1);
            getNameDb(userId).then((value) => ex.setFromUser(value));
            getOwner(value['book_id']).then((value) => ex.setToUser(value));
            ex.setFromId(userId);
            getTitle(value['book_id']).then((value) => ex.setTitle(value));
            exs.add(ex);
          });
        }
      }
    });
  }
  dataSnapshot = await databaseRef.child('request').once();
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) async {
      if (value['status'] != 0) {
        DataSnapshot dataSnapshot1 = await databaseRef
            .child('exchanges/')
            .orderByChild('request_id')
            .equalTo(key)
            .once();
        if (dataSnapshot1.value != null) {
          dataSnapshot1.value.forEach((key1, value1) async {
            DataSnapshot dataSnapshot2 = await databaseRef
                .child('books')
                .orderByKey()
                .equalTo(value['book_id'])
                .once();
            if (dataSnapshot2.value != null) {
              dataSnapshot2.value.forEach((key2, value2) {
                if (value2['owner'] == userId) {
                  Exchange ex = createExchange(value1);
                  ex.setId(key1);
                  getNameDb(userId).then((value) => ex.setToUser(value));
                  getNameDb(value['user_id'])
                      .then((value) => ex.setFromUser(value));
                  ex.setFromId(value['user_id']);
                  ex.setTitle(value2['title']);
                  exs.add(ex);
                }
              });
            }
          });
        }
      }
    });
  }
  return exs;
}

Future<String> getNameDb(String id) async {
  DataSnapshot snapshot = await databaseRef.child('users/$id').once();
  return snapshot.value['fullname'];
}

Future<String> getOwner(String id) async {
  String a = '';
  DataSnapshot snapshot2 = await databaseRef.child('books/$id/owner').once();
  if (snapshot2.value != null) {
    DataSnapshot snapshot =
        await databaseRef.child('users/${snapshot2.value}').once();
    a = snapshot.value['fullname'];
  }

  return a;
}
