import 'package:shared_preferences/shared_preferences.dart';

// API Configuration
class ApiConstants {
  // API Configuration
  static const String apiVersion = 'v1';
  static const int apiPort = 3333;
  static const String productionBaseUrl = 'https://payment.hortivise.com/api/$apiVersion';
  static const String productionFullBaseUrl = 'https://payment.hortivise.com/api/v1/auth/login';

}

Map<String, String> timeZoneMapping = {
  'Etc/GMT-12': 'International Date Line West (GMT -12:00)',
  'Etc/GMT-11': 'Coordinated Universal Time -11 (GMT -11:00)',
  'Pacific/Honolulu': 'Hawaii (GMT -10:00)',
  'America/Anchorage': 'Alaska (GMT -9:00)',
  'America/Los_Angeles': 'Pacific Time (US & Canada) (GMT -8:00)',
  'America/Phoenix': 'Arizona (GMT -7:00)',
  'America/Denver': 'Mountain Time (US & Canada) (GMT -7:00)',
  'America/Chicago': 'Central Time (US & Canada) (GMT -6:00)',
  'America/Mexico_City': 'Mexico City (GMT -6:00)',
  'Canada/Saskatchewan': 'Saskatchewan (GMT -6:00)',
  'America/New_York': 'Eastern Time (US & Canada) (GMT -5:00)',
  'America/Lima': 'Lima (GMT -5:00)',
  'America/Bogota': 'Bogota (GMT -5:00)',
  'America/Caracas': 'Caracas (GMT -4:30)',
  'Canada/Atlantic': 'Atlantic Time (Canada) (GMT -4:00)',
  'America/Santiago': 'Santiago (GMT -4:00)',
  'America/La_Paz': 'La Paz (GMT -4:00)',
  'Canada/Newfoundland': 'Newfoundland (GMT -3:30)',
  'America/Sao_Paulo': 'Brasilia (GMT -3:00)',
  'America/Argentina/Buenos_Aires': 'Buenos Aires (GMT -3:00)',
  'America/Godthab': 'Greenland (GMT -3:00)',
  'Atlantic/South_Georgia': 'Mid-Atlantic (GMT -2:00)',
  'Atlantic/Cape_Verde': 'Cape Verde Islands (GMT -1:00)',
  'Atlantic/Azores': 'Azores (GMT -1:00)',
  'Europe/London': 'Dublin, Edinburgh, Lisbon, London (GMT +0:00)',
  'Africa/Monrovia': 'Monrovia (GMT +0:00)',
  'Africa/Casablanca': 'Casablanca (GMT +0:00)',
  'UTC': 'UTC (GMT +0:00)',
  'Europe/Belgrade':
      'Belgrade, Bratislava, Budapest, Ljubljana, Prague (GMT +1:00)',
  'Europe/Warsaw': 'Sarajevo, Skopje, Warsaw, Zagreb (GMT +1:00)',
  'Europe/Paris': 'Brussels, Copenhagen, Madrid, Paris (GMT +1:00)',
  'Europe/Berlin':
      'Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna (GMT +1:00)',
  'Africa/Lagos': 'West Central Africa (GMT +1:00)',
  'Europe/Athens': 'Athens, Bucharest, Istanbul (GMT +2:00)',
  'Europe/Helsinki':
      'Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius (GMT +2:00)',
  'Africa/Cairo': 'Cairo (GMT +2:00)',
  'Asia/Damascus': 'Damascus (GMT +2:00)',
  'Asia/Jerusalem': 'Jerusalem (GMT +2:00)',
  'Africa/Harare': 'Harare, Pretoria (GMT +2:00)',
  'Asia/Baghdad': 'Baghdad (GMT +3:00)',
  'Europe/Moscow': 'Moscow, St. Petersburg, Volgograd (GMT +3:00)',
  'Asia/Kuwait': 'Kuwait, Riyadh (GMT +3:00)',
  'Africa/Nairobi': 'Nairobi (GMT +3:00)',
  'Asia/Tehran': 'Tehran (GMT +3:30)',
  'Asia/Baku': 'Baku (GMT +4:00)',
  'Asia/Tbilisi': 'Tbilisi (GMT +4:00)',
  'Asia/Yerevan': 'Yerevan (GMT +4:00)',
  'Asia/Dubai': 'Dubai (GMT +4:00)',
  'Asia/Kabul': 'Kabul (GMT +4:30)',
  'Asia/Karachi': 'Pakistan Standard Time (GMT +5:00)',
  'Asia/Calcutta': 'Chennai, Kolkata, Mumbai, New Delhi (GMT +5:30)',
  'Asia/Colombo': 'Sri Jayawardenepura (GMT +5:30)',
  'Asia/Kathmandu': 'Kathmandu (GMT +5:45)',
  'Asia/Dhaka': 'Astana, Dhaka (GMT +6:00)',
  'Asia/Almaty': 'Almaty (GMT +6:00)',
  'Asia/Rangoon': 'Rangoon (GMT +6:30)',
  'Asia/Bangkok': 'Bangkok, Hanoi, Jakarta (GMT +7:00)',
  'Asia/Irkutsk': 'Novosibirsk (GMT +7:00)',
  'Asia/Shanghai': 'Beijing, Chongqing, Hong Kong, Urumqi (GMT +8:00)',
  'Asia/Singapore': 'Singapore (GMT +8:00)',
  'Australia/Perth': 'Perth (GMT +8:00)',
  'Asia/Taipei': 'Taipei (GMT +8:00)',
  'Asia/Ulaanbaatar': 'Ulaanbaatar (GMT +8:00)',
  'Asia/Tokyo': 'Osaka, Sapporo, Tokyo (GMT +9:00)',
  'Asia/Seoul': 'Seoul (GMT +9:00)',
  'Asia/Yakutsk': 'Yakutsk (GMT +9:00)',
  'Australia/Adelaide': 'Adelaide (GMT +9:30)',
  'Australia/Darwin': 'Darwin (GMT +9:30)',
  'Australia/Brisbane': 'Brisbane (GMT +10:00)',
  'Australia/Sydney': 'Canberra, Melbourne, Sydney (GMT +10:00)',
  'Australia/Hobart': 'Hobart (GMT +10:00)',
  'Pacific/Guam': 'Guam, Port Moresby (GMT +10:00)',
  'Asia/Vladivostok': 'Vladivostok (GMT +10:00)',
  'Pacific/Guadalcanal': 'Solomon Islands (GMT +11:00)',
  'Pacific/Noumea': 'New Caledonia (GMT +11:00)',
  'Asia/Magadan': 'Magadan (GMT +12:00)',
  'Pacific/Auckland': 'Auckland, Wellington (GMT +12:00)',
  'Pacific/Fiji': 'Fiji (GMT +12:00)',
  'Pacific/Tongatapu': 'Nuku\'alofa (GMT +13:00)',
  'Pacific/Samoa': 'Samoa (GMT +13:00)',
};

late SharedPreferences sf;
Future<void> injectionFunction() async {
  sf = await SharedPreferences.getInstance();
}
