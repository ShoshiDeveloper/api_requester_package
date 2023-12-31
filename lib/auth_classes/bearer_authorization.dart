import 'package:api_requester_package/auth_classes/authorization.dart';

class BearerAuthorization implements Authorization {
  final String accessToken;
  BearerAuthorization({required this.accessToken});
}