import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterfileupload/config/urls.dart';
import 'package:flutterfileupload/model/RecognitionResult.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

import '../util/http.dart';

enum BaseState { LOADING, SUCCESS, FAIL, CONTENT, EMPTY }

class FileProvider with ChangeNotifier {
  /////////////////////////////////////////////////////////////////
//  获取图片模块
  XFile? srcImg = null;
  String? path = null;

  //  从照相机中选取
  chooseFromCamera() async {
    var temp = await ImagePicker().pickImage(source: ImageSource.camera);
    srcImg = temp;
    path = temp!.path;

    print(path);

    if (srcImg == null) {
      print('空');
    } else {
      print(srcImg);
    }
  }

  //  从相册中选择
  chooseFromGallery() async {
    var temp = await ImagePicker().pickImage(source: ImageSource.gallery);
    print(temp!.path);
    print(temp.name);
    srcImg = temp;
    path = temp!.path;

    if (srcImg == null) {
      print('空');
    } else {
      print('不为空');
    }

    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////////////
  //上传模块
  BaseState state = BaseState.EMPTY;

  //识别结果
  String? recoStr;

  clearLastRecoStr() {
    recoStr = '';
  }

  //  打包成图片文件准备发送
  Future<dio.MultipartFile> _getMultiPartFileImageInstance(
      XFile? imageFile) async {
    return await dio.MultipartFile.fromFileSync(imageFile!.path,
        filename: imageFile!.name);
  }

  //  上传图片
  Future<BaseState?> uploadImage() async {
    if (srcImg == null) {
      return BaseState.EMPTY;
    }

    state = BaseState.LOADING;
    clearLastRecoStr();
//    clearLastSrc();

    dio.FormData formData = dio.FormData();
    formData.files.addAll(
        [MapEntry('upload', await _getMultiPartFileImageInstance(srcImg))]);

    Map<String, dynamic> requestParameters = Map();

    await Http().getWithCallBackImg(servicePath[image_upload_page], formData,
        requestParameter: requestParameters, success: (value) {
//      针对json 字符串形式的解析
//      compute(decode, value).then((result) {
//        if (result == null) {
//          state = BaseState.EMPTY;
//        } else {
////          print(result);
//          state = BaseState.CONTENT;
////          print(uploadResult.singleImgName);
//        }
//      });

//        针对json Map形式的解析
      print('这里的' + RecognitionResult.fromJson(value).toString());
      var recoRes = RecognitionResult.fromJson(value);

      if (recoRes.isSuccess!) {
        state = BaseState.SUCCESS;
        recoStr = recoRes.res;
      } else {
        state = BaseState.FAIL;
      }

//      uploadResult.result = true;
    }, fail: (reason, status) {
      state = BaseState.FAIL;
//      uploadResult.result = false;
    }, after: () {});

//    state = BaseState.LOADING;

    print('识别的结果为:${recoStr}');

    return state;
  }

  //  清除上次上传的数据
  clearLastSrc() {
    path = null;

    notifyListeners();
  }

//  json解码
  static Map<String, dynamic> decodeFromJsonString(dynamic input) {
    return json.decode(input);
  }

  static RecognitionResult decodeFromJsonMap(Map<String, dynamic> input) {
    return RecognitionResult.fromJson(input);
  }
}
