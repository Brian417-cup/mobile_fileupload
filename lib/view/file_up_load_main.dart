import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterfileupload/provider/file_provider.dart';
import 'package:ftoast/ftoast.dart';
import 'package:provider/provider.dart';

class FileUpLoadMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图片上传'),
        actions: [
//          选择图片
          _choosePicBtn(context),
//          删除图片
          _delPicBtn(context),
//          上传图片
          _uploadPicBtn(context)
        ],
      ),
      body: _showPicArea(),
    );
  }

  _showPicArea() {
    return Container(
      child: Consumer<FileProvider>(builder: (context, cur, child) {
        return cur.path != null
            ? Image.file(
                File(cur.path!),
                scale: 0.8,
              )
            : Container(
                alignment: Alignment.center,
                child: Text(
                  '请选择一张图片',
                  style: TextStyle(fontSize: 25, color: Colors.grey),
                ),
              );
      }),
    );
  }

  _uploadPicBtn(context) {
    return IconButton(
      onPressed: () async {
        var provider = Provider.of<FileProvider>(context, listen: false);
        switch (await provider.uploadImage()) {
          case BaseState.SUCCESS:
            FToast.toast(context, msg: '识别的结果为:${provider.recoStr!}');
            break;
          default:
            FToast.toast(context, msg: '请检查当前的网络情况');
            break;
        }
      },
      icon: Icon(Icons.upload),
      tooltip: '上传图片，获取识别结果',
    );
  }

  _delPicBtn(context) {
    return IconButton(
      onPressed: () {
        var provider = Provider.of<FileProvider>(context, listen: false);
        provider.clearLastSrc();
      },
      icon: Icon(Icons.format_clear),
      tooltip: '删除当前选择的图片',
    );
  }

  _choosePicBtn(context) {
    return IconButton(
      onPressed: () {
        var provider = Provider.of<FileProvider>(context, listen: false);
        provider.chooseFromGallery();
      },
      icon: Icon(Icons.camera_alt),
      tooltip: '选择一张图片',
    );
  }
}
