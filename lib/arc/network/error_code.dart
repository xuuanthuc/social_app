// ignore_for_file: constant_identifier_names

class ErrorCode {
  static const int HTTP_OK = 200;
  static const int HTTP_BAD_REQUEST = 400;
  static const int HTTP_UNAUTHORIZED = 401;
  static const int HTTP_FORBIDDEN = 403;
  static const int HTTP_NOT_FOUND = 404;
  static const int HTTP_METHOD_NOT_ALLOWED = 405;
  static const int HTTP_REQUEST_TIMEOUT = 408;
  static const int HTTP_INTENAL_SERVER_ERROR = 500;
  static const int HTTP_BAD_GATEWAY = 502;
  static const int NO_NETWORK = 702;

  static const int ERROR_CONFIRM = 113;
  static const int ERROR_POINT_NOT_ENOUGH = 114;
  static const int ERROR_PROFILE_NOT_FOUND = 115;
  static const int ERROR_PHONE_REGISTERED = 116;
  static const int ERROR_INVALID_PHONE = 117;
  static const int ERROR_UPDATE_PROFILE_FAIL = 118;
  static const int ERROR_VERIFY_CODE = 119;
  static const int ERROR_QUESTION_NOT_FOUND = 120;
  static const int ERROR_REGISTER_FAIL = 121;
  static const int ERROR_SURVEY_NOT_EXIST = 122;
  static const int ERROR_SURVEY_ANSWERED = 123;
  static const int ERROR_INPUT_INVALID = 124;
  static const int ERROR_LIMIT_INVITE = 125;
  static const int ERROR_INVALID_INVITE = 126;
  static const int ERROR_PENDING = 130;
  static const int ERROR_VALIDATE_SURVEY = 131;
  static const int ERROR_LOGIN_FAIL = 132;
  static const int ERROR_PHONE_EXIST = 133;
  static const int ERROR_LIMIT_EXCHANGE = 134;
  static const int ERROR_INVITE_CODE = 135;
  static const int ERROR_PASSWORD_DONT_MATCH = 136;
  static const int ERROR_TOTAL_LIMIT = 137;
  static const int ERROR_SEND_CONTENT_TOO_LONG = 138;
  static const int ERROR_VERSION_UPDATE = 139;
  static const int ERROR_SERVER_MAINTAINED = 140;
  static const int ERROR_EXCHANGE_OVER_IN_DAY = 142;
  static const int ERROR_EXCHANGE_OVER_IN_WEEK = 143;
  static const int ERROR_INVALID_USER = 144;
  static const int ERROR_BINGO_SHARING_LIMITED = 145;

  static const int ERROR_USER_BLOCKED = 150;
  static const int ERROR_FORBIDDEN_SURVEY = 152;
  static const int ERROR_LIMITED_EXCHANGE = 160;
  static const int ERROR_LIMITED_SEND_VERIFICATION_CODE = 161;

  static const int ERROR_BANK_CODE_INVALID = 1009;
  static const int ERROR_AMOUNT_INVALID = 1008;
  static const int ERROR_POINT_ENOUGH = 1010;
  static const int ERROR_INVALID_ACCOUNT_NUMBER = 1011;
  static const int ERROR_NO_CAMPAIGN = 1001;

  static const int ERROR_NOT_FIND_ADDRESS = 22021991;
}
