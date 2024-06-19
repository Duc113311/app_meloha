import 'dart:async';
import 'dart:convert' show json;
import 'dart:io';
import 'dart:io' as io;

import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../utils/enscrypt_utils.dart';
import '../utils/utils.dart';

class AuthServices {
  final firebaseStorage = FirebaseStorage.instance;

  // Signin Google
  // defifine goole signin scope
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);

  GoogleSignInAccount? _currentUser;

  Future<void> handleGoogleSignin() async {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _currentUser = account;
      if (_currentUser != null) {
        _handleGetContact(_currentUser!);
      }
    });
    try {
      _googleSignIn
          .signIn()
          .catchError((onError) => debugPrint(onError.toString()));
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      rethrow;
    }

    // _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    final http.Response response = await http.get(
      Uri.parse(
          'https://people.googleapis.com/v1/people/me/connections?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );

    if (response.statusCode != 200) {
      debugPrint(
          "People API ${response.statusCode} response: ${response.body}");

      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    if (namedContact != null) {
    } else {}
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
        (dynamic name) => name['displayNam'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;

      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  // Flutter google sign
  Future<UserCredential?> signInWithGoogle() async {

    UserCredential? userCredential;
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();


      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      // Once signed in , return the UserCredential
      userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

    } catch (e) {}


    return userCredential;
  }

  //Flutter facebook signin
  Future<UserCredential> signInFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // One signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  // Upload file to firebase
  Future uploadImageToFirebase(BuildContext context, String fileName) async {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('uploads')
        .child('/$fileName');

    final metatdata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});
    firebase_storage.UploadTask uploadTask;
    uploadTask = ref.putFile(io.File(fileName), metatdata);

    firebase_storage.UploadTask task = await Future.value(uploadTask);
    Future.value(uploadTask)
        .then((value) => {print("Upload file path ${value.ref.fullPath}")})
        .onError((error, stackTrace) =>
            {print("Upload file path error : ${error.toString()}")});
  }

  // Upload file to firebase storage
  Future<String?> uploadMedia(File file, FireStorePathType fileStoreType, ProfilePathType profileType, {ChildProfilePathType? child}) async {
    final folderName = PrefAssist.getMyCustomer().getFirebaseFolderName;
    debugPrint("folder name: $folderName");
    final fileName = const Uuid().v1();
    Reference ref;
    if (child != null) {
      ref = firebaseStorage.ref().child(fileStoreType.name).child(folderName).child(profileType.name).child(child!.name).child("$fileName.${profileType.extension}");
    } else {
      ref = firebaseStorage.ref().child(fileStoreType.name).child(folderName).child(profileType.name).child("$fileName.${profileType.extension}");
    }

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<String?> uploadMediaCheckNull(String filePath, FireStorePathType fileStoreType, ProfilePathType profileType) async {
    final folderName = PrefAssist.getMyCustomer().getFirebaseFolderName;
    debugPrint("folder name: $folderName");
    final fileName = const Uuid().v1();
    Reference ref = firebaseStorage.ref().child(fileStoreType.name).child(folderName).child(profileType.name).child("$fileName.${profileType.extension}");

    UploadTask uploadTask = ref.putFile(File(filePath));

    return await uploadTask.then((taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          break;
        case TaskState.paused:
          break;
        case TaskState.success:
          return await ref.getDownloadURL();
        case TaskState.canceled:
          return null;
        case TaskState.error:
          return null;
      }
    });
  }

  // Delete the selected image
  void deleteImage(String path) {
    if (path.isEmpty) { return; }
    firebaseStorage.refFromURL(path).delete();
  }
}

//MARK: Utils
enum FireStorePathType {
  profiles
}

enum ProfilePathType {
  images, videos, loop, verify
}

enum ChildProfilePathType {
  images, thumbnails
}

extension ProfilePathTypeExt on ProfilePathType {
  String get extension {
    switch (this) {
      case ProfilePathType.images: return "jpg";
      case ProfilePathType.videos: return "mp4";
      default: return "";
    }
  }
}

extension FileEx on File {
  String get name => path.split(Platform.pathSeparator).last;
}