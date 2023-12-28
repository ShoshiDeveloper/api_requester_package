library api_requester_package;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ForesAPI {
  final String domain;
  final String _userToken;

  final Dio _dio;

  String? _routes;
  Map<String, dynamic>? _body;
  String? _params;

  ForesAPI.init({required this.domain, required String userToken}) : _userToken=userToken, _dio = Dio(BaseOptions(
    // headers: {},
    baseUrl: domain
  ));

  ForesAPI route(String routes) {
    _routes = routes;
    return this;
  }

  ForesAPI setBody(Map<String, dynamic> body) {
    _body = body;
    return this;
  }
  ForesAPI setParams(String params) {
    _params = params;
    return this;
  }

  Future<ForesAPIResponse?> _request(Future request) async {
    try {
      Response response = await request;
      return ForesAPIResponse(statusCode: response.statusCode!, data: response.data);
    } on DioException catch (e) {
      if (e.response == null) {
        debugPrint(e.error.toString());
        return null;
      } else if (e.response!.statusCode == 404) {
        debugPrint('NotFoundRouteException\nRoute: ${ '${_dio.options.baseUrl}/$_routes' }');
        return null;
      } else if (e.response!.statusCode == 500) {
        debugPrint('InternalServerError\nRoute: ${ '${_dio.options.baseUrl}/$_routes' }\nData:${e.response!.data}');
        return null;
      }

      return ForesAPIResponse(
        statusCode: e.response!.statusCode!,
        data: e.response!.data
      );
    }
  }

  Future<ForesAPIResponse?> post() async {
    return await _request(_dio.post('/$_routes'));
  } 

  String print() {
    // throw ForesAPIException('pizdec polniy');
    
    return '\n$domain/$_routes${_params != null ? '?$_params' : ''}\n_body: ${_body ?? ''}\nAccess Token: $_userToken';
  }
}

class ForesAPIResponse {
  int statusCode;
  dynamic data;
  ForesAPIResponse({required this.statusCode, required this.data});
}