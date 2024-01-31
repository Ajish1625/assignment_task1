import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Model/model.dart';






class UserProvider extends ChangeNotifier {
  UserModel _userModel = UserModel();

  UserModel get userModel => _userModel;

  void updateUserModel(UserModel newUserModel) {
    _userModel = newUserModel;
    notifyListeners();
  }
}