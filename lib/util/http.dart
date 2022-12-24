import 'package:dio/dio.dart';
import 'package:dio_log/interceptor/dio_log_interceptor.dart';
import 'package:image_picker/image_picker.dart';

//设置访问成功和失败的回调
typedef Success = void Function(dynamic json);
typedef Fail = void Function(String? reason, int? code);
typedef After = void Function();

class Http {
  static Dio? _dio;

  static Http https = Http();

  static Http getInstance() {
    return https;
  }

  Http() {
    if (_dio == null) {
      _dio = createDio();
    }
  }

  Dio createDio() {
//    这里还可以用baseoptions属性对进一步的参数进行配置
    var dio = Dio();

    dio.interceptors.add(DioLogInterceptor());

    return dio;
  }

  Future<Response> get(String uri, Map<String, dynamic> parama) async {
    return await _dio!.get(uri, queryParameters: parama);
  }

  Future<Response> post(String uri, formData) async {
    if (formData != null) {
      return await _dio!.post(uri, queryParameters: formData);
    } else {
      return await _dio!.post(uri);
    }
  }

  Future<Response> postFile(String uri, formData) async {
    if (formData != null) {
      return await _dio!.post(uri, queryParameters: formData);
    } else {
      return await _dio!.post(uri);
    }
  }

//  回调函数的定义和使用
  Future<void> getWithCallBack(uri, formData,
      {Success? success, Fail? fail, After? after}) async {
    await _dio!.post(uri, queryParameters: formData).then((response) {
      if (response.statusCode == 200) {
        if (success != null) {
          success(response.data);
        }
      } else {
        if (fail != null) {
          fail(response.statusMessage, response.statusCode);
        }

        if (after != null) {
          after();
        }
      }
    });
  }

  //  回调函数的定义和使用
  Future<void> getWithCallBackImg(uri, formData,
      {requestParameter,Success? success, Fail? fail, After? after}) async {
    await _dio!.post(uri, data: formData,queryParameters: requestParameter).then((response) {
      if (response.statusCode == 200) {
        if (success != null) {
          success(response.data);
        }
      } else {
        if (fail != null) {
          fail(response.statusMessage, response.statusCode);
        }

        if (after != null) {
          after();
        }
      }
    });
  }

//  更加低阶的API
  Future uploadPostFormData(url, formData) async {
    print('服务器数据为:${url}');
    var option = Options(
        method: "POST",
        contentType: "multipart/form-data"); //上传文件的content-type 表单
    try {
      Response response;
      Dio dio = Dio();

      if (formData == null) {
        response = await dio.post(url);
      } else {
        print('表单不为空');
        print(formData);
        response = await dio.post(url, data: formData, options: option,
            onSendProgress: (sent, total) {
              print('${sent}  ${total}');
            });
      }

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('无法连接服务器');

      }
    } catch (e) {
      print('有异常');
      print(e);
    }
  }

  Future<Response> downloadFile(String srcPath,String savePath)async{
    return await Dio().download(srcPath, savePath);
  }
}
