import 'dart:io' show Platform;

/*
  ##############################################################################
  !                            URLs                                            !
  ##############################################################################
*/

// const String kGrouteUrl = "https://api.groute.online";
// For local development
String get kGrouteUrl {
  if (Platform.isIOS) {
    return "http://localhost:3000"; // For iOS simulator
  } else {
    return "http://10.0.2.2:3000"; // For Android emulator (10.0.2.2 points to host machine's localhost)
  }
}

const String kGS1Url = 'https://gs1ksa.org/';
const String kGTrackUrl = 'https://backend.gtrack.online';

/*
  ##############################################################################
  !                            Assets                                          !
  ##############################################################################
*/

const String kGrouteSplashImg = 'assets/images/groute_splash.png';
const String kLogoImg = 'assets/images/logo.png';
const String kAuthBackgroundImg = 'assets/images/login_background.png';
