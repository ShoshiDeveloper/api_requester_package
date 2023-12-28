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

  Future<APIResponse?> _request(Future request) async {
    try {
      Response response = await request;
      return APIResponse(statusCode: response.statusCode!, data: response.data);
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

      return APIResponse(
        statusCode: e.response!.statusCode!,
        data: e.response!.data
      );
    }
  }

  Future<APIResponse?> get() async {
    return await _request(_dio.get('/$_routes'));
  } 
  Future<APIResponse?> post() async {
    return await _request(_dio.post('/$_routes'));
  }
  Future<APIResponse?> put() async {
    return await _request(_dio.put('/$_routes'));
  } 
  Future<APIResponse?> delete() async {
    return await _request(_dio.delete('/$_routes'));
  } 

  String print() {
    // throw ForesAPIException('pizdec polniy');
    
    return '\n$domain/$_routes${_params != null ? '?$_params' : ''}\n_body: ${_body ?? ''}\nAccess Token: $_userToken';
  }
}

class APIResponse {
  int statusCode;
  dynamic data;
  APIResponse({required this.statusCode, required this.data});
}