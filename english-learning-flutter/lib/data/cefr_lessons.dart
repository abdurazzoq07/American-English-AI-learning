import 'package:flutter/material.dart';

class LessonExample {
  const LessonExample(this.english, this.uzbek);
  final String english;
  final String uzbek;
}

class CefrLesson {
  const CefrLesson({
    required this.id,
    required this.level,
    required this.title,
    required this.subtitle,
    required this.explanation,
    required this.pattern,
    required this.examples,
    required this.question,
    required this.answer,
    required this.options,
  });

  /// IDs 0–8 retain the ordering of the original lessons, so saved completion
  /// progress continues to refer to the same lessons after this expansion.
  final int id;
  final String level;
  final String title;
  final String subtitle;
  final String explanation;
  final String pattern;
  final List<LessonExample> examples;
  final String question;
  final String answer;
  final List<String> options;
}

class CefrLevelInfo {
  const CefrLevelInfo({
    required this.code,
    required this.title,
    required this.description,
    required this.color,
  });
  final String code;
  final String title;
  final String description;
  final Color color;
}

const cefrLevels = <CefrLevelInfo>[
  CefrLevelInfo(
    code: 'A1',
    title: 'Boshlang‘ich',
    description: 'Eng zarur kundalik iboralar va sodda gaplar.',
    color: Color(0xFF4C8DFF),
  ),
  CefrLevelInfo(
    code: 'A2',
    title: 'Elementar',
    description: 'Tanish vaziyatlarda gapirish va oddiy reja tuzish.',
    color: Color(0xFF40B8D5),
  ),
  CefrLevelInfo(
    code: 'B1',
    title: 'O‘rta',
    description: 'Tajriba, sabab va fikrlarni bog‘lab ifodalash.',
    color: Color(0xFF8B7CFF),
  ),
  CefrLevelInfo(
    code: 'B2',
    title: 'O‘rtadan yuqori',
    description: 'Murakkab fikrlar va ravon muloqot uchun grammatika.',
    color: Color(0xFFE9A044),
  ),
  CefrLevelInfo(
    code: 'C1',
    title: 'Ilg‘or',
    description: 'Rasmiy va akademik ingliz tilining nozik tuzilmalari.',
    color: Color(0xFFEF729A),
  ),
  CefrLevelInfo(
    code: 'C2',
    title: 'Mukammal',
    description: 'Uslub, urg‘u va murakkab ma’nolarni aniq boshqarish.',
    color: Color(0xFF58C69A),
  ),
];

const cefrLessons = <CefrLesson>[
  // Original lessons; IDs remain stable for existing saved progress.
  CefrLesson(
    id: 0,
    level: 'A1',
    title: 'Present Simple',
    subtitle: 'Odatlar va doimiy holatlar',
    explanation: 'Present Simple muntazam takrorlanadigan ishlar, odatlar va umumiy haqiqatlar uchun ishlatiladi. He/she/it bilan fe’lga odatda -s qo‘shiladi.',
    pattern: 'I/You/We/They + verb  ·  He/She/It + verb-s',
    examples: [
      LessonExample(
        'I study English every day.',
        'Men har kuni ingliz tilini o‘rganaman.',
      ),
      LessonExample('She works at a hospital.', 'U shifoxonada ishlaydi.'),
      LessonExample('They do not drink coffee.', 'Ular qahva ichishmaydi.'),
    ],
    question: 'She ___ English every morning.',
    answer: 'studies',
    options: ['study', 'studies', 'studying'],
  ),
  CefrLesson(
    id: 1,
    level: 'A1',
    title: 'To be: am / is / are',
    subtitle: 'Kim? Qanday? Qayerda?',
    explanation: 'To be shaxs yoki narsaning kimligini, holatini va joylashuvini bildiradi. I bilan am, he/she/it bilan is, you/we/they bilan are ishlatiladi.',
    pattern: 'I am  ·  He/She/It is  ·  You/We/They are',
    examples: [
      LessonExample('I am a student.', 'Men talabaman.'),
      LessonExample('The room is quiet.', 'Xona tinch.'),
      LessonExample('We are at home.', 'Biz uydamiz.'),
    ],
    question: 'They ___ ready.',
    answer: 'are',
    options: ['am', 'is', 'are'],
  ),
  CefrLesson(
    id: 2,
    level: 'A2',
    title: 'Present Continuous',
    subtitle: 'Hozir sodir bo‘layotgan ish',
    explanation: 'Hozir davom etayotgan ish uchun am/is/are va fe’lning -ing shaklidan foydalanamiz.',
    pattern: 'Subject + am/is/are + verb-ing',
    examples: [
      LessonExample('I am reading now.', 'Men hozir o‘qiyapman.'),
      LessonExample('He is cooking dinner.', 'U kechki ovqat tayyorlayapti.'),
      LessonExample(
        'They are waiting outside.',
        'Ular tashqarida kutishyapti.',
      ),
    ],
    question: 'Look! It ___ outside.',
    answer: 'is raining',
    options: ['rains', 'is raining', 'rain'],
  ),
  CefrLesson(
    id: 3,
    level: 'A2',
    title: 'Past Simple',
    subtitle: 'O‘tmishda tugagan ish',
    explanation: 'Past Simple ma’lum o‘tgan vaqtda tugagan ishlarni ifodalaydi. Muntazam fe’llarga -ed qo‘shiladi, noto‘g‘ri fe’llarning shakli o‘zgaradi.',
    pattern: 'Subject + past verb  ·  did not + base verb',
    examples: [
      LessonExample(
        'We visited Samarkand last year.',
        'Biz o‘tgan yili Samarqandga bordik.',
      ),
      LessonExample('She went to work by bus.', 'U ishga avtobusda bordi.'),
      LessonExample('I did not see the message.', 'Men xabarni ko‘rmadim.'),
    ],
    question: 'He ___ his friend yesterday.',
    answer: 'called',
    options: ['calls', 'called', 'calling'],
  ),
  CefrLesson(
    id: 4,
    level: 'A2',
    title: 'Future: going to',
    subtitle: 'Reja va niyatlar',
    explanation: 'Oldindan rejalashtirilgan ish va kuchli niyat uchun be going to ishlatiladi. To be shaklini ega bilan moslang.',
    pattern: 'Subject + am/is/are + going to + verb',
    examples: [
      LessonExample(
        'I am going to practice tonight.',
        'Men bugun kechqurun mashq qilmoqchiman.',
      ),
      LessonExample(
        'She is going to travel in June.',
        'U iyun oyida sayohat qilmoqchi.',
      ),
      LessonExample(
        'We are going to cook together.',
        'Biz birga ovqat pishirmoqchimiz.',
      ),
    ],
    question: 'They ___ visit their family.',
    answer: 'are going to',
    options: ['is going to', 'are going to', 'going to'],
  ),
  CefrLesson(
    id: 5,
    level: 'A2',
    title: 'A / an / the',
    subtitle: 'Ingliz tilidagi artikllar',
    explanation: 'A/an noma’lum yoki ilk bor tilga olinayotgan birlik sanaladigan ot bilan keladi. An unli tovushdan oldin ishlatiladi. The esa ma’lum narsani bildiradi.',
    pattern: 'a book  ·  an apple  ·  the book on the table',
    examples: [
      LessonExample('I saw a bird.', 'Men bir qushni ko‘rdim.'),
      LessonExample('She ate an orange.', 'U apelsin yedi.'),
      LessonExample('The bird was blue.', 'Haligi qush ko‘k edi.'),
    ],
    question: 'He is ___ honest person.',
    answer: 'an',
    options: ['a', 'an', 'the'],
  ),
  CefrLesson(
    id: 6,
    level: 'B1',
    title: 'Some / any',
    subtitle: 'Miqdor: biroz yoki bir nechta',
    explanation: 'Some odatda darak gaplarda, any esa so‘roq va inkor gaplarda ishlatiladi. Taklif yoki iltimoslarda some qo‘llanishi mumkin.',
    pattern: 'some + plural/uncountable  ·  any in questions/negatives',
    examples: [
      LessonExample('We need some water.', 'Bizga biroz suv kerak.'),
      LessonExample('Do you have any questions?', 'Savollaringiz bormi?'),
      LessonExample('There are not any chairs.', 'Hech qanday stul yo‘q.'),
    ],
    question: 'Would you like ___ tea?',
    answer: 'some',
    options: ['some', 'any', 'many'],
  ),
  CefrLesson(
    id: 7,
    level: 'B1',
    title: 'Comparatives',
    subtitle: 'Ikki narsani qiyoslash',
    explanation: 'Qisqa sifatlar bilan odatda -er, uzunroq sifatlar bilan more ishlatiladi. Taqqoslashdan keyin than keladi.',
    pattern: 'short adjective-er + than  ·  more + adjective + than',
    examples: [
      LessonExample(
        'This road is longer than that one.',
        'Bu yo‘l unisidan uzunroq.',
      ),
      LessonExample(
        'English is more useful for my job.',
        'Ingliz tili ishim uchun foydaliroq.',
      ),
      LessonExample(
        'Today is warmer than yesterday.',
        'Bugun kechagidan iliqroq.',
      ),
    ],
    question: 'This test is ___ than the last one.',
    answer: 'easier',
    options: ['easy', 'easier', 'more easy'],
  ),
  CefrLesson(
    id: 8,
    level: 'B1',
    title: 'Present Perfect',
    subtitle: 'Tajriba va hozirga ta’sir',
    explanation: 'Present Perfect have/has va past participle bilan yasaladi. Hayotiy tajriba yoki natijasi hozirga aloqador ishlar uchun ishlatiladi.',
    pattern: 'Subject + have/has + past participle',
    examples: [
      LessonExample(
        'I have visited London once.',
        'Men Londonga bir marta borganman.',
      ),
      LessonExample(
        'She has finished her homework.',
        'U uy vazifasini tugatdi.',
      ),
      LessonExample('Have you ever tried sushi?', 'Sushi yeb ko‘rganmisiz?'),
    ],
    question: 'She ___ already ___ her work.',
    answer: 'has finished',
    options: ['has finish', 'has finished', 'have finished'],
  ),
  CefrLesson(
    id: 9,
    level: 'A1',
    title: 'Subject pronouns',
    subtitle: 'Ega olmoshlari va fe’l',
    explanation: 'I, you, he, she, it, we va they gapda egani bildiradi. Olmosh fe’l bilan mos bo‘lishi kerak; he/she/it bilan Present Simple fe’liga odatda -s qo‘shiladi.',
    pattern: 'I work  ·  She works  ·  They work',
    examples: [
      LessonExample('He lives in Tashkent.', 'U Toshkentda yashaydi.'),
      LessonExample(
        'We speak Uzbek at home.',
        'Biz uyda o‘zbekcha gaplashamiz.',
      ),
    ],
    question: 'My sister ___ near the school.',
    answer: 'lives',
    options: ['live', 'lives', 'living'],
  ),
  CefrLesson(
    id: 10,
    level: 'A1',
    title: 'There is / There are',
    subtitle: 'Borligini va joylashuvni aytish',
    explanation: 'There is birlikdagi ot bilan, there are ko‘plikdagi ot bilan ishlatiladi. Joyni ko‘rsatish uchun in, on va under kabi predloglar keladi.',
    pattern: 'There is + singular  ·  There are + plural',
    examples: [
      LessonExample(
        'There is a book on the desk.',
        'Stol ustida bitta kitob bor.',
      ),
      LessonExample(
        'There are two parks near my home.',
        'Uyim yaqinida ikkita bog‘ bor.',
      ),
    ],
    question: 'There ___ three apples in the bowl.',
    answer: 'are',
    options: ['is', 'are', 'am'],
  ),
  CefrLesson(
    id: 11,
    level: 'A2',
    title: 'Can / have to / must',
    subtitle: 'Qobiliyat, qoida va zarurat',
    explanation: 'Can qobiliyat yoki imkoniyatni, must kuchli zaruratni bildiradi. Have to tashqi qoida yoki majburiyatni ifodalaydi. Modal fe’ldan keyin fe’lning oddiy shakli keladi.',
    pattern: 'can/must + base verb  ·  have/has to + base verb',
    examples: [
      LessonExample(
        'I can understand this sign.',
        'Men bu belgini tushuna olaman.',
      ),
      LessonExample(
        'You must wear a seat belt.',
        'Siz xavfsizlik kamarini taqishingiz shart.',
      ),
    ],
    question: 'Visitors ___ show their tickets at the entrance.',
    answer: 'have to',
    options: ['has to', 'have to', 'having to'],
  ),
  CefrLesson(
    id: 12,
    level: 'B1',
    title: 'First conditional',
    subtitle: 'Haqiqiy kelajak ehtimoli',
    explanation: 'First Conditional kelajakda ro‘y berishi mumkin bo‘lgan shart va natijani ifodalaydi. If qismida Present Simple, natija qismida will + fe’l ishlatiladi.',
    pattern: 'If + Present Simple, will + base verb',
    examples: [
      LessonExample(
        'If it rains, we will stay inside.',
        'Yomg‘ir yog‘sa, ichkarida qolamiz.',
      ),
      LessonExample(
        'I will call you if I arrive early.',
        'Erta yetib borsam, sizga qo‘ng‘iroq qilaman.',
      ),
    ],
    question: 'If she ___ early, we will have breakfast together.',
    answer: 'arrives',
    options: ['will arrive', 'arrives', 'arrive'],
  ),
  CefrLesson(
    id: 13,
    level: 'B1',
    title: 'Passive voice',
    subtitle: 'Ish-harakat bajaruvchisidan ko‘ra natija',
    explanation: 'Passive Voice’da e’tibor ishni kim bajarganiga emas, ish ta’sir qilgan narsa yoki natijaga qaratiladi. Zamon to be yordamchi fe’li bilan, asosiy fe’l esa past participle shaklida beriladi.',
    pattern: 'Object + be (tense) + past participle',
    examples: [
      LessonExample(
        'The bridge was built in 1998.',
        'Ko‘prik 1998-yilda qurilgan.',
      ),
      LessonExample(
        'English is spoken in many countries.',
        'Ko‘plab mamlakatlarda ingliz tilida gaplashiladi.',
      ),
    ],
    question: 'The letters ___ yesterday.',
    answer: 'were delivered',
    options: ['delivered', 'were delivered', 'are deliver'],
  ),
  CefrLesson(
    id: 14,
    level: 'B2',
    title: 'Second conditional',
    subtitle: 'Hozirgi yoki kelajakdagi faraz',
    explanation: 'Second Conditional hozirgi yoki kelajakdagi noreal/yiroq farazni ifodalaydi. If qismida Past Simple, natijada would + fe’l ishlatiladi. Be fe’li bilan ko‘pincha were tanlanadi.',
    pattern: 'If + Past Simple, would + base verb',
    examples: [
      LessonExample(
        'If I had more time, I would learn another language.',
        'Vaqtim ko‘proq bo‘lsa, yana bir til o‘rganardim.',
      ),
      LessonExample(
        'She would move abroad if she found a good job.',
        'Yaxshi ish topsa, u chet elga ko‘chib ketardi.',
      ),
    ],
    question: 'If he ___ closer, he would walk to work.',
    answer: 'lived',
    options: ['lives', 'lived', 'would live'],
  ),
  CefrLesson(
    id: 15,
    level: 'B2',
    title: 'Reported speech',
    subtitle: 'Birovning gapini bilvosita yetkazish',
    explanation: 'Reported Speech’da gapning mazmuni ko‘chirma gaplarsiz yetkaziladi. O‘tgan zamondagi reporting verbdan keyin zamon odatda bir bosqich orqaga siljiydi; olmosh va vaqt ifodalari ham vaziyatga moslanadi.',
    pattern: 'said (that) + backshifted clause',
    examples: [
      LessonExample(
        '“I am tired.” → She said she was tired.',
        '“Charchadim.” → U charchaganini aytdi.',
      ),
      LessonExample(
        '“We will call.” → They said they would call.',
        '“Qo‘ng‘iroq qilamiz.” → Ular qo‘ng‘iroq qilishlarini aytishdi.',
      ),
    ],
    question: '“I can swim.” → He said he ___ swim.',
    answer: 'could',
    options: ['can', 'could', 'would'],
  ),
  CefrLesson(
    id: 16,
    level: 'B2',
    title: 'Defining relative clauses',
    subtitle: 'Odam va narsani aniqlab berish',
    explanation: 'Who odamlar, which narsalar, that esa ko‘pincha ikkalasi uchun ishlatiladi. Defining relative clause zarur ma’lumot beradi, shuning uchun uning oldidan vergul qo‘yilmaydi.',
    pattern: 'person + who/that  ·  thing + which/that',
    examples: [
      LessonExample(
        'The woman who called you is my manager.',
        'Sizga qo‘ng‘iroq qilgan ayol mening rahbarim.',
      ),
      LessonExample(
        'This is the book that changed my life.',
        'Bu hayotimni o‘zgartirgan kitob.',
      ),
    ],
    question: 'The café ___ we met has closed.',
    answer: 'where',
    options: ['where', 'who', 'whose'],
  ),
  CefrLesson(
    id: 17,
    level: 'C1',
    title: 'Inversion for emphasis',
    subtitle: 'Rasmiy urg‘u uchun so‘z tartibini o‘zgartirish',
    explanation: 'Never, rarely, only then kabi cheklovchi yoki inkor ma’noli ibora gap boshiga chiqsa, yordamchi fe’l egadan oldin keladi. Bu uslub rasmiy nutq va yozuvda kuchli urg‘u beradi.',
    pattern: 'Negative adverbial + auxiliary + subject + main verb',
    examples: [
      LessonExample(
        'Never have I seen such a clear night.',
        'Bunday musaffo tunni hech qachon ko‘rmaganman.',
      ),
      LessonExample(
        'Only after the meeting did we understand the plan.',
        'Faqat yig‘ilishdan keyingina rejani tushundik.',
      ),
    ],
    question: 'Rarely ___ the city been so quiet.',
    answer: 'has',
    options: ['the city has', 'has', 'did'],
  ),
  CefrLesson(
    id: 18,
    level: 'C1',
    title: 'Cleft sentences',
    subtitle: 'Gapning muhim bo‘lagini ajratib ko‘rsatish',
    explanation: 'Cleft tuzilmalari ma’lum bo‘lakka urg‘u berish uchun gapni ikki qismga ajratadi. It is/was ... that odatda odam, vaqt yoki sababni ta’kidlaydi; what-clause esa aynan nima muhimligini ko‘rsatadi.',
    pattern: 'It is/was + focus + that/who + clause',
    examples: [
      LessonExample(
        'It was Maya who found the key.',
        'Kalitni aynan Maya topgan edi.',
      ),
      LessonExample(
        'What I need is a little more time.',
        'Menga kerak bo‘lgan narsa — biroz ko‘proq vaqt.',
      ),
    ],
    question: 'It was the guide ___ showed us the old town.',
    answer: 'who',
    options: ['which', 'who', 'what'],
  ),
  CefrLesson(
    id: 19,
    level: 'C1',
    title: 'Participle clauses',
    subtitle: 'Bog‘langan gaplarni ixchamlashtirish',
    explanation: 'Bir xil egaga ega bo‘lgan qo‘shimcha gapni present yoki past participle bilan qisqartirish mumkin. Harakatlarning vaqti va bajaruvchisi aniq qolishi kerak; noto‘g‘ri qisqartma dangling modifier hosil qiladi.',
    pattern: 'Having + past participle, subject + verb',
    examples: [
      LessonExample(
        'Having checked the figures, Lina sent the report.',
        'Raqamlarni tekshirib bo‘lgach, Lina hisobotni yubordi.',
      ),
      LessonExample(
        'Designed by local artists, the mural brightened the hall.',
        'Mahalliy rassomlar yaratgan devoriy rasm zalni yorqinlashtirdi.',
      ),
    ],
    question: '___ finished the interview, he wrote his notes.',
    answer: 'Having',
    options: ['Having', 'Have', 'Was'],
  ),
  CefrLesson(
    id: 20,
    level: 'C2',
    title: 'Mixed conditionals',
    subtitle: 'O‘tmishdagi shart va hozirgi natija',
    explanation: 'Mixed Conditional o‘tmishda ro‘y bermagan shartning hozirgi natijasini bog‘laydi. If qismida Past Perfect, natijada would + infinitive ishlatiladi.',
    pattern: 'If + past perfect, would + base verb (now)',
    examples: [
      LessonExample(
        'If I had taken that job, I would live abroad now.',
        'O‘sha ishni qabul qilganimda, hozir chet elda yashayotgan bo‘lardim.',
      ),
      LessonExample(
        'She would feel calmer now if she had prepared earlier.',
        'Oldinroq tayyorlanganida, hozir o‘zini xotirjamroq his qilardi.',
      ),
    ],
    question: 'If they had left earlier, they ___ here by now.',
    answer: 'would be',
    options: ['will be', 'would be', 'would have been'],
  ),
  CefrLesson(
    id: 21,
    level: 'C2',
    title: 'Modal perfect deductions',
    subtitle: 'O‘tmish haqida ehtiyotkor xulosa',
    explanation: 'Modal fe’l + have + past participle o‘tmishdagi holatni taxmin yoki xulosa qiladi. Must have kuchli ehtimol, may/might have noaniq ehtimol, can’t have esa deyarli imkonsiz xulosani bildiradi.',
    pattern: 'must/might/can’t + have + past participle',
    examples: [
      LessonExample(
        'The lights are off; they must have left.',
        'Chiroqlar o‘chiq; ular ketgan bo‘lsa kerak.',
      ),
      LessonExample(
        'He might have missed the earlier train.',
        'U avvalgi poyezdni o‘tkazib yuborgan bo‘lishi mumkin.',
      ),
    ],
    question: 'The ground is soaked. It ___ overnight.',
    answer: 'must have rained',
    options: ['must rain', 'must have rained', 'should raining'],
  ),
  CefrLesson(
    id: 22,
    level: 'C2',
    title: 'Hedging and precise claims',
    subtitle: 'Akademik fikrni me’yorida ifodalash',
    explanation: 'Akademik va professional nutqda dalil kuchiga mos iborani tanlang. Appears to va is likely to ehtimolni bildiradi; qat’iy xulosa faqat dalil yetarli bo‘lganda ishlatiladi.',
    pattern: 'Evidence suggests that…  ·  This may indicate…',
    examples: [
      LessonExample(
        'The findings appear to support the hypothesis.',
        'Natijalar farazni qo‘llab-quvvatlayotganga o‘xshaydi.',
      ),
      LessonExample(
        'This may indicate a broader change in demand.',
        'Bu talabdagi kengroq o‘zgarishni ko‘rsatishi mumkin.',
      ),
    ],
    question: 'The early results ___ suggest a modest improvement.',
    answer: 'appear to',
    options: ['appear to', 'must', 'certainly'],
  ),
];
