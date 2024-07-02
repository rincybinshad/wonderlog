import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class Controller extends ChangeNotifier {
//------------------------
  bool isLoading = false;
  File? newPost;
  final _imagePicker = ImagePicker();
  SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
  Future<File> pickPostImage() async {
    isLoading = true;
    notifyListeners();
    final pickedXfile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedXfile != null) {
      return newPost = File(pickedXfile.path);
    }
    print(newPost);

    notifyListeners();

    return newPost!;
  }

  cancelIndicator() {
    isLoading = false;
    notifyListeners();
  }

  //----------Serching

//--------------edit profile

  //-----------edit password
  TextEditingController emailController = TextEditingController();
  clearpasswordField() {
    emailController.clear();
    notifyListeners();
  }

//  -------------nav
  int selectedNavindex = 0;
  changeNavIndex(value) {
    selectedNavindex = value;
    notifyListeners();
  }

  double rating = 0;
  updaterating(value) {
    rating = value;
    notifyListeners();
  }

  clearReating() {
    rating = 0;
  }

  bool isSerchEnable = false;
  enableOrDisableSearch(bool value) {
    isSerchEnable = value;
    notifyListeners();
  }
}
