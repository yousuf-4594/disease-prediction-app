import 'package:shared_preferences/shared_preferences.dart';

class Languages {
  static String language = "en";

  static void setLanguage(String lang) async {
    print("language changing to " + lang);
    language = lang;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
  }


  static Future<void> initLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language') ?? 'en';
  }

  static String? translate(String key) {
    print(language);
    switch (language) {
      case 'ar':
        return _arabicTranslations[key];
      default:
        return _englishTranslations[key];
    }
  }

  static final Map<String, String> _englishTranslations = {
    'title': 'My Flutter App',
    'hello': 'Hello, World!',
    'welcome': 'Welcome',
    'My Plants': 'My Plants',
    'View Your history': 'View Your history',
    'Scan': 'Scan',
    'Try to scan the plants to know the type' : 'Try to scan the plants to know the type',
    'Start up your garden': 'Start up your garden',
    'Step by step instruction': 'Step by step instruction',
    'History': 'History',
    'Please login first to check history': 'Please login first to check history',
    "SCAN YOUR PLANT": "Scan your plant",
    'STEPS TO BUILD YOUR GARDEN': 'STEPS TO BUILD YOUR GARDEN',
    'tomato': 'tomato',
    'Grow a tomato': 'Grow a tomato',
    'STEPS TO GROW A TOMATO': 'Steps to grow a tomato',
    'SCANNED': 'Scanned',
    'Save': 'Save',
    'Identify Disease': 'Identify Disease',
    'Cancel': 'Cancel',
    'Identified Disease': 'Identified Disease',
    'Remedy': 'Remedy',
    'OK':'OK',
    'Close':'Close',
    'Treatment': 'Treatment',
    

  };

  static final Map<String, String> _arabicTranslations = {
    'title': 'تطبيقي فلاتر',
    'hello': 'مرحباً بالعالم!',
    'welcome': 'مرحباً',
    'My Plants': 'نباتاتي',
    'View Your history': 'عرض تاريخي',
    'Scan': 'مسح',
    'Try to scan the plants to know the type' : 'مسح النباتات للعرض على التصفير',
    'Start up your garden' : 'ابدأ حديقتك',
    'Step by step instruction' : 'تعليمات خطوة بخطوة',
    'History': 'تاريخ',
    'Please login first to check history': "لرجاء تسجيل الدخول أولا للتحقق من التاريخ",
    'SCAN YOUR PLANT': 'افحص مصنعك',
    'STEPS TO BUILD YOUR GARDEN': 'خطوات لبناء حديقتك',
    'tomato': 'طماطم',
    'Grow a tomato': "زراعة الطماطم",
    'STEPS TO GROW A TOMATO': "خطوات زراعة الطماطم",
    'SCANNED': "تم المسح",
    'Save': 'يحفظ',
    'Identify Disease': "تحديد المرض",
    'Cancel': 'يلغي',
    'Identified Disease': "مرض محدد",
    'Remedy': 'علاج',
    'OK': 'نعم',
    'Close': 'يغلق',
    'Treatment': 'علاج',




  };
}
