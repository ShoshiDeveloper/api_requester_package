import 'package:api_requester_package/auth_classes/authorization.dart';

class BasicAuthorization implements Authorization {
  final String username;
  final String password;
  BasicAuthorization({required this.username, required this.password});
}