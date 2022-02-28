// import 'package:licorice_indo/src/utils/config.dart';

class ApiEndpoints {
  static String get _baseUrl => 'Config.hostFlashJob';
  static String get _licoriceBaseUrl => 'Config.hostLicorice';
  static String get _webApiBaseUrl => 'Config.webApi';

  static String get login => _baseUrl + 'worker/licorice_authentication';
  static String get skillList => _baseUrl + 'public/categories';
  static String get updateProfile => _baseUrl + 'worker/workers/1';
  static String get postIdentifyCard => _baseUrl + 'worker/verify';
  static String get identifyCard => _baseUrl + 'worker/verify/1';
  static String get workerProfile => _baseUrl + 'worker/workers/1';
  static String get workerSkills => _baseUrl + 'worker/worker_skills';
  static String get workerSocials => _baseUrl + 'worker/worker_socials';
  static String get workerAchievement =>
      _baseUrl + 'worker/worker_achievements';
  static String get generateProfileCard =>
      _baseUrl + 'worker/workers/update_business_card';
  static String jobList = _baseUrl + 'worker/jobs';
  static String commonReviewList = _baseUrl + 'public/clients';
  static String clientProfile = _baseUrl + 'public/clients';
  static String favoriteJobOrClient = _baseUrl + 'worker/favorites';
  static String applyJob = _baseUrl + 'worker/applicants';
  static String workerChat = _baseUrl + 'worker/chats';
  static String reOfferAJob = _baseUrl + 'worker/applicants';
  static String updateAppliedJobStatus =
      _baseUrl + 'worker/applicants/update_status';
  static String reviewClient = _baseUrl + 'worker/reviews';
  static String seePayment =
      _licoriceBaseUrl + 'api/flashjob/payments/see_payment';
  static String getTikTokFollower = _webApiBaseUrl + 'tiktok/';
  static String getYoutubeSubscriber = _webApiBaseUrl + 'youtube/me/followers?url=';
  static Licorice licorice = Licorice();
}

class Licorice {
  const Licorice();
  static String _baseUrl = 'Config.hostLicorice';
  String get verifyPhoneNumberV2 =>
      _baseUrl + 'api/v2/profile/verify_phone_number';
}
