import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dating_app/src/domain/repositories/verify/verify_repo.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';



part 'verify_state.dart';

class VerifyCubit extends Cubit<VerifyState> {
  VerifyCubit() : super(VerifyInitial());


  final firebaseStorage = FirebaseStorage.instance;
  final VerifyRepo repo = VerifyRepo();
  Future<void> uploadFileVerify(List<String> filePath) async {
    emit(VerifyLoading());
    List<String> urls = [];
    try{
      for(int i = 0; i < filePath.length;i++){
        Reference ref = firebaseStorage.ref().child(filePath[i]);
        await ref.putFile(File(filePath[i]));
        String url = await ref.getDownloadURL();
        urls.add(url);
      }
    }catch(e){
      print('push ảnh $e');
    }
    if (urls.isNotEmpty) {
      _verifyVideo(urls);
      print('_verifyVideo successs');
    }
    debugPrint("URL DOWNLOAD : $urls");
  }

  // Future<void> uploadFile(String filePath) async {
  //   emit(VerifyLoading());
  //   Reference ref = firebaseStorage.ref().child(filePath);
  //   await ref.putFile(File(filePath));
  //   String url = await ref.getDownloadURL();
  //   if (url.isNotEmpty) {
  //     _verifyVideo(url);
  //   }
  //   debugPrint("URL DOWNLOAD : $url");
  // }
  Future<void> _verifyVideo(List<String> videoUrl) async {
    // call video verify
    repo.verifyPhotos(videoUrl).fold((left) {
      return emit(VerifyFailed());
    }, (right) {
      if(right) {
        // PrefAssist
        //     .getMyCustomer()
        //     .verifyStatus = true;
        // PrefAssist.saveMyCustomer();
        Utils.toast('đã ghi nhận, hệ thống đang xử lí');
      }else{
        Utils.toast('có lỗi xảy ra, mời bạn thử lạ');
      }
      return emit(VerifySuccess());
    });
  }

}
