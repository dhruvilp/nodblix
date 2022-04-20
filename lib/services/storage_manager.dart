import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<void> deleteRequestToken() async {
  final prefs = await _prefs;
  await prefs.remove('REQUEST_TOKEN');
  await prefs.remove('EXPIRATION');
  await Future.delayed(const Duration(seconds: 1));
  return;
}

Future<void> persistRequestToken(String kAuthToken, int kExpiration) async {
  final prefs = await _prefs;
  await prefs.setString('REQUEST_TOKEN', kAuthToken);
  await prefs.setInt('EXPIRATION', kExpiration);
  await Future.delayed(const Duration(seconds: 1));
  return;
}

Future<bool> hasRequestToken() async {
  final prefs = await _prefs;
  if (prefs.containsKey('REQUEST_TOKEN')) {
    return true;
  }
  await Future.delayed(const Duration(seconds: 1));
  return false;
}

Future<bool> hasTokenExpired() async {
  final prefs = await _prefs;
  if (prefs.containsKey('EXPIRATION')) {
    final DateTime timeStamp =
        DateTime.fromMillisecondsSinceEpoch(prefs.getInt('EXPIRATION')! * 1000);
    final DateTime currTime = DateTime.now();
    final int diff = timeStamp.difference(currTime).inSeconds;
    return diff < 5;
  }
  await Future.delayed(const Duration(seconds: 1));
  return true;
}

Future<String?> getRequestToken() async {
  final prefs = await _prefs;
  if (prefs.containsKey('REQUEST_TOKEN')) {
    return prefs.getString('REQUEST_TOKEN');
  }
  await Future.delayed(const Duration(seconds: 1));
  return '';
}
