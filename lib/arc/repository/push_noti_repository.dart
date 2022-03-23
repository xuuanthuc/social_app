import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hii_xuu_social/src/preferences/app_preference.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

import '../di/service_locator.dart';
import '../network/api_provider.dart';

class PushNoticeRepository {
  final ApiProvider _apiProvider = getIt.get<ApiProvider>();

  Future<void> pushNoticeTest() async {
    var token = await AppPreference().firebaseToken;
    await _apiProvider
        .post("https://fcm.googleapis.com/fcm/send", params: {
      "to" : "$token",
      "notification": {
        "title": "Title",
        "body" : "First Notification",
        "text": "Text"
      },
      "data" : {
        "body" : "Body of Your Notification in Data",
        "title": "Title of Your Notification in Title",
        "key_1" : "Value for key_1",
        "key_2" : "Value for key_2"
      }
    });
  }
  //
  // Future<void> createWorkerSkills(
  //     {required List<WorkerSkillsItem> listSkills}) async {
  //   List<Map<String, dynamic>> mapWorkerSkill =
  //       listSkills.map((e) => e.toJson()).toList();
  //   try {
  //     await _apiProvider.post(ApiEndpoints.workerSkills,
  //         params: {'worker_skills': mapWorkerSkill});
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //
  // Future<bool> createWorkerSocials(
  //     {required List<SocialItem> listSocials}) async {
  //   List<Map<String, dynamic>> mapWorkerSocials =
  //       listSocials.map((e) => e.toJson()).toList();
  //   try {
  //     await _apiProvider.post(ApiEndpoints.workerSocials,
  //         params: {'worker_socials': mapWorkerSocials});
  //     return true;
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }
  //
  // Future<void> createWorkerAchivement(
  //     {required List<AchievementItem> listAchievement}) async {
  //   List<Map<String, dynamic>> mapWorkerAchievement =
  //       listAchievement.map((e) => e.toJson()).toList();
  //   try {
  //     await _apiProvider.post(ApiEndpoints.workerAchievement,
  //         params: {'worker_achievements': mapWorkerAchievement});
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //
  // Future<ListSkillModel> getListSkill() async {
  //   final response = await _apiProvider
  //       .get(ApiEndpoints.workerSkills, params: {'locate': 'id'});
  //   ListSkillModel data = ListSkillModel.fromMap(response);
  //   return data;
  // }
  //
  // Future<SocialModel> getListWorkerSocials() async {
  //   final response = await _apiProvider.get(ApiEndpoints.workerSocials);
  //   SocialModel data = SocialModel.fromJson(response);
  //   return data;
  // }
  //
  // Future<AchievementModel> getListWorkerAchievement() async {
  //   final response = await _apiProvider.get(ApiEndpoints.workerAchievement);
  //   AchievementModel data = AchievementModel.fromJson(response);
  //   return data;
  // }
  //
  // Future<dynamic> createProfile({required ProfileFjItem profileItem}) async {
  //   Map<String, dynamic> params = Map<String, dynamic>();
  //   final avatarPath = profileItem.avatarPath ?? '';
  //   if (avatarPath.isNotEmpty && !avatarPath.contains('https://')) {
  //     params['avatar'] = profileItem.avatarPath;
  //   }
  //
  //   if ((profileItem.videoUrl ?? '').isNotEmpty) {
  //     params['video'] = profileItem.videoUrl;
  //   }
  //   params['name'] = profileItem.name;
  //   params['catch_phrase'] = profileItem.catchPhrase;
  //   params['language_codes'] = _genLanguageCode(profileItem.listLanguage ?? []);
  //   params['account_type'] = '${profileItem.accountType}';
  //   params['skill_ids'] = _genSkillId(profileItem.listSkill ?? []);
  //   params['skill_overview'] = profileItem.skillOverview;
  //   params['hourly_pay'] = '${profileItem.expectedHourlyRate}';
  //   params['rate_per_post'] = '${profileItem.ratePerPost}';
  //   AddressFjItem? address = profileItem.addressFjItem;
  //   if (address != null) {
  //     params['lat'] = '${address.latitude}';
  //     params['lng'] = '${address.longitude}';
  //     params['address'] = '${address.address}';
  //   }
  //   if (profileItem.accountType == Constants.accountRegisterType.company) {
  //     CompanyInfoFjItem? companyInfoFjItem = profileItem.companyInfoFjItem;
  //     Map<String, dynamic> companyParams = Map<String, dynamic>();
  //     if (companyInfoFjItem != null) {
  //       companyParams['name'] = '${companyInfoFjItem.name}';
  //       companyParams['website'] = '${companyInfoFjItem.website}';
  //       companyParams['employees'] = '${companyInfoFjItem.employeeTotal}';
  //       companyParams['address'] = '${companyInfoFjItem.address}';
  //       params['company_logo'] = companyInfoFjItem.logoUrl;
  //     }
  //     params['company_info'] = json.encode(companyParams);
  //   }
  //   debugPrint('params = $params');
  //   final formData = FormData.fromMap({});
  //   for (var entry in params.entries) {
  //     String key = entry.key;
  //     dynamic value = entry.value;
  //     if (key.contains('avatar') ||
  //         key.contains('video') ||
  //         key.contains('company_logo') ||
  //         key.contains('card_front') ||
  //         key.contains('card_back')) {
  //       File imageFile = File(value);
  //       if (await imageFile.exists()) {
  //         formData.files.add(MapEntry(
  //             key,
  //             await MultipartFile.fromFile(value,
  //                 contentType: MediaType.parse('image/jpeg'),
  //                 filename: basename(imageFile.path))));
  //       }
  //     } else {
  //       formData.fields.add(MapEntry(key, value.toString()));
  //     }
  //   }
  //   final response =
  //       await _apiProvider.putMultiPart(ApiEndpoints.updateProfile, formData);
  //   return response;
  // }
  //
  // String _genLanguageCode(List<LanguageFjItem> listLanguage) {
  //   if (listLanguage.length <= 0) return '';
  //   List<String> listCode = [];
  //   listLanguage.forEach((element) {
  //     listCode.add(element.code);
  //   });
  //   return listCode.join(',');
  // }
  //
  // String _genSkillId(List<WorkerSkillsItem> listSkill) {
  //   if (listSkill.length <= 0) return '';
  //   List<int> listId = [];
  //   listSkill.forEach((element) {
  //     listId.add(element.skillId ?? 0);
  //   });
  //   return listId.join(',');
  // }
  //
  // Future<ProfileFjItem> getProfile() async {
  //   final response = await _apiProvider.get(ApiEndpoints.workerProfile);
  //   ProfileFjItem item = ProfileFjItem.fromMap(response);
  //   return item;
  // }
  //
  // Future<ProfileCardFjItem> getCard() async {
  //   final response =
  //       await _apiProvider.put(ApiEndpoints.generateProfileCard, params: {});
  //   ProfileCardFjItem item = ProfileCardFjItem.fromMap(response);
  //   return item;
  // }
}
