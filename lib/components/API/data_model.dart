import 'dart:developer';

import 'package:dio/dio.dart';

// ignore: constant_identifier_names
enum HttpMethod { GET, POST, PUT, DELETE, PATCH }

/// 这个部分将api分成api和apiinfo两个部分，他们的区别时面向的组不同。
/// apiinfo 面向 api组件
/// api面向 发送请求时构建的对象

/// api信息的抽象。api组件包含api info的内容。
class APIInfo {
  int id;
  String name; // 名字
  String path; // 路径
  HttpMethod method; // 方法
  Map<String, dynamic>? params; // 路径参数
  Map<String, dynamic>? headers; // 头部

  APIInfo(
    this.id,
    this.name,
    this.method,
    this.path, {
    this.params,
    this.headers,
  });

  @override
  String toString() {
    return [id, name, method, path, params, headers].toString();
  }

  APIInfo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        path = json['path'],
        method = HttpMethod.values[json['method']],
        params = json['params'],
        headers = json['headers'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'method': method.index,
        'path': path,
        'params': params,
        'headers': headers,
      };
}

/// DONE API 待完善
/// @brief 每一个API对应一个环境，包含多个接口。用于发起请求
/// 一个api组包含一个通用的api抽象。主要用于身份的认证和简化url。
class API {
  String url;
  Map<String, dynamic>? _headers;
  Map<String, dynamic>? _params;

  // 初始化
  API(this.url, {Map<String, dynamic>? headers, Map<String, dynamic>? params}) {
    _headers = headers ?? {};
    _params = params ?? {}; // 非空
  }

  /// 这个无需序列化 😅
  API.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        _headers = json['headers'],
        _params = json['params'];

  Map<String, dynamic> toJson() => {
        'url': url,
        'headers': _headers,
        'params': _params,
      };

  /// 设置token，一个组别一个用户用于api身份的认证。
  set token(String token) {
    _headers?["token"] = token;
  }

  /// 自定义头部，为一个组别添加一些自定义参数。
  void setHeader(Map<String, dynamic>? newHeaders) {
    newHeaders = newHeaders ?? {};
    newHeaders.forEach((key, value) {
      _headers?[key] = value;
    });
  }

  /// 自定义参数，为一个组别添加一些自定义参数。
  void setParams(Map<String, dynamic>? newParams) {
    newParams = newParams ?? {};
    newParams.forEach((key, value) {
      _params?[key] = value;
    });
  }

  /// 参数位请求方式和请求参数。
  Future<Response?> send(HttpMethod method, String path) async {
    Response response;
    path = url + path;
    log("$path\t$_params");
    try {
      switch (method) {
        case HttpMethod.GET:
          response = await Dio().get(path, queryParameters: _params, options: Options(headers: _headers));
          break;
        case HttpMethod.POST:
          response = await Dio().post(path, queryParameters: _params, options: Options(headers: _headers));
          break;
        case HttpMethod.PUT:
          response = await Dio().put(path, queryParameters: _params, options: Options(headers: _headers));
          break;
        case HttpMethod.DELETE:
          response = await Dio().delete(path, queryParameters: _params, options: Options(headers: _headers));
          break;
        case HttpMethod.PATCH:
          response = await Dio().patch(path, queryParameters: _params, options: Options(headers: _headers));
          break;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        log(e.response!.statusCode.toString(), level: 3, error: e.response!.statusMessage);
      } else {
        log("", level: 3, error: "Network or Server Error");
      }
      return e.response;
    }
    return response;
  }
}

// TODO 登录功能 暂时不做
/// 可选用户认证
class User {
  late String token;
  late String _username;
  late String _passwd;
  User(String username, String passwd) {
    _username = username;
    _passwd = passwd;
  }

  get name => _username;

  /// 登录
  void login() {
    // TODO 登录 get token and store token;
  }

  /// 获取token
  void getToken() {
    // TODO get token and store token;
  }

  /// 注销
  void cancel() {}
}
