// login exception

class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// register exception

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUSEAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// genneric exception

class GennericAuthException implements Exception {}

class UserNotLoggedINAuthException implements Exception {}
