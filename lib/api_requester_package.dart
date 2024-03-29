library api_requester_package;

import 'dart:async';
import 'dart:convert';

import 'package:api_requester_package/auth_classes/authorization.dart';
import 'package:api_requester_package/auth_classes/basic_authorization.dart';
import 'package:api_requester_package/auth_classes/bearer_authorization.dart';
import 'package:api_requester_package/exceptions/not_supported_auth_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RequesterAPI {
  final String domain;
  // final String _userToken;

  // Authorization? _authorization;

  final Dio _dio;

  String _routes = '';
  Map<String, dynamic>? _body;
  String _params = '';

  final Function(RequestErrorArgs args)? errorListener;

  RequesterAPI.init({required this.domain, this.errorListener}) : _dio = Dio(BaseOptions(
    baseUrl: domain,
    validateStatus: (status) {
        return true;
      // switch (status) {
      //   default:
      // }
    },
  ));

  RequesterAPI setAuthorization(Authorization authorization) {
    switch (authorization.runtimeType) {
      case BearerAuthorization:
        _dio.options.headers["Authorization"] = 'Bearer ${(authorization as BearerAuthorization).accessToken}';        
        break;
      case BasicAuthorization:
        final username = (authorization as BasicAuthorization).username;
        final password = authorization.password;
        _dio.options.headers["Authorization"] = 'Basic ${(base64.encode(utf8.encode("$username:$password")))}';
        break;
      default:
        throw NotSupportedAuthException();
    }

    return this;
  }

  ///You don't need to put '/' at the beginning
  RequesterAPI route(String routes) {
    if (routes[0] != '/') {
      routes = '/$routes';
    }

    _routes = routes;

    return this;
  }
  
  RequesterAPI setBody(Map<String, dynamic> body) {
    _body = body;
    return this;
  }
   
  ///You do not need to put special signs: ? and & (if you need to connect two similar elements)
  RequesterAPI setParams(String params) {
    if (params[0] != '?') {
      params = '?$params';
    }
    
    if (_params == '') {
      _params = params;
    } else {
      _params += '&$params';
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
    return await _request(_dio.get(_routes + _params));
  } 
  Future<APIResponse?> post() async {
    return await _request(_dio.post(_routes + _params, data: _body));
  }
  Future<APIResponse?> put() async {
    return await _request(_dio.put(_routes + _params, data: _body));
  } 
  Future<APIResponse?> delete() async {
    return await _request(_dio.delete(_routes + _params, data: _body));
  } 

  RequesterAPI print() {
    debugPrint('\n$domain$_routes$_params\nBody: ${_body ?? ''}');
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