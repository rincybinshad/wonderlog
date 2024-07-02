import 'dart:async';
import 'dart:developer';
 
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wanderlog/model/new_post.dart';
import 'package:wanderlog/model/review_model.dart';
import 'package:wanderlog/model/user_model.dart';

class FireController with ChangeNotifier {
  final db = FirebaseFirestore.instance;
//---------------pickeImage
  File? fileImage;

  String? _url;

  final _imagePicker = ImagePicker();
  final _firbaseStorage = FirebaseStorage.instance;
  SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
// ----------------------- I M A G E ----------------------
  pickImage() async {
    final pickedXfile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedXfile != null) {
      final currenttime = DateTime.now();
      fileImage = File(pickedXfile.path);
      UploadTask uploadTask = _firbaseStorage
          .ref()
          .child("profileImage/User${currenttime.millisecond}")
          .putFile(fileImage!, metadata);
      TaskSnapshot snapshot = await uploadTask;
      await snapshot.ref.getDownloadURL().then((url) {
        db
            .collection("User")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"imageUrl": url});
      });
      notifyListeners();
    }
  }

  //----------P O S T I M A G E
  Future<String?> urlGenarator(newPost) async {
    final currenttime = DateTime.now();
    UploadTask uploadTask = _firbaseStorage
        .ref()
        .child(
            "Post/${FirebaseAuth.instance.currentUser!.uid}/${currenttime.millisecond}")
        .putFile(newPost!, metadata);
    TaskSnapshot snapshot = await uploadTask;
    await snapshot.ref.getDownloadURL().then((value) {
      _url = value;
    });
    return _url;
  }

//-----------create
  Future addUser(String uid, UserModel userModel) async {
    db.collection("User").doc(uid).set(userModel.tojson(uid));
  }

  Future addNewPost(AddNewPost addNewPost) async {
    final doc = db.collection("Post").doc();
    doc.set(addNewPost.toJson(doc.id));
  }

  Future addNewReview(postId, CommentModel reviewModel) async {
    final reviwdoc = db.collection("Comment").doc();
    reviwdoc.set(reviewModel.toJson(reviwdoc.id));
  }

  Future addRating(postId, rate) async {
    final doc = db.collection("Rating").doc(postId);
    final snapshot = await doc.get();
    if (snapshot.exists) {
      fetchTotalRatingOfSinglepOst(postId).then((value) {
        print(value);
        final totlaRate = value + rate;
        doc.set({"totalRating": totlaRate});
      });
    } else {
      doc.set({"totalRating": rate});
    }
  }

//-------------delete

//-------------update
  Future updateUserProfile(String name, String bio, String dec) async {
    DocumentReference doc =
        db.collection("User").doc(FirebaseAuth.instance.currentUser!.uid);

    if (name.isNotEmpty) {
      doc.update({
        "name": name,
      });
    }
    if (bio.isNotEmpty) {
      doc.update({
        "bio": bio,
      });
    }
    if (dec.isNotEmpty) {
      doc.update({"description": dec});
    }
    notifyListeners();
  }

  Future updateRatingautomatically(postId) async {
    fetchTotalRatingOfSinglepOst(postId).then((totalrate) {
      final doc = db.collection("Post").doc(postId);

      switch (totalRate! * 5 / 100) {
        case < .5:
          {
            doc.update({"rating": 0.5});
          }
        case > .5 && <= 1:
          {
            doc.update({"rating": 1.0});
          }
        case > 1.0 && <= 1.5:
          {
            doc.update({"rating": 1.5});
          }
        case > 1.5 && <= 2.0:
          {
            doc.update({"rating": 2.0});
          }
        case > 2.0 && <= 2.5:
          {
            doc.update({"rating": 2.5});
          }
        case > 2.5 && <= 3.0:
          {
            doc.update({"rating": 3.0});
          }
        case > 3.0 && <= 3.5:
          {
            doc.update({"rating": 3.5});
          }
        case > 3.5 && <= 4.0:
          {
            doc.update({"rating": 4.0});
          }
        case > 4.0 && <= 4.5:
          {
            doc.update({"rating": 4.5});
          }
        case >= 5:
          {
            doc.update({"rating": 5.0});
          }
      }
      // if (_averagerate > 5) {
      //   update({"rating": 5.0});
      // } else {
      //   db.collection("Post").doc(postId).update({"rating": _averagerate});
      // }
    });
    notifyListeners();
  }

//-----------read
  UserModel? selecteduserData;
  Future<bool> fechSelectedUserData(
    uid,
  ) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await db.collection("User").doc(uid).get();

    if (snapshot.exists) {
      selecteduserData = UserModel.fromJson(snapshot.data()!);
      return true;
    } else {
      return false;
    }

    // if (snapshot.exists) {
    //   selecteduserData = UserModel.fromJson(snapshot.data()!);
    // } else {
    //   showDialog(
    //     context: context,
    //     builder: (context) =>  AlertDialog(
    //       content: Text("data"),
    //     ),
    //   );
    // }
  }

  double rating = 0;
  fetchSelectedPostRating(postId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await db.collection("Post").doc(postId).get();
    if (snapshot.exists) {
      rating = snapshot.data()!["rating"];
    }
  }

  List<AddNewPost> listOfPost = [];
  Future fetchAllPost(bool listen) async {
    final userData = await db
        .collection("Post");
       
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await userData.get();
    listOfPost = snapshot.docs.map((e) {
      return AddNewPost.fromJson(e.data());
    }).toList();
    if (listen) {
      notifyListeners();
    }
  }

  List<CommentModel> myReviews = [];
  Future fetchCurrentUSerComments() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection("Comment")
        .where("postOwnnerId",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
        
    myReviews = snapshot.docs.map((e) {
      return CommentModel.fromJson(e.data());
    }).toList();
    log(snapshot.docs.length.toString());
  }

  List<AddNewPost> selectedUserPost = [];
  Future fechOnlySelectedUserPosts(uid) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection("Post").where("uid", isEqualTo: uid).get();
    selectedUserPost = snapshot.docs.map((e) {
      return AddNewPost.fromJson(e.data());
    }).toList();
  }

  // List<CommentModel> myComment = [];
  // Future fetchCurrentUserComment() async {
  //   QuerySnapshot<Map<String, dynamic>> snapsh0t = await db
  //       .collection("Comment")
  //       .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   myComment = snapsh0t.docs.map((e) {
  //     return CommentModel.fromJson(e.data());
  //   }).toList();
  // }
  List<AddNewPost> searchList = [];
  serchPlace(value) {
    print(value);
    searchList = listOfPost.where(
      (element) {
        return element.placeName.toLowerCase().contains(value);
      },
    ).toList();
    print(searchList.length);
    notifyListeners();
  }

  double? totalRate;
  Future<double> fetchTotalRatingOfSinglepOst(postId) async {
    final snapshot = await db.collection("Rating").doc(postId).get();

    return totalRate = snapshot.data()!["totalRating"];
  }

  List<AddNewPost> topRatedList = [];
  fetchGreaterThan3ratingPost() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection("Post")
        .where("rating", isGreaterThanOrEqualTo: 3)
        .get();
    topRatedList = snapshot.docs.map((e) {
      return AddNewPost.fromJson(e.data());
    }).toList();
  }
}
