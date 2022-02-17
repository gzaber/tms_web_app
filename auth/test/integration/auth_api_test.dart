//@dart=2.9

import 'package:auth/src/api/auth_api.dart';
import 'package:auth/src/domain/token.dart';
import 'package:auth/src/domain/user.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_test/flutter_test.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../helpers.dart';

final List<Map<String, dynamic>> emailsJSON = [
  {"email": 'admin@mail.com', "role": 'admin'},
  {"email": 'user@mail.com', "role": 'user'},
  {"email": 'test@mail.com', "role": 'user'}
];

final List<Map<String, dynamic>> usersJSON = [
  {
    "username": 'Admin',
    "email": 'admin@mail.com',
    "password": "\$2a\$10\$IsQjY7jvQihAYoY6RvYcNO7vv5SA4p2yI5oWKoNIWLAVxQIMWA35a",
    "role": 'admin',
    "isConfirmed": true
  },
  {
    "username": 'User',
    "email": 'user@mail.com',
    "password": 'password',
    "role": 'user',
    "isConfirmed": false
  }
];

void main() {
  http.Client client;
  AuthApi sut;
  String baseUrl;
  Db db;
  DbCollection emailCollection;
  DbCollection userCollection;
  List<Map<String, dynamic>> emails;
  List<Map<String, dynamic>> users;

  setUpAll(() async {
    baseUrl = API_URL;
    db = await Db.create(MONGO_URL);
    await db.open();
  });
  setUp(() async {
    client = http.Client();
    sut = AuthApi(baseUrl, client);
    emailCollection = db.collection('emails');
    userCollection = db.collection('users');
    await emailCollection.insertMany(emailsJSON);
    await userCollection.insertMany(usersJSON);
    emails = await emailCollection.find().toList();
    users = await userCollection.find().toList();
  });
  tearDown(() async {
    await db.dropCollection('emails');
    await db.dropCollection('users');
  });
  tearDownAll(() async {
    await db.close();
  });

  // ===============================================================================================
  group('register', () {
    test('should return user id when success', () async {
      // act
      var result = await sut.register("username", emails[2]['email'], "password");
      // assert
      expect(result.asValue.value, isNotEmpty);
    });
    test('should return error when failure', () async {
      // act
      var result = await sut.register("username", "unknown@mail.com", "password");
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong email format', () async {
      // act
      var result = await sut.register("username", "wrongemail.com", "password");
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when empty field', () async {
      // act
      var result = await sut.register("", emails[2]['email'], "password");
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });
  // ===============================================================================================
  group('login', () {
    test('should return token when success', () async {
      // act
      var result = await sut.login(users[0]['email'], 'password');
      // assert
      expect(result.asValue.value, isInstanceOf<Token>());
    });
    test('should return error when failure', () async {
      // act
      var result = await sut.login("unknown@mail.com", "password");
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong email format', () async {
      // act
      var result = await sut.login("wrongemail.com", "password");
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when empty field', () async {
      // act
      var result = await sut.login('', "password");
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });
  // ===============================================================================================
  group('forgotPassword', () {
    test('should return user id when success', () async {
      // act
      var result = await sut.forgotPassword(users[0]['email']);
      // assert
      expect(result.asValue.value, isNotEmpty);
    });
    test('should return error when failure', () async {
      // act
      var result = await sut.forgotPassword('unknown@mail.com');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong email format', () async {
      // act
      var result = await sut.forgotPassword('wrongemail.com');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });
  // ===============================================================================================
  group('findUser', () {
    test('should return user when success', () async {
      // act
      var result = await sut.findUser(users[0]['email']);
      // assert
      expect(result.asValue.value, isInstanceOf<User>());
    });
    test('should return error when failure', () async {
      // act
      var result = await sut.findUser('unknown@mail.com');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong email format', () async {
      // act
      var result = await sut.findUser('wrongemail.com');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });
  // ===============================================================================================
  // ===============================================================================================
  group('addEmail', () {
    Token token;
    setUp(() async {
      var result = await sut.login(users[0]['email'], 'password');
      token = result.asValue.value;
    });
    test('should return email id when success', () async {
      // act
      var result = await sut.addEmail(token, "new@mail.com", "user");
      // assert
      expect(result.asValue.value, isNotEmpty);
    });
    test('should return error when wrong token', () async {
      // act
      var result = await sut.addEmail(Token('wrongToken'), "new@mail.com", "user");
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong email format', () async {
      // act
      var result = await sut.addEmail(token, "wrongemailformat", "user");
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when empty field', () async {
      // act
      var result = await sut.addEmail(token, "", "user");
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });
  // ===============================================================================================
  group('updateEmail', () {
    Token token;
    setUp(() async {
      var result = await sut.login(users[0]['email'], 'password');
      token = result.asValue.value;
    });
    test('should return email id when success', () async {
      // act
      var result =
          await sut.updateEmail(token, emails[0]["_id"].toHexString(), "updated@mail.com", "admin");
      // assert
      expect(result.asValue.value, isNotEmpty);
      expect(result.asValue.value, equals(emails[0]["_id"].toHexString()));
    });
    test('should return error when failure', () async {
      // act
      var result = await sut.updateEmail(token, "someId", "updated@mail.com", "admin");
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong token', () async {
      // act
      var result = await sut.updateEmail(
          Token('wrongToken'), emails[0]["_id"].toHexString(), "updated@mail.com", "admin");
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong email format', () async {
      // act
      var result =
          await sut.updateEmail(token, emails[0]["_id"].toHexString(), "wrongemail.com", "admin");
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when empty field', () async {
      // act
      var result = await sut.updateEmail(token, emails[0]["_id"].toHexString(), "", "admin");
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });
  // ===============================================================================================
  group('deleteEmail', () {
    Token token;
    setUp(() async {
      var result = await sut.login(users[0]['email'], 'password');
      token = result.asValue.value;
    });
    test('should return email id when success', () async {
      // act
      var result = await sut.deleteEmail(token, emails[0]["_id"].toHexString());
      // assert
      expect(result.asValue.value, isNotEmpty);
      expect(result.asValue.value, emails[0]["_id"].toHexString());
    });
    test('should return error when failure', () async {
      // act
      var result = await sut.deleteEmail(token, 'someId');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong token', () async {
      // act
      var result = await sut.deleteEmail(Token('wrongToken'), emails[0]["_id"].toHexString());
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });
  //================================================================================================
  group('getAllEmails', () {
    Token token;
    setUp(() async {
      var result = await sut.login(users[0]['email'], 'password');
      token = result.asValue.value;
    });
    test('should return list of emails when success', () async {
      // act
      var result = await sut.getAllEmails(token);
      // assert
      expect(result.asValue.value, isNotEmpty);
      expect(result.asValue.value.length, equals(emails.length));
    });
    test('should return error when no emails found', () async {
      // arrange
      await db.dropCollection('emails');
      // act
      var result = await sut.getAllEmails(token);
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong token', () async {
      // act
      var result = await sut.getAllEmails(Token('wrongToken'));
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });
  // ===============================================================================================
  // ===============================================================================================
  group('updateUserName', () {
    Token token;
    setUp(() async {
      var result = await sut.login(users[0]['email'], 'password');
      token = result.asValue.value;
    });
    test('should return user id when success', () async {
      // act
      var result = await sut.updateUserName(token, users[0]["_id"].toHexString(), 'newusername');
      // assert
      expect(result.asValue.value, isNotEmpty);
      expect(result.asValue.value, users[0]["_id"].toHexString());
    });
    test('should return error when failure', () async {
      // act
      var result = await sut.updateUserName(token, 'someId', 'newusername');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong token', () async {
      // act
      var result = await sut.updateUserName(
          Token('wrongToken'), users[0]["_id"].toHexString(), 'newusername');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when empty field', () async {
      // act
      var result = await sut.updateUserName(token, users[0]["_id"].toHexString(), '');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });
  // ===============================================================================================
  group('updateUserPassword', () {
    Token token;
    setUp(() async {
      var result = await sut.login(users[0]['email'], 'password');
      token = result.asValue.value;
    });
    test('should return user id when success', () async {
      // act
      var result = await sut.updateUserPassword(
          token, users[0]["_id"].toHexString(), 'password', 'newPassword', 'newPassword');
      // assert
      expect(result.asValue.value, isNotEmpty);
      expect(result.asValue.value, users[0]["_id"].toHexString());
    });
    test('should return error when failure', () async {
      // act
      var result =
          await sut.updateUserPassword(token, 'someId', 'password', 'newPassword', 'newPassword');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong token', () async {
      // act
      var result = await sut.updateUserPassword(Token('wrongToken'), users[0]["_id"].toHexString(),
          'password', 'newPassword', 'newPassword');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong old password', () async {
      // act
      var result = await sut.updateUserPassword(
          token, users[0]["_id"].toHexString(), 'wrongPassword', 'newPassword', 'newPassword');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong new password mismatch', () async {
      // act
      var result = await sut.updateUserPassword(
          token, users[0]["_id"].toHexString(), 'password', 'newPassword1', 'newPassword2');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong empty field', () async {
      // act
      var result = await sut.updateUserPassword(
          token, users[0]["_id"].toHexString(), 'password', '', 'newPassword');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });
  // ===============================================================================================
  group('updateUserRole', () {
    Token token;
    setUp(() async {
      var result = await sut.login(users[0]['email'], 'password');
      token = result.asValue.value;
    });
    test('should return user id when success', () async {
      // act
      var result = await sut.updateUserRole(token, users[1]["_id"].toHexString(), 'admin');
      // assert
      expect(result.asValue.value, isNotEmpty);
      expect(result.asValue.value, users[1]["_id"].toHexString());
    });
    test('should return error when failure', () async {
      // act
      var result = await sut.updateUserRole(token, 'someId', 'admin');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong token', () async {
      // act
      var result =
          await sut.updateUserRole(Token('wrongToken'), users[1]["_id"].toHexString(), 'admin');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });

  // ===============================================================================================
  group('getAllUsers', () {
    Token token;
    setUp(() async {
      var result = await sut.login(users[0]['email'], 'password');
      token = result.asValue.value;
    });
    test('should return list of users when success', () async {
      // act
      var result = await sut.getAllUsers(token);
      // assert
      expect(result.asValue.value, isNotEmpty);
      expect(result.asValue.value.length, equals(users.length));
    });
    test('should return error when no users found', () async {
      // arrange
      await db.dropCollection('users');
      // act
      var result = await sut.getAllUsers(token);
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong token', () async {
      // act
      var result = await sut.getAllUsers(Token('wrongToken'));
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });
  // ==============================================================================================
}
