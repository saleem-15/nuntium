import '../env/env.dart';

class Constants {
  static String googleServerClientId = Env.googleServerClientId;
  static const int splashDuration = 3;
  static const resendEmailTimeInSeconds = 30;

  //design dimensions
  static const double deviceWidth = 375;
  static const double deviceHeight = 812;

  //languages keys
  static const String arabicKey = 'ar';
  static const String englishKey = 'en';
  static const String arabic = 'العربية';
  static const String english = 'English';

  static const String resendDialogControllerId = 'resend_dialog';
}

class SharedPrefsKeys {
  static const String locale = 'locale';
  static const String isFirstTime = 'is_first_time';
}
