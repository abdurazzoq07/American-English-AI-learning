import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;
  String get languageCode => locale.languageCode;

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations) ??
      const AppLocalizations(Locale('uz'));

  String translate(String source) {
    final language = languageCode;
    if (language == 'uz') return source;
    final direct = _translations[source]?[language];
    if (direct != null) return direct;
    return _translateDynamic(source, language) ?? source;
  }

  String? _translateDynamic(String source, String language) {
    final words = RegExp(r'^(\d+) / (\d+) ta so‘z$').firstMatch(source);
    if (words != null) {
      return language == 'ru'
          ? '${words[1]} / ${words[2]} слов'
          : '${words[1]} / ${words[2]} words';
    }
    final minutes = RegExp(r'^(\d+) daqiqa( jami)?$').firstMatch(source);
    if (minutes != null) {
      if (language == 'ru') {
        return '${minutes[1]} мин.${minutes[2] == null ? '' : ' всего'}';
      }
      return '${minutes[1]} min${minutes[2] == null ? '' : ' total'}';
    }
    final count = RegExp(r'^(\d+) to‘g‘ri$').firstMatch(source);
    if (count != null) {
      return language == 'ru'
          ? '${count[1]} правильных'
          : '${count[1]} correct';
    }
    final sayWord = RegExp(r'^“(.+)” deb ayting$').firstMatch(source);
    if (sayWord != null) {
      return language == 'ru'
          ? 'Произнесите «${sayWord[1]}»'
          : 'Say “${sayWord[1]}”';
    }
    final lessons = RegExp(r'^(\d+) qisqa dars · A1 dan B1 gacha$')
        .firstMatch(source);
    if (lessons != null) {
      return language == 'ru'
          ? '${lessons[1]} коротких уроков · от A1 до B1'
          : '${lessons[1]} short lessons · A1 to B1';
    }
    final lessonCount = RegExp(r'^(\d+) / (\d+) ta dars$').firstMatch(source);
    if (lessonCount != null) {
      return language == 'ru'
          ? '${lessonCount[1]} / ${lessonCount[2]} уроков'
          : '${lessonCount[1]} / ${lessonCount[2]} lessons';
    }
    final lessonProgress = RegExp(r'^(\d+) / (\d+) ta dars yakunlandi$')
        .firstMatch(source);
    if (lessonProgress != null) {
      return language == 'ru'
          ? 'Завершено уроков: ${lessonProgress[1]} / ${lessonProgress[2]}'
          : '${lessonProgress[1]} / ${lessonProgress[2]} lessons completed';
    }
    final speakingHero = RegExp(
      r'^(\d+) ta so‘z o‘rganildi\. Har kuni mashq qilib, ishonch bilan gapiring\.$',
    ).firstMatch(source);
    if (speakingHero != null) {
      return language == 'ru'
          ? 'Выучено слов: ${speakingHero[1]}. Практикуйтесь каждый день и говорите увереннее.'
          : '${speakingHero[1]} words learned. Practice daily and speak with confidence.';
    }
    final days = RegExp(r'^(\d+) faol kun · (\d+) yakunlangan mashq$')
        .firstMatch(source);
    if (days != null) {
      return language == 'ru'
          ? '${days[1]} активных дней · занятий завершено: ${days[2]}'
          : '${days[1]} active days · ${days[2]} sessions completed';
    }
    final learned = RegExp(
      r'^(\d+) ta so‘z o‘rganildi\. Bugungi mashqni boshlashga tayyormisiz\?$',
    ).firstMatch(source);
    if (learned != null) {
      return language == 'ru'
          ? 'Вы выучили ${learned[1]} слов. Готовы начать сегодняшнюю практику?'
          : 'You have learned ${learned[1]} words. Ready to start today’s practice?';
    }
    final goal = RegExp(
      r'^(\d+) / 10 jami so‘z  ·  (mashqlar bajarilgan|birinchi mashqni boshlang)$',
    ).firstMatch(source);
    if (goal != null) {
      final activity = goal[2] == 'mashqlar bajarilgan';
      if (language == 'ru') {
        return '${goal[1]} / 10 слов всего · ${activity ? 'занятия выполнены' : 'начните первое занятие'}';
      }
      return '${goal[1]} / 10 words total · ${activity ? 'sessions completed' : 'start your first session'}';
    }
    final answer = RegExp(r'^To‘g‘ri javob: (.+)$').firstMatch(source);
    if (answer != null) {
      return language == 'ru'
          ? 'Правильный ответ: ${answer[1]}'
          : 'Correct answer: ${answer[1]}';
    }
    final connection = RegExp(
      r'^Ulanishda muammo: (.+)$',
      dotAll: true,
    ).firstMatch(source);
    if (connection != null) {
      return language == 'ru'
          ? 'Проблема с подключением: ${connection[1]!.replaceFirst('\n\nAPI manzili, model va internet aloqasini tekshirib ko‘ring.', '\n\nПроверьте адрес API, модель и подключение к интернету.')}'
          : 'Connection problem: ${connection[1]!.replaceFirst('\n\nAPI manzili, model va internet aloqasini tekshirib ko‘ring.', '\n\nCheck the API URL, model, and internet connection.')}';
    }
    final saveError = RegExp(r'^Saqlab bo‘lmadi: (.+)$').firstMatch(source);
    if (saveError != null) {
      return language == 'ru'
          ? 'Не удалось сохранить: ${saveError[1]}'
          : 'Could not save: ${saveError[1]}';
    }
    return null;
  }

  static const Map<String, Map<String, String>> _translations = {
    // Navigation and app shell
    'Bugun': {'en': 'Today', 'ru': 'Сегодня'},
    'Suhbat': {'en': 'Conversation', 'ru': 'Разговор'},
    'Lug‘at': {'en': 'Vocabulary', 'ru': 'Словарь'},
    'Mashq': {'en': 'Practice', 'ru': 'Практика'},
    'Darslar': {'en': 'Lessons', 'ru': 'Уроки'},
    'Dars': {'en': 'Lesson', 'ru': 'Урок'},
    'Bugungi reja': {'en': 'Today’s plan', 'ru': 'План на сегодня'},
    'Inglizcha suhbat': {
      'en': 'English conversation',
      'ru': 'Разговор на английском',
    },
    '1000 ta so‘z': {'en': '1,000 words', 'ru': '1 000 слов'},
    'Talaffuz va test': {
      'en': 'Pronunciation and quiz',
      'ru': 'Произношение и тест',
    },
    'Grammatika': {'en': 'Grammar', 'ru': 'Грамматика'},
    'AI sozlamalari': {'en': 'AI settings', 'ru': 'Настройки ИИ'},
    'American English': {'en': 'American English', 'ru': 'American English'},
    'CEFR o‘quv yo‘li': {
      'en': 'CEFR learning path',
      'ru': 'Путь обучения CEFR',
    },
    'A1 dan C2 gacha darslar': {
      'en': 'Lessons from A1 to C2',
      'ru': 'Уроки от A1 до C2',
    },
    'AMERICAN ENGLISH  •  SPEAKING PATH': {
      'en': 'AMERICAN ENGLISH  •  SPEAKING PATH',
      'ru': 'AMERICAN ENGLISH  •  ПРАКТИКА РЕЧИ',
    },
    'Ingliz tilida\ndadil gapiring.': {
      'en': 'Speak English\nwith confidence.',
      'ru': 'Говорите по-английски\nуверенно.',
    },

    // Home screen
    'faol kun': {'en': 'active days', 'ru': 'активных дней'},
    'daq. taxmin': {'en': 'min. est.', 'ru': 'мин. примерно'},
    'so‘z': {'en': 'words', 'ru': 'слов'},
    'Bugungi kichik qadam': {
      'en': 'A small step today',
      'ru': 'Небольшой шаг сегодня',
    },
    'Statistika': {'en': 'Statistics', 'ru': 'Статистика'},
    'Qayerdan davom etamiz?': {
      'en': 'Where shall we continue?',
      'ru': 'С чего продолжим?',
    },
    'AI bilan suhbat': {'en': 'AI conversation', 'ru': 'Разговор с ИИ'},
    'Fikrni inglizcha ayting': {
      'en': 'Express yourself in English',
      'ru': 'Выражайте мысли по-английски',
    },
    'So‘z kartalari': {'en': 'Word cards', 'ru': 'Карточки слов'},
    '1000 ta asosiy so‘z': {
      'en': '1,000 essential words',
      'ru': '1 000 основных слов',
    },
    'Talaffuz': {'en': 'Pronunciation', 'ru': 'Произношение'},
    'Tinglang va aytib ko‘ring': {
      'en': 'Listen and try saying it',
      'ru': 'Послушайте и повторите',
    },
    'Qisqa, tushunarli darslar': {
      'en': 'Short, clear lessons',
      'ru': 'Короткие и понятные уроки',
    },
    'GAPIRISH': {'en': 'SPEAKING', 'ru': 'РАЗГОВОР'},
    'LUG‘AT': {'en': 'VOCABULARY', 'ru': 'СЛОВАРЬ'},
    'AMALIYOT': {'en': 'PRACTICE', 'ru': 'ПРАКТИКА'},
    'DARS': {'en': 'LESSON', 'ru': 'УРОК'},
    'BUGUN  •  10 DAQIQA': {
      'en': 'TODAY  •  10 MINUTES',
      'ru': 'СЕГОДНЯ  •  10 МИНУТ',
    },
    'Har kuni ozgina —\nkatta natija.': {
      'en': 'A little every day —\nbig progress.',
      'ru': 'Понемногу каждый день —\nбольшой результат.',
    },
    'Mashqni boshlash': {'en': 'Start practicing', 'ru': 'Начать занятие'},
    'Maqsad sari qadam': {'en': 'Steps toward your goal', 'ru': 'Шаги к цели'},
    'mashqlar bajarilgan': {
      'en': 'sessions completed',
      'ru': 'занятия выполнены',
    },
    'birinchi mashqni boshlang': {
      'en': 'start your first session',
      'ru': 'начните первое занятие',
    },
    '5 ta so‘z': {'en': '5 words', 'ru': '5 слов'},
    'Lug‘at, grammatika va natijalar qurilmangizda saqlanadi. AI suhbat uchun o‘zingizning API kalitingizni sozlamalarda kiriting.':
        {
          'en': 'Vocabulary, grammar, and progress are stored on your device. Add your own API key in Settings to use AI conversation.',
          'ru': 'Словарь, грамматика и прогресс хранятся на устройстве. Чтобы использовать ИИ-диалог, добавьте свой API-ключ в настройках.',
        },

    // Conversation
    'AI ulanган · xatolar yumshoq tuzatiladi': {
      'en': 'AI connected · gentle corrections enabled',
      'ru': 'ИИ подключён · мягкие исправления включены',
    },
    'AI API kaliti sozlandi': {
      'en': 'AI API key configured',
      'ru': 'Ключ API ИИ настроен',
    },
    'AI suhbat uchun provayder kalitini sozlang': {
      'en': 'Set up a provider key for AI conversation',
      'ru': 'Укажите ключ провайдера для диалога с ИИ',
    },
    'Inglizcha javobingizni yozing…': {
      'en': 'Write your reply in English…',
      'ru': 'Напишите ответ по-английски…',
    },
    'Keling, gaplashamiz.': {'en': 'Let’s talk.', 'ru': 'Давайте поговорим.'},
    'Oddiy inglizcha jumladan boshlang. AI javob beradi va foydali tuzatishlarni ko‘rsatadi.':
        {
          'en': 'Start with a simple English sentence. AI will reply and suggest helpful corrections.',
          'ru': 'Начните с простого предложения на английском. ИИ ответит и предложит полезные исправления.',
        },
    'AI sozlamalarini ochish': {
      'en': 'Open AI settings',
      'ru': 'Открыть настройки ИИ',
    },
    'Javob tayyorlanmoqda…': {
      'en': 'Preparing a reply…',
      'ru': 'Готовим ответ…',
    },
    'Ovozli javobni boshlash': {
      'en': 'Start voice input',
      'ru': 'Начать голосовой ввод',
    },
    'Ovozli kiritishni to‘xtatish': {
      'en': 'Stop voice input',
      'ru': 'Остановить голосовой ввод',
    },
    'Qurilmada inglizcha ovoz xizmati mavjud emas.': {
      'en': 'An English speech voice is not available on this device.',
      'ru': 'На устройстве недоступен английский голосовой движок.',
    },
    'AI javobini ovoz chiqarib tinglash': {
      'en': 'Read the AI reply aloud',
      'ru': 'Прослушать ответ ИИ',
    },
    'Mikrofon yoki English (US) nutq xizmati mavjud emas. Ruxsat va qurilma sozlamalarini tekshiring.':
        {
          'en': 'Microphone or English (US) speech recognition is unavailable. Check permission and device settings.',
          'ru': 'Микрофон или распознавание речи English (US) недоступны. Проверьте разрешение и настройки устройства.',
        },
    'Nutqni tanish xatosi: ': {
      'en': 'Speech recognition error: ',
      'ru': 'Ошибка распознавания речи: ',
    },

    // Vocabulary
    'Qurilmada inglizcha ovoz topilmadi.': {
      'en': 'No English voice is available on this device.',
      'ru': 'На устройстве не найден английский голос.',
    },
    'Lug‘atni ochib bo‘lmadi. Ilovani qayta build qiling.': {
      'en': 'Could not open the vocabulary. Rebuild the app.',
      'ru': 'Не удалось открыть словарь. Пересоберите приложение.',
    },
    'So‘z yoki tarjimani qidiring': {
      'en': 'Search words or translations',
      'ru': 'Поиск слов или переводов',
    },
    'Sevimlilar': {'en': 'Favorites', 'ru': 'Избранное'},
    'Mos so‘z topilmadi.': {
      'en': 'No matching words found.',
      'ru': 'Подходящие слова не найдены.',
    },
    'Ovozni tinglash': {
      'en': 'Play pronunciation',
      'ru': 'Прослушать произношение',
    },
    'Sevimlidan olish': {
      'en': 'Remove from favorites',
      'ru': 'Убрать из избранного',
    },
    'Sevimliga qo‘shish': {'en': 'Add to favorites', 'ru': 'В избранное'},
    'O‘rganildi': {'en': 'Learned', 'ru': 'Выучено'},
    'O‘rgandim': {'en': 'Mark as learned', 'ru': 'Отметить как выученное'},
    'Barchasi': {'en': 'All', 'ru': 'Все'},

    // Pronunciation and quizzes
    'So‘z testi': {'en': 'Word quiz', 'ru': 'Тест по словам'},
    'ESHITING  •  TAKRORLANG': {
      'en': 'LISTEN  •  REPEAT',
      'ru': 'СЛУШАЙТЕ  •  ПОВТОРЯЙТЕ',
    },
    'Inglizcha talaffuzni tinglash': {
      'en': 'Listen to the English pronunciation',
      'ru': 'Прослушать английское произношение',
    },
    'Tinglashni to‘xtatish': {
      'en': 'Stop listening',
      'ru': 'Остановить запись',
    },
    'Mikrofonga gapiring': {
      'en': 'Speak into the microphone',
      'ru': 'Произнесите в микрофон',
    },
    'Tinglayapman…': {'en': 'Listening…', 'ru': 'Слушаю…'},
    'Siz aytgan so‘z': {'en': 'What you said', 'ru': 'Распознанная речь'},
    'Boshqa so‘z': {'en': 'Another word', 'ru': 'Другое слово'},
    'Baholash nutqni tanish xizmati chiqargan matnni solishtiradi; fonema darajasidagi talaffuz tahlili emas.':
        {
          'en': 'The score compares the speech-recognition transcript; it is not phoneme-level pronunciation analysis.',
          'ru': 'Оценка сравнивает текст распознавания речи; это не фонемный анализ произношения.',
        },
    'Nutqni tanish xizmati topilmadi yoki mikrofon ruxsati kerak. Windows qo‘llovi beta holatida.':
        {
          'en': 'Speech recognition is unavailable or microphone permission is needed. Windows support is in beta.',
          'ru': 'Распознавание речи недоступно или требуется разрешение на микрофон. Поддержка Windows — бета-версия.',
        },
    'Lug‘at yuklanmadi.': {
      'en': 'Vocabulary could not be loaded.',
      'ru': 'Не удалось загрузить словарь.',
    },
    'SO‘ZNI TOPING': {'en': 'GUESS THE WORD', 'ru': 'УГАДАЙТЕ СЛОВО'},
    'Inglizchasini tanlang': {
      'en': 'Choose the English word',
      'ru': 'Выберите английское слово',
    },
    'Keyingi savol': {'en': 'Next question', 'ru': 'Следующий вопрос'},
    'Mikrofon ochilmadi. Ruxsatni va mikrofon ulanishini tekshiring.': {
      'en': 'The microphone did not start. Check permission and microphone connection.',
      'ru': 'Микрофон не запустился. Проверьте разрешение и подключение микрофона.',
    },
    'Bu qurilmada nutqni tanish xizmati yo‘q yoki mikrofonga ruxsat berilmagan.':
        {
          'en': 'Speech recognition is unavailable on this device, or microphone permission was denied.',
          'ru': 'Распознавание речи недоступно на устройстве или нет разрешения на микрофон.',
        },
    'Tinglash ishga tushmadi. Mikrofon ruxsatini tekshiring.': {
      'en': 'Listening could not start. Check microphone permission.',
      'ru': 'Не удалось начать запись. Проверьте разрешение на микрофон.',
    },
    'Yaxshi! Tizim aytganingizni namunaga yaqin deb topdi.': {
      'en': 'Nice! The system found your speech close to the sample.',
      'ru': 'Хорошо! Система сочла ваше произношение близким к образцу.',
    },
    'Qayta urinib ko‘ring. Avval namunaviy ovozni tinglab, sekinroq ayting.': {
      'en': 'Try again. Listen to the sample first, then speak more slowly.',
      'ru': 'Попробуйте ещё раз. Сначала послушайте образец и произнесите медленнее.',
    },

    // Grammar lessons
    'Darajangizni tanlang': {
      'en': 'Choose your level',
      'ru': 'Выберите уровень',
    },
    'A1 dan C2 gacha: qoida, tarjimali misollar va qisqa testlar.': {
      'en':
          'From A1 to C2: clear rules, translated examples, and short quizzes.',
      'ru': 'От A1 до C2: правила, примеры с переводом и короткие тесты.',
    },
    'Qadam-baqadam ravonlik sari': {
      'en': 'A step-by-step path to fluency',
      'ru': 'Шаг за шагом к свободной речи',
    },
    'Har bir darsda qoida, real misol va bilimni tekshiruvchi mashq bor.': {
      'en':
          'Every lesson includes a rule, real examples, and a knowledge check.',
      'ru': 'В каждом уроке есть правило, примеры и проверочное упражнение.',
    },
    'Daraja yakunlandi': {'en': 'Level completed', 'ru': 'Уровень завершён'},
    'Darslarni ko‘rish': {'en': 'View lessons', 'ru': 'Открыть уроки'},
    'CEFR daraja belgilari o‘quv yo‘li uchun taxminiy tasnifdir; grammatika mavzularining yagona rasmiy CEFR ro‘yxati emas.':
        {
          'en': 'CEFR labels here are a practical learning guide, not an official universal list of grammar topics.',
          'ru': 'Уровни CEFR здесь — ориентир для обучения, а не официальный универсальный список грамматических тем.',
        },
    'Darslar va amaliyot': {
      'en': 'Lessons and practice',
      'ru': 'Уроки и практика',
    },
    'Misollar va tarjima': {
      'en': 'Examples and translations',
      'ru': 'Примеры и перевод',
    },
    'Bilimingizni tekshiring': {
      'en': 'Check your understanding',
      'ru': 'Проверьте знания',
    },
    'Dars yakunlangach, natija va test javobi ushbu qurilmada saqlanadi.': {
      'en': 'Lesson completion and quiz results are saved on this device.',
      'ru':
          'Завершение урока и результаты теста сохраняются на этом устройстве.',
    },
    'Boshlang‘ich': {'en': 'Beginner', 'ru': 'Начальный'},
    'Eng zarur kundalik iboralar va sodda gaplar.': {
      'en': 'Essential everyday phrases and simple sentences.',
      'ru': 'Основные повседневные фразы и простые предложения.',
    },
    'Elementar': {'en': 'Elementary', 'ru': 'Элементарный'},
    'Tanish vaziyatlarda gapirish va oddiy reja tuzish.': {
      'en': 'Talk about familiar situations and make simple plans.',
      'ru': 'Общение в знакомых ситуациях и простые планы.',
    },
    'O‘rta': {'en': 'Intermediate', 'ru': 'Средний'},
    'Tajriba, sabab va fikrlarni bog‘lab ifodalash.': {
      'en': 'Connect experiences, reasons, and opinions.',
      'ru': 'Связно выражать опыт, причины и мнение.',
    },
    'O‘rtadan yuqori': {'en': 'Upper-intermediate', 'ru': 'Выше среднего'},
    'Murakkab fikrlar va ravon muloqot uchun grammatika.': {
      'en': 'Grammar for complex ideas and fluent communication.',
      'ru': 'Грамматика для сложных мыслей и свободного общения.',
    },
    'Ilg‘or': {'en': 'Advanced', 'ru': 'Продвинутый'},
    'Rasmiy va akademik ingliz tilining nozik tuzilmalari.': {
      'en': 'Subtle structures used in formal and academic English.',
      'ru': 'Тонкие конструкции формального и академического английского.',
    },
    'Mukammal': {'en': 'Proficient', 'ru': 'Свободное владение'},
    'Uslub, urg‘u va murakkab ma’nolarni aniq boshqarish.': {
      'en': 'Control style, emphasis, and nuanced meaning precisely.',
      'ru': 'Точное владение стилем, акцентами и оттенками смысла.',
    },
    'Odatlar va doimiy holatlar': {
      'en': 'Habits and general states',
      'ru': 'Привычки и постоянные состояния',
    },
    'Present Simple muntazam takrorlanadigan ishlar, odatlar va umumiy haqiqatlar uchun ishlatiladi. He/she/it bilan fe’lga odatda -s qo‘shiladi.':
        {
          'en': 'Present Simple is used for repeated actions, habits, and general truths. Add -s to the verb with he, she, or it.',
          'ru': 'Present Simple используется для повторяющихся действий, привычек и общих фактов. С he, she, it обычно добавляется -s.',
        },
    'Kim? Qanday? Qayerda?': {
      'en': 'Who? What? Where?',
      'ru': 'Кто? Какой? Где?',
    },
    'To be shaxs yoki narsaning kimligini, holatini va joylashuvini bildiradi. I bilan am, he/she/it bilan is, you/we/they bilan are ishlatiladi.':
        {
          'en': 'The verb “to be” describes identity, condition, or location. Use am with I, is with he/she/it, and are with you/we/they.',
          'ru': 'Глагол to be указывает на личность, состояние или местоположение. С I используется am, с he/she/it — is, с you/we/they — are.',
        },
    'Hozir sodir bo‘layotgan ish': {
      'en': 'An action happening now',
      'ru': 'Действие, происходящее сейчас',
    },
    'Hozir ayni paytda davom etayotgan ish uchun am/is/are va fe’lning -ing shaklidan foydalanamiz.':
        {
          'en': 'Use am/is/are plus the -ing form for an action happening right now.',
          'ru': 'Для действия, происходящего прямо сейчас, используйте am/is/are и форму глагола с -ing.',
        },
    'O‘tmishda tugagan ish': {
      'en': 'A completed past action',
      'ru': 'Завершённое действие в прошлом',
    },
    'Past Simple ma’lum o‘tgan vaqtda tugagan ishlarni ifodalaydi. Muntazam fe’llarga -ed qo‘shiladi, noto‘g‘ri fe’llarning shakli o‘zgaradi.':
        {
          'en': 'Past Simple describes actions completed at a specific time in the past. Regular verbs take -ed; irregular verbs change form.',
          'ru': 'Past Simple описывает действия, завершившиеся в определённый момент в прошлом. К правильным глаголам добавляется -ed, неправильные меняют форму.',
        },
    'Reja va niyatlar': {
      'en': 'Plans and intentions',
      'ru': 'Планы и намерения',
    },
    'Oldindan rejalashtirilgan ish va kuchli niyat uchun be going to ishlatiladi. To be shaklini ega bilan moslang.':
        {
          'en': 'Use be going to for planned actions and strong intentions. Match the form of “to be” to the subject.',
          'ru': 'Конструкцию be going to используют для запланированных действий и твёрдых намерений. Согласуйте to be с подлежащим.',
        },
    'Ingliz tilidagi artikllar': {
      'en': 'English articles',
      'ru': 'Артикли в английском языке',
    },
    'A/an noma’lum yoki ilk bor tilga olinayotgan birlik sanaladigan ot bilan keladi. An unli tovushdan oldin ishlatiladi. The esa ma’lum, suhbatdoshga tanish narsa uchun ishlatiladi.':
        {
          'en': 'Use a/an with a singular countable noun that is unknown or mentioned for the first time. Use an before a vowel sound. Use the for something specific or already known.',
          'ru': 'A/an ставятся перед исчисляемым существительным в единственном числе, если оно неизвестно или упоминается впервые. An используется перед гласным звуком. The — для конкретного или уже известного предмета.',
        },
    'Miqdor: biroz yoki bir nechta': {
      'en': 'Quantity: some or several',
      'ru': 'Количество: немного или несколько',
    },
    'Some odatda darak gaplarda, any esa so‘roq va inkor gaplarda ishlatiladi. Taklif yoki iltimoslarda some qo‘llanishi mumkin.':
        {
          'en': 'Some is usually used in affirmative sentences; any is common in questions and negatives. Some can also be used in offers and requests.',
          'ru': 'Some обычно используется в утвердительных предложениях, any — в вопросах и отрицаниях. Some также встречается в предложениях и просьбах.',
        },
    'Ikki narsani qiyoslash': {
      'en': 'Comparing two things',
      'ru': 'Сравнение двух предметов',
    },
    'Qisqa sifatlar bilan odatda -er, uzunroq sifatlar bilan more ishlatiladi. Taqqoslashdan keyin than keladi.':
        {
          'en': 'Short adjectives usually take -er; longer adjectives use more. Put than after the comparative.',
          'ru': 'К коротким прилагательным обычно добавляется -er, перед длинными ставится more. После сравнительной формы используется than.',
        },
    'Tajriba va hozirga ta’sir': {
      'en': 'Experience and present results',
      'ru': 'Опыт и результат, важный сейчас',
    },
    'Present Perfect have/has va past participle bilan yasaladi. Hayotiy tajriba yoki natijasi hozirga aloqador ishlar uchun ishlatiladi.':
        {
          'en': 'Present Perfect is formed with have/has and the past participle. It describes life experience or actions with a present result.',
          'ru': 'Present Perfect образуется с have/has и причастием прошедшего времени. Он описывает жизненный опыт или действия с результатом в настоящем.',
        },
    'Qoidani o‘qing, misollarni ko‘ring va oxirida o‘zingizni tekshiring.': {
      'en': 'Read the rule, review the examples, then test yourself.',
      'ru': 'Прочитайте правило, изучите примеры и проверьте себя.',
    },
    'Grammatika yo‘li': {'en': 'Grammar path', 'ru': 'Путь по грамматике'},
    'Yopish': {'en': 'Close', 'ru': 'Закрыть'},
    'Darsni tugatdim': {'en': 'Mark lesson complete', 'ru': 'Завершить урок'},
    'Saqlandi ✓': {'en': 'Saved ✓', 'ru': 'Сохранено ✓'},
    'To‘g‘ri! Ajoyib.': {'en': 'Correct! Great job.', 'ru': 'Верно! Отлично.'},

    // Statistics
    'O‘rganish statistikasi': {
      'en': 'Learning statistics',
      'ru': 'Статистика обучения',
    },
    'SIZNING O‘SISHINGIZ': {'en': 'YOUR PROGRESS', 'ru': 'ВАШ ПРОГРЕСС'},
    'yakunlangan mashq': {
      'en': 'sessions completed',
      'ru': 'занятий завершено',
    },
    'O‘rganilgan so‘z': {'en': 'Words learned', 'ru': 'Выученные слова'},
    'Sevimli so‘zlar': {'en': 'Favorite words', 'ru': 'Избранные слова'},
    'Yakunlangan dars': {'en': 'Lessons completed', 'ru': 'Завершённые уроки'},
    'Talaffuz urinishi': {
      'en': 'Pronunciation attempts',
      'ru': 'Попытки произношения',
    },
    'Nutqni tanish mosligi': {
      'en': 'Speech recognition match',
      'ru': 'Совпадение распознавания речи',
    },
    'Test aniqligi': {'en': 'Quiz accuracy', 'ru': 'Точность теста'},
    'Kichik marralar': {'en': 'Small milestones', 'ru': 'Небольшие достижения'},
    'Birinchi 10 ta so‘z': {'en': 'First 10 words', 'ru': 'Первые 10 слов'},
    'Jami 10 daqiqa (taxminiy)': {
      'en': '10 minutes total (estimated)',
      'ru': 'Всего 10 минут (примерно)',
    },
    'Natijalar ushbu qurilmada saqlanadi. Ilovani qayta o‘rnatsangiz ayrim platformalarda lokal ma’lumotlar o‘chib ketishi mumkin.':
        {
          'en': 'Progress is stored on this device. Reinstalling the app may remove local data on some platforms.',
          'ru': 'Прогресс хранится на этом устройстве. При переустановке приложения локальные данные на некоторых платформах могут быть удалены.',
        },

    // Settings
    'Sozlamalar': {'en': 'Settings', 'ru': 'Настройки'},
    'Til': {'en': 'Language', 'ru': 'Язык'},
    'Ilova tili': {'en': 'App language', 'ru': 'Язык приложения'},
    'Tizim tili': {'en': 'System language', 'ru': 'Язык системы'},
    'English': {'en': 'English', 'ru': 'Английский'},
    'Русский': {'en': 'Russian', 'ru': 'Русский'},
    'O‘zbekcha': {'en': 'Uzbek', 'ru': 'Узбекский'},
    'Mavzu': {'en': 'Theme', 'ru': 'Тема'},
    'Tizim bo‘yicha': {'en': 'System default', 'ru': 'Как в системе'},
    'Yorug‘': {'en': 'Light', 'ru': 'Светлая'},
    'Qorong‘i': {'en': 'Dark', 'ru': 'Тёмная'},
    'AI ulanishi': {'en': 'AI connection', 'ru': 'Подключение ИИ'},
    'OpenAI-compatible API': {
      'en': 'OpenAI-compatible API',
      'ru': 'API, совместимый с OpenAI',
    },
    'API manzili': {'en': 'API URL', 'ru': 'Адрес API'},
    'To‘liq URL kiriting': {
      'en': 'Enter a complete URL',
      'ru': 'Введите полный URL',
    },
    'Model nomi': {'en': 'Model name', 'ru': 'Название модели'},
    'Model nomini kiriting': {
      'en': 'Enter a model name',
      'ru': 'Введите название модели',
    },
    'API kalit': {'en': 'API key', 'ru': 'Ключ API'},
    'Kalit faqat ushbu qurilmada saqlanadi': {
      'en': 'The key is stored only on this device',
      'ru': 'Ключ хранится только на этом устройстве',
    },
    'API kaliti Android Keystore yoki Windows himoyalangan saqlash mexanizmida saqlanadi. AI xizmatidan foydalanish provayder hisobingizda to‘lov yoki limit talab qilishi mumkin.':
        {
          'en': 'The API key is stored using Android Keystore or Windows secure storage. Your provider may apply usage limits or charges for AI services.',
          'ru': 'Ключ API хранится в Android Keystore или защищённом хранилище Windows. Провайдер может ограничивать использование или взимать плату за ИИ-сервис.',
        },
    'AI sozlamalari xavfsiz saqlandi.': {
      'en': 'AI settings saved securely.',
      'ru': 'Настройки ИИ сохранены в защищённом хранилище.',
    },
    'Bekor': {'en': 'Cancel', 'ru': 'Отмена'},
    'Saqlanmoqda': {'en': 'Saving', 'ru': 'Сохранение'},
    'Saqlash': {'en': 'Save', 'ru': 'Сохранить'},
  };
}

String tr(BuildContext context, String source) =>
    AppLocalizations.of(context).translate(source);

/// Text widget that translates known interface copy at render time. English
/// learning examples and user/AI messages without catalog entries remain intact.
class LText extends StatelessWidget {
  const LText(
    this.data, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  final String? data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) => Text(
    data == null ? '' : tr(context, data!),
    style: style,
    strutStyle: strutStyle,
    textAlign: textAlign,
    textDirection: textDirection,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    textScaler: textScaler,
    maxLines: maxLines,
    semanticsLabel: semanticsLabel == null
        ? null
        : tr(context, semanticsLabel!),
    textWidthBasis: textWidthBasis,
    textHeightBehavior: textHeightBehavior,
    selectionColor: selectionColor,
  );
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture<AppLocalizations>(AppLocalizations(locale));

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
