import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static var db, userCollection;
  static connect() async {
    db = await Db.create(
        "mongodb+srv://D3HB:flutter@cluster0.r0zom.mongodb.net/phoneshop"); // Thay thế connection string của bạn
    await db.open();
    userCollection = db.collection("users"); // Thay thế tên collection của bạn
  }

  static Future<String> insert(String username, String password) async {
    try {
      var user = await userCollection.findOne({"username": username});
      if (user != null) {
        return "exists";
      }
      await userCollection.insert({
        "username": username,
        "password": password,
      });
      return "success";
    } catch (e) {
      return "error";
    }
  }

  static Future<bool> checkAdmin(String username, String password) async {
    try {
      var user = await userCollection.findOne({
        "username": username,
        "password": password,
      });
      if (user != null) {
        if (user["role"] == "admin") {
          return true;
        }
        return false;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate(String username, String password) async {
    try {
      var user = await userCollection.findOne({
        "username": username,
        "password": password,
      });
      if (user != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
