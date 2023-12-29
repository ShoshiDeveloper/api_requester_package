library api_requester_package;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RequesterAPI {
  final String domain;
  final String _userToken;

  final Dio _dio;

  String? _routes;
  Map<String, dynamic>? _body;
  String? _params;

  final Function(RequestErrorArgs args)? errorListener;

  RequesterAPI.init({required this.domain, required String userToken, this.errorListener}) : _userToken=userToken, _dio = Dio(BaseOptions(baseUrl: domain));

  ///You don't need to put '/' at the beginning
  RequesterAPI route(String routes) {
    if (_routes == null) {
    _routes = '/$routes';
    } else {
    _routes = _routes! + '/$routes';
    }
    return this;
  }
  
  RequesterAPI setBody(Map<String, dynamic> body) {
    _body = body;
    return this;
  }
  ///You do not need to put special signs: ? and & (if you need to connect two similar elements)
  RequesterAPI setParams(String params) {
    // _params = params;
    if (_params == null) {
    _params = '?$params';
    } else {
    _params = _params! + '&$params';
    }
    return this;
  }

  Future<APIResponse?> _request(Future request) async {
    try {
      Response response = await request;
      return APIResponse(statusCode: response.statusCode!, data: response.data);
    } on DioException catch (e) {
      if (e.response == null) {
        debugPrint(e.error.toString());
        if(errorListener != null) errorListener!(RequestErrorArgs(e.error.toString()));
        return null;
      } else if (e.response!.statusCode == 404) {
        debugPrint('NotFoundRouteException\nRoute: ${'${_dio.options.baseUrl}/$_routes'}');
        if(errorListener != null) errorListener!(RequestErrorArgs('NotFoundRouteException\nRoute: ${ '${_dio.options.baseUrl}/$_routes' }'));
        return null;
      } else if (e.response!.statusCode == 500) {
        debugPrint('InternalServerError\nRoute: ${'${_dio.options.baseUrl}/$_routes'}\nData:${e.response!.data}');
        if(errorListener != null) errorListener!(RequestErrorArgs('InternalServerError\nRoute: ${ '${_dio.options.baseUrl}/$_routes' }\nData:${e.response!.data}'));
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

  RequesterAPI print() {
    debugPrint('\n$domain$_routes${_params != null ? '$_params' : ''}\nBody: ${_body ?? ''}\nAccess Token: $_userToken');
    return this;
  }
}

class APIResponse {
  final int statusCode;
  final dynamic data;
  const APIResponse({required this.statusCode, required this.data});
}

class RequestErrorArgs {
  final String message;
  const RequestErrorArgs(this.message);
}