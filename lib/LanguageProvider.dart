import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _languageCode = 'en';

  String get languageCode => _languageCode;

  LanguageProvider() {
    _loadLanguage();
  }

  void _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _languageCode = prefs.getString('languageCode') ?? 'en';
    notifyListeners();
  }

  void setLanguage(String code) async {
    _languageCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', code);
    notifyListeners();
  }

  static const Map<String, Map<String, String>> localizedStrings = {
    'en': {
      'app_title': 'Black Flipper',
      'settings': 'Settings',
      'favorites': 'Favorites',
      'following': 'Following',
      'market': 'Market',
      'home': 'Home',
      'search_hint': 'Enter item name or ID...',
      'popular_items': 'Popular Items',
      'notifications': 'Notifications',
      'overlay': 'Open Overlay (Beta)',
      'privacy_policy': 'Privacy Policy',
      'terms_conditions': 'Terms & Conditions',
      'full_app': 'Full App',
      'get_full_app': 'Get the full app now',
      'cancel': 'Cancel',
      'save': 'Save',
      'version': 'v1.0.0',
      'filter_title': 'Filters (Black Market)',
      'filter_market_title': 'Filters (Market)',
      'min_profit': 'Min Profit',
      'min_profit_percent': 'Min Profit Percent',
      'for_albion': 'for Albion Online',
      'user_agreement': 'User Agreement',
      'privacy_title': 'Privacy Policy',
      'ok': 'OK',
      'no_favorites_found': 'No favorites found',
      // Filter widget labels & dropdowns
      'item_type': 'Item Type',
      'tier': 'Tier',
      'enchant': 'Enchant',
      'quality': 'Quality',
      'weapons': 'Weapons',
      'armors': 'Armors',
      'mounts': 'Mounts',
      'offhand': 'Off-Hand',
      'gathering': 'Gathering',
      'accessories': 'Accessories',
      'other': 'Other',
      'normal': 'Normal',
      'medium': 'Medium',
      'good': 'Good',
      'very_good': 'Very Good',
      'excellent': 'Excellent',
      'buy_text': 'Buy',
      'item_text': 'Item',
      'city_text': 'City',
      'sell_text': 'Sell',
      'profit_text': 'Profit',
      'black_market': 'Black Market',
      'royal_city_market': 'Royal City Market',
      'done': 'Done',
      'language': 'Language',
      'last_updated': 'Last Updated',
      'profit_history': 'Profit History',
      'add_to_favorites': 'Add to Favorites',
      'remove_from_favorites': 'Remove from Favorites',
      'show_on_overlay': 'Show on Overlay',
      'details': 'Details',
      'reset': 'Reset',
      'no_items_found': 'No items found',
      'privacy_policy_content':'''This Privacy Policy explains what information we collect when you use the BlackFlipper application, why we collect this information, and how we use it.

1. Information We Collect

We respect the privacy of our users. Our application does NOT COLLECT personally identifiable information (such as name, surname, email, address, etc.). The information we collect is limited to the following:

a. Non-Personal Analytics Data:

Usage Data: Anonymous usage statistics, such as which screens are visited and how often, and which buttons are clicked. This data helps us better understand the application and improve the user experience.

Device Information: Anonymous technical information such as your device model, operating system version, and application version. This information is used to detect errors and resolve technical compatibility issues.

Crash Reports: Anonymous technical data that helps us understand the cause of a problem when the application crashes.

b. Data Collection Tools:
We may use industry-standard services such as Google Analytics for Firebase to collect this anonymous data.

2. Purpose of Using Information

We use the anonymous data we collect for the following purposes:

To analyze and improve the performance of the application.

To understand which features users use the most and to guide future developments.

To detect and fix errors and crashes.

3. Sharing of Information

We do not sell or rent the anonymous data we collect to third parties for marketing or other purposes. Data may only be shared with the analytics service providers mentioned above for the purpose of developing the application and under confidentiality agreements. If there is a legal obligation, information may be shared with authorized authorities.

4. Data Security

We take reasonable technical and administrative measures to ensure the security of the collected data. However, it is important to remember that no method of data transmission over the internet is 100% secure.

5. Children's Privacy

This application is not intended for children under the age of 13, and we do not knowingly collect data from them.

6. Changes to the Privacy Policy

We may update this Privacy Policy from time to time. Changes will be effective from the moment they are published on this page.

7. Contact

If you have any questions about this Privacy Policy, please contact us at circlicks0@gmail.com.''',
    'terms_conditions_content': '''Please read these Terms of Use carefully before using the BlackFlipper application.

Acceptance of Terms
By accessing or using the Application, you agree to be bound by these Terms. If you do not agree with any part of these Terms, you may not access or use the Application.

Purpose of the Application and Disclaimer

a. BlackFlipper is a third-party software designed as a helper tool to provide users with information by analyzing market data in the game Albion Online.

b. This Application is not affiliated with, endorsed by, or officially recognized by Sandbox Interactive GmbH, the developer of Albion Online. "Albion Online" is a registered trademark of Sandbox Interactive GmbH.

c. All data presented in the Application is sourced from community-driven and publicly available APIs, such as "The Albion Online Data Project." No guarantees are made regarding the accuracy, completeness, or timeliness of this data. Prices in the Albion Online market can change instantly, and there may be discrepancies between the data in the application and real-time in-game data.

User Responsibilities
a. The Application should be used solely for informational and analytical purposes. All in-game purchasing, selling, and investment decisions you make are entirely your responsibility.

b. The Application developer cannot be held responsible for any in-game financial loss or damage you may suffer as a result of transactions you make based on the data in the Application.

c. It is strictly prohibited to use the Application for illegal purposes, to engage in actions that would interfere with its operation, or to reverse-engineer it.

Intellectual Property
The Application itself, its source code, logo, design, and content (excluding community data) are the property of the Application developer and are protected by copyright laws.

Limitation of Liability
The Application is provided "AS IS" and "AS AVAILABLE." The developer makes no guarantees that the Application will be uninterrupted, error-free, or secure. The developer is not liable for any direct or indirect damages (such as in-game account issues, financial losses, etc.) arising from the use of the Application.

Changes to the Terms
We reserve the right to modify these Terms at any time. Changes will be effective as soon as they are published on this page. Your continued use of the Application after the modifications constitutes your acceptance of the new Terms.

Contact
If you have any questions regarding these Terms of Use, please contact us at circliks0@gmail.com.''',
    },
    'tr': {
      'app_title': 'Black Flipper',
      'settings': 'Ayarlar',
      'favorites': 'Favoriler',
      'following': 'Takip Edilenler',
      'market': 'Market',
      'home': 'Ana Sayfa',
      'search_hint': 'Eşya adı veya ID girin...',
      'popular_items': 'Popüler Eşyalar',
      'notifications': 'Bildirimler',
      'overlay': 'Overlay Aç (Beta)',
      'privacy_policy': 'Gizlilik Politikası',
      'terms_conditions': 'Kullanıcı Sözleşmesi',
      'full_app': 'Tam Sürüm',
      'get_full_app': 'Tam sürümü şimdi alın',
      'cancel': 'İptal',
      'save': 'Kaydet',
      'version': 'v1.0.0',
      'filter_title': 'Filtreler (Black Market)',
      'filter_market_title': 'Filtreler (Market)',
      'min_profit': 'Min Kâr',
      'min_profit_percent': 'Min Kâr Yüzdesi',
      'for_albion': 'Albion Online için',
      'user_agreement': 'Kullanıcı Sözleşmesi',
      'privacy_title': 'Gizlilik Politikası',
      'ok': 'Tamam',
      'no_favorites_found': 'Favoriler bulunamadı',
      // Filter widget labels & dropdowns
      'item_type': 'Eşya Türü',
      'tier': 'Tier',
      'enchant': 'Enchant',
      'quality': 'Kalite',
      'weapons': 'Silahlar',
      'armors': 'Zırhlar',
      'mounts': 'Binekler',
      'offhand': 'Off-Hand',
      'gathering': 'Toplayıcılık',
      'accessories': 'Aksesuarlar',
      'other': 'Diğer',
      'normal': 'Normal',
      'medium': 'Orta',
      'good': 'İyi',
      'very_good': 'Çok iyi',
      'excellent': 'Harika',
      'buy_text': 'Alış',
      'item_text': 'Eşya',
      'city_text': 'Şehir',
      'sell_text': 'Satış',
      'profit_text': 'Kâr',
      'black_market': 'Kara Pazar',
      'royal_city_market': 'Kraliyet Şehri Pazarı',
      'done': 'Tamam',
      'language': 'Dil',
      'last_updated': 'Son güncelleme',
      'profit_history': 'Kâr Geçmişi',
      'add_to_favorites': 'Favorilere Ekle',
      'remove_from_favorites': 'Favorilerden Kaldır',
      'show_on_overlay': 'Overlayda Göster',
      'details': 'Detaylar',
      'reset': 'Sıfırla',
      'no_items_found': 'Eşya bulunamadı',
      'privacy_policy_content':'''Bu Gizlilik Politikası, BlackFlipper uygulamasını kullandığınızda hangi bilgileri topladığımızı, bu bilgileri neden topladığımızı ve nasıl kullandığımızı açıklamaktadır.

1. Topladığımız Bilgiler
Kullanıcılarımızın gizliliğine saygı duyuyoruz. Uygulamamız, kişisel kimliğinizi ortaya çıkaracak bilgileri (ad, soyad, e-posta, adres vb.) TOPLAMAZ. Topladığımız bilgiler şunlarla sınırlıdır:

a. Kişisel Olmayan Analiz Verileri:

* Kullanım Verileri: Hangi ekranların ne sıklıkla ziyaret edildiği, hangi butonlara tıklandığı gibi anonim kullanım istatistikleri. Bu veriler, uygulamayı daha iyi anlamamıza ve kullanıcı deneyimini iyileştirmemize yardımcı olur.

* Cihaz Bilgileri: Cihazınızın modeli, işletim sistemi sürümü ve uygulama sürümü gibi anonim teknik bilgiler. Bu bilgiler, hataları tespit etmek ve teknik uyumluluk sorunlarını çözmek için kullanılır.

* Çökme Raporları (Crash Reports):
Uygulama çöktüğünde, sorunun nedenini anlamamıza yardımcı olacak anonim teknik veriler.

b. Veri Toplama Araçları:
Bu anonim verileri toplamak için Google Analytics for Firebase gibi standart endüstri servislerini kullanabiliriz.

2. Bilgilerin Kullanım Amacı
Topladığımız anonim verileri şu amaçlarla kullanırız:ali babapiro

Uygulamanın performansını analiz etmek ve iyileştirmek.

Kullanıcıların en çok hangi özellikleri kullandığını anlamak ve gelecekteki geliştirmelere yön vermek.

Hataları ve çökmeleri tespit edip düzeltmek.

3. Bilgilerin Paylaşımı
Topladığımız anonim verileri, pazarlama veya başka amaçlarla üçüncü partilere satmayız veya kiralamayız. Veriler, yalnızca yukarıda belirtilen analiz servis sağlayıcıları ile uygulamanın geliştirilmesi amacıyla ve gizlilik sözleşmeleri kapsamında paylaşılabilir. Yasal bir zorunluluk olması halinde, yetkili makamlarla bilgi paylaşımı yapılabilir.

4. Veri Güvenliği
Toplanan verilerin güvenliğini sağlamak için makul teknik ve idari önlemleri alıyoruz. Ancak internet üzerinden hiçbir veri aktarım yönteminin %100 güvenli olmadığını unutmamanız önemlidir.

5. Çocukların Gizliliği
Bu uygulama 13 yaşın altındaki çocuklara yönelik değildir ve bilerek onlardan veri toplamamaktadır.

6. Gizlilik Politikasında Değişiklik Yapılması
Bu Gizlilik Politikasını zaman zaman güncelleyebiliriz. Değişiklikler bu sayfada yayınlandığı andan itibaren geçerli olacaktır.

7. İletişim
Bu Gizlilik Politikası ile ilgili herhangi bir sorunuz varsa, lütfen bizimle circlicks0@gmail.com adresi üzerinden iletişime geçin.''',
      'terms_conditions_content': '''Lütfen BlackFlipper uygulamasını kullanmadan önce bu Kullanım Koşullarını dikkatlice okuyun.

1. Koşulların Kabulü
Uygulamaya erişerek veya onu kullanarak, bu Koşullara bağlı kalmayı kabul etmiş olursunuz. Bu Koşulların herhangi bir bölümünü kabul etmiyorsanız, Uygulamaya erişemez veya onu kullanamazsınız.

2. Uygulamanın Amacı ve Sorumluluk Reddi

a. BlackFlipper, bir üçüncü parti yazılımıdır ve Albion Online oyunundaki pazar verilerini analiz ederek kullanıcılara bilgi sunmayı amaçlayan bir yardımcı araçtır.

b. Bu Uygulama, Albion Online'ın geliştiricisi olan Sandbox Interactive GmbH ile hiçbir şekilde bağlantılı değildir, onlar tarafından desteklenmez veya resmi olarak tanınmaz. "Albion Online", Sandbox Interactive GmbH'nin tescilli ticari markasıdır.

c. Uygulamada sunulan tüm veriler, "The Albion Online Data Project" gibi topluluk tarafından yönetilen ve herkese açık API'lerden alınmaktadır. Bu verilerin doğruluğu, eksiksizliği veya güncelliği konusunda hiçbir garanti verilmemektedir. Albion Online pazarındaki fiyatlar anlık olarak değişebilir ve uygulamadaki verilerle gerçek zamanlı oyun içi veriler arasında farklılıklar olabilir.

3. Kullanıcı Sorumlulukları
a. Uygulama yalnızca bilgilendirme ve analiz amacıyla kullanılmalıdır. Oyun içinde yapacağınız tüm alım, satım ve yatırım kararları tamamen sizin sorumluluğunuzdadır.

b. Uygulamadaki verilere dayanarak yapacağınız işlemler sonucunda uğrayabileceğiniz herhangi bir oyun içi maddi kayıp veya zarardan Uygulama geliştiricisi sorumlu tutulamaz.

c. Uygulamayı yasa dışı amaçlar için kullanmak, uygulamanın çalışmasını engelleyecek eylemlerde bulunmak veya tersine mühendislik yapmak kesinlikle yasaktır.

4. Fikri Mülkiyet
Uygulamanın kendisi, kaynak kodu, logosu, tasarımı ve içeriği (topluluk verileri hariç) Uygulama geliştiricisinin mülkiyetindedir ve telif hakkı yasalarıyla korunmaktadır.

5. Sorumluluğun Sınırlandırılması
Uygulama, "OLDUĞU GİBİ" ve "MEVCUT OLDUĞU ŞEKLİYLE" sunulmaktadır. Geliştirici, uygulamanın kesintisiz, hatasız veya güvenli olacağına dair hiçbir garanti vermez. Uygulamanın kullanımından kaynaklanan doğrudan veya dolaylı hiçbir zarardan (oyun içi hesap sorunları, finansal kayıplar vb.) geliştirici sorumlu değildir.

6. Koşullarda Değişiklik Yapılması
Bu Koşulları herhangi bir zamanda değiştirme hakkımızı saklı tutarız. Değişiklikler bu sayfada yayınlandığı andan itibaren geçerli olacaktır. Değişikliklerden sonra Uygulamayı kullanmaya devam etmeniz, yeni Koşulları kabul ettiğiniz anlamına gelir.

7. İletişim
Bu Kullanım Koşulları ile ilgili herhangi bir sorunuz varsa, lütfen bizimle circliks0@gmail.com adresi üzerinden iletişime geçin.''',

    },
    'ru': {
      'app_title': 'Black Flipper',
      'settings': 'Настройки',
      'favorites': 'Избранное',
      'following': 'Подписки',
      'market': 'Рынок',
      'home': 'Главная',
      'search_hint': 'Введите название или ID предмета...',
      'popular_items': 'Популярные предметы',
      'notifications': 'Уведомления',
      'overlay': 'Открыть Overlay (Beta)',
      'privacy_policy': 'Политика конфиденциальности',
      'terms_conditions': 'Пользовательское соглашение',
      'full_app': 'Полная версия',
      'get_full_app': 'Получить полную версию',
      'cancel': 'Отмена',
      'save': 'Сохранить',
      'version': 'v1.0.0',
      'filter_title': 'Фильтры (Black Market)',
      'filter_market_title': 'Фильтры (Market)',
      'min_profit': 'Мин. прибыль',
      'min_profit_percent': 'Мин. % прибыли',
      'for_albion': 'для Albion Online',
      'user_agreement': 'Пользовательское соглашение',
      'privacy_title': 'Политика конфиденциальности',
      'ok': 'ОК',
      'no_favorites_found': 'Избранное не найдено',
      // Filter widget labels & dropdowns
      'item_type': 'Тип предмета',
      'tier': 'Тир',
      'enchant': 'Зачарование',
      'quality': 'Качество',
      'weapons': 'Оружие',
      'armors': 'Броня',
      'mounts': 'Маунты',
      'offhand': 'Офф-хенд',
      'gathering': 'Сбор',
      'accessories': 'Аксессуары',
      'other': 'Другое',
      'normal': 'Обычное',
      'medium': 'Среднее',
      'good': 'Хорошее',
      'very_good': 'Очень хорошее',
      'excellent': 'Отличное',
      'buy_text': 'Купить',
      'item_text': 'Предмет',
      'city_text': 'Город',
      'sell_text': 'Продать',
      'profit_text': 'Прибыль',
      'black_market': 'Черный рынок',
      'royal_city_market': 'Рынок королевского города',
      'done': 'Готово',
      'language': 'Язык',
      'last_updated': 'Последнее обновление',
      'profit_history': 'История прибыли',
      'add_to_favorites': 'Добавить в избранное',
      'remove_from_favorites': 'Удалить из избранного',
      'show_on_overlay': 'Показать в overlay',
      'details': 'Детали',
      'reset': 'Сбросить',
      'no_items_found': 'Предметы не найдены',
      'privacy_policy_content': '''Настоящая Политика конфиденциальности объясняет, какую информацию мы собираем, когда вы используете приложение BlackFlipper, почему мы ее собираем и как мы ее используем.

1. Собираемая нами информация

Мы уважаем конфиденциальность наших пользователей. Наше приложение НЕ СОБИРАЕТ информацию, позволяющую установить вашу личность (например, имя, фамилию, адрес электронной почты, адрес и т. д.). Информация, которую мы собираем, ограничивается следующим:

а. Неличные аналитические данные:

Данные об использовании: Анонимная статистика использования, например, какие экраны и как часто посещаются, какие кнопки нажимаются. Эти данные помогают нам лучше понять работу приложения и улучшить пользовательский опыт.

Информация об устройстве: Анонимная техническая информация, такая как модель вашего устройства, версия операционной системы и версия приложения. Эта информация используется для выявления ошибок и решения проблем технической совместимости.

Отчеты о сбоях (Crash Reports): Анонимные технические данные, которые помогают нам понять причину проблемы при сбое приложения.

б. Инструменты сбора данных:
Мы можем использовать стандартные отраслевые сервисы, такие как Google Analytics for Firebase, для сбора этих анонимных данных.

2. Цели использования информации

Мы используем собранные анонимные данные в следующих целях:

Для анализа и улучшения производительности приложения.

Чтобы понять, какие функции пользователи используют чаще всего, и определить направление будущих разработок.

Для обнаружения и исправления ошибок и сбоев.

3. Передача информации

Мы не продаем и не передаем в аренду собранные нами анонимные данные третьим лицам в маркетинговых или иных целях. Данные могут передаваться только поставщикам аналитических услуг, упомянутым выше, с целью улучшения приложения и в рамках соглашений о конфиденциальности. В случае юридического обязательства информация может быть передана уполномоченным органам власти.

4. Безопасность данных

Мы принимаем разумные технические и административные меры для обеспечения безопасности собранных данных. Однако важно помнить, что ни один метод передачи данных через Интернет не является на 100% безопасным.

5. Конфиденциальность детей

Это приложение не предназначено для детей младше 13 лет, и мы сознательно не собираем от них данные.

6. Внесение изменений в Политику конфиденциальности

Мы можем время от времени обновлять настоящую Политику конфиденциальности. Изменения вступают в силу с момента их публикации на этой странице.

7. Контакты

Если у вас есть какие-либо вопросы относительно настоящей Политики конфиденциальности, пожалуйста, свяжитесь с нами по адресу circlicks0@gmail.com.''',
      'terms_conditions_content':'''Пожалуйста, внимательно прочтите настоящие Условия использования перед использованием приложения BlackFlipper.

1. Принятие Условий
Получая доступ к Приложению или используя его, вы соглашаетесь соблюдать настоящие Условия. Если вы не согласны с какой-либо частью настоящих Условий, вы не можете получать доступ к Приложению или использовать его.

2. Назначение Приложения и Отказ от Ответственности

a. BlackFlipper — это стороннее программное обеспечение, разработанное как вспомогательный инструмент, предназначенный для предоставления пользователям информации путем анализа рыночных данных в игре Albion Online.

b. Это Приложение никоим образом не связано, не поддерживается и официально не признано Sandbox Interactive GmbH, разработчиком Albion Online. «Albion Online» является зарегистрированной торговой маркой Sandbox Interactive GmbH.

c. Все данные, представленные в Приложении, получены из общедоступных API, управляемых сообществом, таких как «The Albion Online Data Project». Не дается никаких гарантий относительно точности, полноты или своевременности этих данных. Цены на рынке Albion Online могут мгновенно меняться, и могут быть расхождения между данными в приложении и данными в реальном времени в игре.

3. Обязанности Пользователя
a. Приложение должно использоваться исключительно в информационных и аналитических целях. Все решения о покупке, продаже и инвестировании в игре, которые вы принимаете, являются полностью вашей ответственностью.

b. Разработчик Приложения не несет ответственности за любые внутриигровые финансовые потери или ущерб, которые вы можете понести в результате транзакций, совершенных вами на основе данных в Приложении.

c. Категорически запрещено использовать Приложение в незаконных целях, совершать действия, которые могут помешать его работе, или заниматься обратной инженерией.

4. Интеллектуальная Собственность
Само Приложение, его исходный код, логотип, дизайн и содержимое (за исключением данных сообщества) являются собственностью разработчика Приложения и защищены законами об авторском праве.

5. Ограничение Ответственности
Приложение предоставляется «КАК ЕСТЬ» и «ПО МЕРЕ ДОСТУПНОСТИ». Разработчик не дает никаких гарантий, что Приложение будет работать бесперебойно, без ошибок или безопасно. Разработчик не несет ответственности за любые прямые или косвенные убытки (такие как проблемы с внутриигровой учетной записью, финансовые потери и т.д.), возникающие в результате использования Приложения.

6. Внесение Изменений в Условия
Мы оставляем за собой право изменять настоящие Условия в любое время. Изменения вступают в силу с момента их публикации на этой странице. Ваше дальнейшее использование Приложения после внесения изменений означает ваше согласие с новыми Условиями.

7. Контакты
Если у вас есть какие-либо вопросы относительно настоящих Условий использования, пожалуйста, свяжитесь с нами по адресу circliks0@gmail.com.'''
    },
    'fr': {
      'app_title': 'Black Flipper',
      'settings': 'Paramètres',
      'favorites': 'Favoris',
      'following': 'Suivis',
      'market': 'Marché',
      'home': 'Accueil',
      'search_hint': 'Entrez le nom ou l\'ID de l\'objet...',
      'popular_items': 'Objets populaires',
      'notifications': 'Notifications',
      'overlay': 'Ouvrir Overlay (Beta)',
      'privacy_policy': 'Politique de confidentialité',
      'terms_conditions': 'Conditions d\'utilisation',
      'full_app': 'Version complète',
      'get_full_app': 'Obtenir la version complète',
      'cancel': 'Annuler',
      'save': 'Enregistrer',
      'version': 'v1.0.0',
      'filter_title': 'Filtres (Black Market)',
      'filter_market_title': 'Filtres (Market)',
      'min_profit': 'Profit min.',
      'min_profit_percent': 'Pourcentage min. de profit',
      'for_albion': 'pour Albion Online',
      'user_agreement': 'Conditions d\'utilisation',
      'privacy_title': 'Politique de confidentialité',
      'ok': 'OK',
      'no_favorites_found': 'Aucun favori trouvé',
      // Filter widget labels & dropdowns
      'item_type': 'Type d\'objet',
      'tier': 'Tier',
      'enchant': 'Enchantement',
      'quality': 'Qualité',
      'weapons': 'Armes',
      'armors': 'Armures',
      'mounts': 'Montures',
      'offhand': 'Main secondaire',
      'gathering': 'Récolte',
      'accessories': 'Accessoires',
      'other': 'Autre',
      'normal': 'Normal',
      'medium': 'Moyen',
      'good': 'Bon',
      'very_good': 'Très bon',
      'excellent': 'Excellent',
      'buy_text': 'Acheter',
      'item_text': 'Objet',
      'city_text': 'Ville',
      'sell_text': 'Vendre',
      'profit_text': 'Profit',
      'no_items_found': 'Aucun objet trouvé',
      'privacy_policy_content': '''Cette Politique de confidentialité décrit les informations que nous collectons lorsque vous utilisez l'application BlackFlipper, pourquoi nous les collectons et comment nous les utilisons.

1. Informations que nous collectons

Nous respectons la vie privée de nos utilisateurs. Notre application NE COLLECTE PAS d'informations permettant de vous identifier personnellement (telles que nom, prénom, e-mail, adresse, etc.). Les informations que nous collectons se limitent à ce qui suit :

a. Données d'analyse non personnelles :

Données d'utilisation : Statistiques d'utilisation anonymes, telles que les écrans visités et leur fréquence, et les boutons cliqués. Ces données nous aident à mieux comprendre l'application et à améliorer l'expérience utilisateur.

Informations sur l'appareil : Informations techniques anonymes telles que le modèle de votre appareil, la version de votre système d'exploitation et la version de l'application. Ces informations sont utilisées pour détecter les erreurs et résoudre les problèmes de compatibilité technique.

Rapports de plantage (Crash Reports) : Données techniques anonymes qui nous aident à comprendre la cause d'un problème lorsque l'application plante.

b. Outils de collecte de données :
Nous pouvons utiliser des services standards de l'industrie, tels que Google Analytics for Firebase, pour collecter ces données anonymes.

2. Finalité de l'utilisation des informations

Nous utilisons les données anonymes que nous collectons aux fins suivantes :

Analyser et améliorer les performances de l'application.

Comprendre quelles fonctionnalités les utilisateurs utilisent le plus pour orienter les développements futurs.

Détecter et corriger les erreurs et les plantages.

3. Partage des informations

Nous ne vendons ni ne louons les données anonymes que nous collectons à des tiers à des fins de marketing ou autres. Les données ne peuvent être partagées qu'avec les fournisseurs de services d'analyse mentionnés ci-dessus dans le but d'améliorer l'application et dans le cadre d'accords de confidentialité. En cas d'obligation légale, les informations peuvent être partagées avec les autorités compétentes.

4. Sécurité des données

Nous prenons des mesures techniques et administratives raisonnables pour assurer la sécurité des données collectées. Cependant, il est important de se rappeler qu'aucune méthode de transmission de données sur Internet n'est sécurisée à 100 %.

5. Confidentialité des enfants

Cette application n'est pas destinée aux enfants de moins de 13 ans, et nous ne collectons pas sciemment de données auprès d'eux.

6. Modifications de la Politique de confidentialité

Nous pouvons mettre à jour cette Politique de confidentialité de temps à autre. Les modifications entreront en vigueur dès leur publication sur cette page.

7. Contact

Si vous avez des questions concernant cette Politique de confidentialité, veuillez nous contacter à l'adresse circlicks0@gmail.com.''',
      'terms_conditions_content': '''Veuillez lire attentivement ces Conditions d'utilisation avant d'utiliser l'application BlackFlipper.

1. Acceptation des Conditions
En accédant ou en utilisant l'Application, vous acceptez d'être lié par ces Conditions. Si vous n'acceptez pas une partie de ces Conditions, vous ne pouvez pas accéder à l'Application ni l'utiliser.

2. But de l'Application et Exclusion de Responsabilité

a. BlackFlipper est un logiciel tiers conçu comme un outil d'aide pour fournir des informations aux utilisateurs en analysant les données du marché dans le jeu Albion Online.

b. Cette Application n'est en aucun cas affiliée, approuvée ou officiellement reconnue par Sandbox Interactive GmbH, le développeur d'Albion Online. "Albion Online" est une marque déposée de Sandbox Interactive GmbH.

c. Toutes les données présentées dans l'Application proviennent d'API gérées par la communauté et accessibles au public, telles que "The Albion Online Data Project". Aucune garantie n'est donnée quant à l'exactitude, l'exhaustivité ou l'actualité de ces données. Les prix sur le marché d'Albion Online peuvent changer instantanément, et il peut y avoir des écarts entre les données de l'application et les données en temps réel dans le jeu.

3. Responsabilités de l'Utilisateur
a. L'Application doit être utilisée uniquement à des fins d'information et d'analyse. Toutes les décisions d'achat, de vente et d'investissement que vous prenez dans le jeu sont entièrement de votre responsabilité.

b. Le développeur de l'Application ne peut être tenu responsable de toute perte financière ou de tout dommage que vous pourriez subir dans le jeu à la suite de transactions que vous effectuez sur la base des données de l'Application.

c. Il est strictement interdit d'utiliser l'Application à des fins illégales, de s'engager dans des actions qui pourraient interférer avec son fonctionnement, ou de faire de l'ingénierie inverse.

4. Propriété Intellectuelle
L'Application elle-même, son code source, son logo, son design et son contenu (à l'exception des données de la communauté) sont la propriété du développeur de l'Application et sont protégés par les lois sur le droit d'auteur.

5. Limitation de Responsabilité
L'Application est fournie "TELLE QUELLE" et "SELON SA DISPONIBILITÉ". Le développeur ne garantit pas que l'Application sera ininterrompue, exempte d'erreurs ou sécurisée. Le développeur n'est pas responsable des dommages directs ou indirects (tels que les problèmes de compte dans le jeu, les pertes financières, etc.) découlant de l'utilisation de l'Application.

6. Modifications des Conditions
Nous nous réservons le droit de modifier ces Conditions à tout moment. Les modifications seront effectives dès leur publication sur cette page. Votre utilisation continue de l'Application après les modifications constitue votre acceptation des nouvelles Conditions.

7. Contact
Si vous avez des questions concernant ces Conditions d'utilisation, veuillez nous contacter à l'adresse circliks0@gmail.com.''',
      'black_market': 'Marché noir',
      'royal_city_market': 'Marché de la ville royale',
      'done': 'Terminé',
      'language': 'Langue',
      'last_updated': 'Dernière mise à jour',
      'profit_history': 'Historique des profits',
      'add_to_favorites': 'Ajouter aux favoris',
      'remove_from_favorites': 'Retirer des favoris',
      'show_on_overlay': 'Afficher sur Overlay',
      'details': 'Détails',
      'reset': 'Réinitialiser',
    },
  };

  String getText(String key) {
    return localizedStrings[_languageCode]?[key] ?? localizedStrings['en']![key] ?? key;
  }
}