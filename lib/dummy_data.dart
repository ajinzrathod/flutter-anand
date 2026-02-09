import 'models.dart';

class DummyDataProvider {
  static List<Shastra> getAllShastras() {
    return [
      _getVachanamrutData(),
      _getShikshapatriData(),
      _getGeneralReligionData(),
      _getSatsangiJivanData(),
    ];
  }

  static Shastra _getVachanamrutData() {
    return Shastra(
      id: 'vachanamrut',
      nameEnglish: 'Vachanamrut',
      nameGujarati: 'વચનામૃત',
      descriptionEnglish: 'Sacred teachings of Lord Swaminarayan',
      descriptionGujarati: 'પ્રભુ સ્વામીનારાયણ આયમની પવિત્ર શિક્ષાઓ',
      sets: _generateVachanamrutSets(),
    );
  }

  static Shastra _getShikshapatriData() {
    return Shastra(
      id: 'shikshapatri',
      nameEnglish: 'Shikshapatri',
      nameGujarati: 'શિક્ષાપત્રી',
      descriptionEnglish: 'Code of conduct and moral teachings',
      descriptionGujarati: 'આચરણ અને નૈતિક શિક્ષાઓ',
      sets: _generateShikshapatriSets(),
    );
  }

  static Shastra _getGeneralReligionData() {
    return Shastra(
      id: 'general_religion',
      nameEnglish: 'General Religion',
      nameGujarati: 'સામાન્ય ધર્મ',
      descriptionEnglish: 'General religious concepts and practices',
      descriptionGujarati: 'સામાન્ય ધર્મીય વિષય અને પ્રથા',
      sets: _generateGeneralReligionSets(),
    );
  }

  static Shastra _getSatsangiJivanData() {
    return Shastra(
      id: 'satsangi_jivan',
      nameEnglish: 'Satsangi Jivan',
      nameGujarati: 'સત્સંગી જીવન',
      descriptionEnglish: 'Life and stories of devotees',
      descriptionGujarati: 'ભક્તોનું જીવન અને વર્તમાન',
      sets: _generateSatsangiJivanSets(),
    );
  }

  static List<QuestionSet> _generateVachanamrutSets() {
    return List.generate(5, (index) {
      return QuestionSet(
        id: 'vach_set_${index + 1}',
        nameEnglish: 'Vachanamrut Set ${index + 1}',
        nameGujarati: 'વચનામૃત સમૂહ ${index + 1}',
        descriptionEnglish: 'Questions on Vachanamrut teachings',
        descriptionGujarati: 'વચનામૃત શીક્ષા પર પ્રશ્નો',
        questions: _generateQuestions(
          'vach_q_${index + 1}',
          vachanamrutQuestions,
          50,
        ),
      );
    });
  }

  static List<QuestionSet> _generateShikshapatriSets() {
    return List.generate(5, (index) {
      return QuestionSet(
        id: 'shiksha_set_${index + 1}',
        nameEnglish: 'Shikshapatri Set ${index + 1}',
        nameGujarati: 'શિક્ષાપત્રી સમૂહ ${index + 1}',
        descriptionEnglish: 'Questions on Shikshapatri teachings',
        descriptionGujarati: 'શિક્ષાપત્રી શીક્ષા પર પ્રશ્નો',
        questions: _generateQuestions(
          'shiksha_q_${index + 1}',
          shikshapatriQuestions,
          50,
        ),
      );
    });
  }

  static List<QuestionSet> _generateGeneralReligionSets() {
    return List.generate(5, (index) {
      return QuestionSet(
        id: 'religion_set_${index + 1}',
        nameEnglish: 'Religion Set ${index + 1}',
        nameGujarati: 'ધર્મ સમૂહ ${index + 1}',
        descriptionEnglish: 'General religious questions',
        descriptionGujarati: 'સામાન્ય ધર્મીય પ્રશ્નો',
        questions: _generateQuestions(
          'religion_q_${index + 1}',
          generalReligionQuestions,
          50,
        ),
      );
    });
  }

  static List<QuestionSet> _generateSatsangiJivanSets() {
    return List.generate(5, (index) {
      return QuestionSet(
        id: 'satsangi_set_${index + 1}',
        nameEnglish: 'Satsangi Jivan Set ${index + 1}',
        nameGujarati: 'સત્સંગી જીવન સમૂહ ${index + 1}',
        descriptionEnglish: 'Questions on Satsangi stories',
        descriptionGujarati: 'સત્સંગી વર્તમાન પર પ્રશ્નો',
        questions: _generateQuestions(
          'satsangi_q_${index + 1}',
          satsangiJivanQuestions,
          50,
        ),
      );
    });
  }

  static List<Question> _generateQuestions(
    String idPrefix,
    List<Map<String, dynamic>> questionData,
    int count,
  ) {
    final List<Question> questions = [];
    for (int i = 0; i < count; i++) {
      final data = questionData[i % questionData.length];
      questions.add(
        Question(
          id: '${idPrefix}_${i + 1}',
          textEnglish: data['textEnglish'] ?? '',
          textGujarati: data['textGujarati'] ?? '',
          answerEnglish: data['answerEnglish'] ?? '',
          answerGujarati: data['answerGujarati'] ?? '',
          difficulty: _getDifficulty(i),
        ),
      );
    }
    return questions;
  }

  static DifficultyLevel _getDifficulty(int index) {
    if (index < 15) return DifficultyLevel.easy;
    if (index < 35) return DifficultyLevel.medium;
    return DifficultyLevel.hard;
  }

  // Sample questions for Vachanamrut
  static final vachanamrutQuestions = [
    {
      'textEnglish': 'Who founded the Swaminarayan Sampraday?',
      'textGujarati': 'સ્વામીનારાયણ સમ્પ્રદાયની સ્થાપના કોણે કરી?',
      'answerEnglish': 'Lord Swaminarayan',
      'answerGujarati': 'પ્રભુ સ્વામીનારાયણ',
    },
    {
      'textEnglish': 'What is the main purpose of Vachanamrut?',
      'textGujarati': 'વચનામૃતનો મુખ્ય હેતુ શું છે?',
      'answerEnglish': 'To provide spiritual guidance and teachings',
      'answerGujarati': 'આધ્યાત્મિક માર્ગદર્શન અને શીક્ષા આપવા',
    },
    {
      'textEnglish': 'In which year did Lord Swaminarayan attain moksha?',
      'textGujarati': 'પ્રભુ સ્વામીનારાયણ ક્યાં વર્ષે મોક્ષ પામ્યા?',
      'answerEnglish': '1830',
      'answerGujarati': '1830',
    },
    {
      'textEnglish': 'How many Vachanamruts are recorded?',
      'textGujarati': 'કેટલા વચનામૃત નોંધવામાં આવ્યા છે?',
      'answerEnglish': '262',
      'answerGujarati': '262',
    },
    {
      'textEnglish': 'What is Aksharbrahman?',
      'textGujarati': 'અક્ષરબ્રહ્મ શું છે?',
      'answerEnglish': 'The supreme abode of God',
      'answerGujarati': 'ભગવાનનું સર્વોચ્ચ આધાર',
    },
    {
      'textEnglish': 'Who compiled the Vachanamrut?',
      'textGujarati': 'વચનામૃતનો સંકલન કોણે કર્યો?',
      'answerEnglish': 'Guru Maharaj\'s followers',
      'answerGujarati': 'ગુરુ મહારાજના અનુયાયીઓ',
    },
    {
      'textEnglish': 'What is the concept of Brahman?',
      'textGujarati': 'બ્રહ્મ શું હોય છે?',
      'answerEnglish': 'The supreme reality',
      'answerGujarati': 'સર્વોચ્ચ વાસ્તવિકતા',
    },
    {
      'textEnglish': 'Define Mukti according to Vachanamrut',
      'textGujarati': 'વચનામૃત અનુસાર મુક્તિ શું છે?',
      'answerEnglish': 'Liberation from the cycle of rebirth',
      'answerGujarati': 'પુનર્જન્મના ચક્રમાંથી મુક્તિ',
    },
    {
      'textEnglish': 'What are the four Vedas?',
      'textGujarati': 'ચાર વેદ કયા છે?',
      'answerEnglish': 'Rigveda, Yajurveda, Samaveda, Atharvaveda',
      'answerGujarati': 'ઋગ્વેદ, યજુર્વેદ, સામવેદ, અથર્વવેદ',
    },
    {
      'textEnglish': 'What is the significance of Maya?',
      'textGujarati': 'માયાનું મહત્વ શું છે?',
      'answerEnglish': 'The illusion of the material world',
      'answerGujarati': 'મેટેરીયલ પૃથ્વીનો ભ્રમણ',
    },
  ];

  // Sample questions for Shikshapatri
  static final shikshapatriQuestions = [
    {
      'textEnglish': 'Who wrote the Shikshapatri?',
      'textGujarati': 'શિક્ષાપત્રી કોણે લખ્યો?',
      'answerEnglish': 'Lord Swaminarayan',
      'answerGujarati': 'પ્રભુ સ્વામીનારાયણ',
    },
    {
      'textEnglish': 'How many verses are in Shikshapatri?',
      'textGujarati': 'શિક્ષાપત્રીમાં કેટલી બાણીઓ છે?',
      'answerEnglish': '212',
      'answerGujarati': '212',
    },
    {
      'textEnglish': 'What is the main theme of Shikshapatri?',
      'textGujarati': 'શિક્ષાપત્રીનો મુખ્ય વિષય શું છે?',
      'answerEnglish': 'Moral conduct and social ethics',
      'answerGujarati': 'નૈતિક આચરણ અને સામાજિક નિતિશાસ્ત્ર',
    },
    {
      'textEnglish': 'To whom was Shikshapatri sent?',
      'textGujarati': 'શિક્ષાપત્રી કોને મોકલ્યો હતો?',
      'answerEnglish': 'The followers of Swaminarayan',
      'answerGujarati': 'સ્વામીનારાયણના અનુયાયીઓને',
    },
    {
      'textEnglish': 'What are the core duties of a satsangi?',
      'textGujarati': 'સત્સંગીના મુખ્ય કર્તવ્યો શું છે?',
      'answerEnglish': 'Devotion, truthfulness, and purity',
      'answerGujarati': 'ભક્તિ, સત્યતા અને શુદ્ધતા',
    },
    {
      'textEnglish': 'What does Shikshapatri teach about family life?',
      'textGujarati': 'શિક્ષાપત્રી પરિવાર જીવન વિશે શું શીખવે છે?',
      'answerEnglish': 'Maintain harmony and devotion to God',
      'answerGujarati': 'સમન્વય અને ભગવાન પ્રતિ ભક્તિ જાળવવી',
    },
    {
      'textEnglish': 'How should one treat elders according to Shikshapatri?',
      'textGujarati': 'શિક્ષાપત્રી અનુસાર વૃદ્ધોને કેવી રીતે વર્તવું?',
      'answerEnglish': 'With respect and obedience',
      'answerGujarati': 'આદર અને આજ્ఞાકારથી',
    },
    {
      'textEnglish': 'What is the significance of proper diet?',
      'textGujarati': 'યોગ્ય આહારનું મહત્વ શું છે?',
      'answerEnglish': 'It purifies the mind and body',
      'answerGujarati': 'તે મન અને શરીર શુદ્ધ કરે છે',
    },
    {
      'textEnglish': 'How should wealth be used?',
      'textGujarati': 'સંપત્તિનો ઉપયોગ કેવી રીતે કરવો?',
      'answerEnglish': 'For righteous purposes and charity',
      'answerGujarati': 'ધર્મીય કાર્યો અને દાન માટે',
    },
    {
      'textEnglish': 'What is the importance of celibacy?',
      'textGujarati': 'બ્રહ્મચર્યનું મહત્વ શું છે?',
      'answerEnglish': 'It leads to spiritual progress',
      'answerGujarati': 'તે આધ્યાત્મિક પ્રગતિ નિર્દેશ કરે છે',
    },
  ];

  // Sample questions for General Religion
  static final generalReligionQuestions = [
    {
      'textEnglish': 'What is the ultimate goal of Hindu philosophy?',
      'textGujarati': 'હિંદુ તત્ત્વશાસ્ત્રનો અંતિમ લક્ષ્ય શું છે?',
      'answerEnglish': 'Moksha or Liberation',
      'answerGujarati': 'મોક્ષ અથવા મુક્તિ',
    },
    {
      'textEnglish': 'How many Upanishads are there?',
      'textGujarati': 'કેટલા ઉપનિષદ છે?',
      'answerEnglish': '108 major Upanishads',
      'answerGujarati': '108 મુખ્ય ઉપનિષદ',
    },
    {
      'textEnglish': 'What are the four Ashrams?',
      'textGujarati': 'ચાર આશ્રમો કયા છે?',
      'answerEnglish': 'Brahmacharya, Grihastha, Vanaprastha, Sanyasa',
      'answerGujarati': 'બ્રહ્મચર્ય, ગૃહસ્થ, વનપ્રસ્થ, સંન્યાસ',
    },
    {
      'textEnglish': 'What are the four Purusharthas?',
      'textGujarati': 'ચાર પુરુષાર્થ શું છે?',
      'answerEnglish': 'Dharma, Artha, Kama, Moksha',
      'answerGujarati': 'ધર્મ, અર્થ, કામ, મોક્ષ',
    },
    {
      'textEnglish': 'What is the concept of Karma?',
      'textGujarati': 'કર્મનો સિદ્ધાંત શું છે?',
      'answerEnglish': 'Every action has consequences',
      'answerGujarati': 'દરેક કર્મનું પરિણામ છે',
    },
    {
      'textEnglish': 'Define Dharma',
      'textGujarati': 'ધર્મ શું છે?',
      'answerEnglish': 'Righteous duty and moral law',
      'answerGujarati': 'ધર્મીય કર્તવ્ય અને નૈતિક નિયમ',
    },
    {
      'textEnglish': 'What is the concept of Brahman?',
      'textGujarati': 'બ્રહ્મનવું શું છે?',
      'answerEnglish': 'The ultimate reality',
      'answerGujarati': 'સર્વોચ્ચ વાસ્તવિકતા',
    },
    {
      'textEnglish': 'How many paths to God are mentioned in Bhagavad Gita?',
      'textGujarati': 'ભગવદ્ગીતામાં કેટલા દેવતાનાં માર્ગ છે?',
      'answerEnglish': 'Three - Karma, Bhakti, and Jnana',
      'answerGujarati': 'ત્રણ - કર્મ, ભક્તિ, અને જ્ઞાન',
    },
    {
      'textEnglish': 'What is the Bhagavad Gita?',
      'textGujarati': 'ભગવદ્ગીતા શું છે?',
      'answerEnglish': 'Divine teachings of Lord Krishna to Arjun',
      'answerGujarati': 'શ્રી કૃષ્ણના અર્જુનને આપેલ દૈવીય શીક્ષા',
    },
    {
      'textEnglish': 'What are the six systems of Hindu philosophy?',
      'textGujarati': 'હિંદુ તત્ત્વશાસ્ત્રની છ પ્રણાલીઓ શું છે?',
      'answerEnglish': 'Samkhya, Yoga, Nyaya, Vaisheshika, Purva Mimansa, Vedanta',
      'answerGujarati': 'સાંખ્ય, યોગ, ન્યાય, વૈશેષિક, પૂર્વ મીમાંસા, વેદાંત',
    },
  ];

  // Sample questions for Satsangi Jivan
  static final satsangiJivanQuestions = [
    {
      'textEnglish': 'Who was the first follower of Swaminarayan?',
      'textGujarati': 'સ્વામીનારાયણનો પ્રથમ અનુયાયી કોણ હતો?',
      'answerEnglish': 'Nityananda Swami',
      'answerGujarati': 'નિત્યાનંદ સ્વામી',
    },
    {
      'textEnglish': 'What message did Swaminarayan bring?',
      'textGujarati': 'સ્વામીનારાયણ શું સંદેશ લાવ્યા?',
      'answerEnglish': 'Message of devotion and morality',
      'answerGujarati': 'ભક્તિ અને નૈતિકતાનો સંદેશ',
    },
    {
      'textEnglish': 'How many principal disciples did Swaminarayan have?',
      'textGujarati': 'સ્વામીનારાયણને કેટલા મુખ્ય શિષ્યો હતા?',
      'answerEnglish': 'Five - Gunatitanand Swami and others',
      'answerGujarati': 'પાંચ - ગુણાતીતાનંદ સ્વામી અને અન્યો',
    },
    {
      'textEnglish': 'What is the significance of a satsangi?',
      'textGujarati': 'સત્સંગીનું મહત્વ શું છે?',
      'answerEnglish': 'A true devotee and follower of God',
      'answerGujarati': 'ભગવાનનો સાચો ભક્ત અને અનુયાયી',
    },
    {
      'textEnglish': 'What are the qualities of a satsangi?',
      'textGujarati': 'સત્સંગીના ગુણો શું છે?',
      'answerEnglish': 'Truthfulness, purity, and devotion',
      'answerGujarati': 'સત્યતા, શુદ્ધતા અને ભક્તિ',
    },
    {
      'textEnglish': 'How did Swaminarayan spread the faith?',
      'textGujarati': 'સ્વામીનારાયણ આસ્થા કેવી રીતે ફેલાવી?',
      'answerEnglish': 'Through personal example and teachings',
      'answerGujarati': 'વ્યક્તિગત ઉદાહરણ અને શીક્ષા દ્વારા',
    },
    {
      'textEnglish': 'What role does a guru play in spirituality?',
      'textGujarati': 'આધ્યાત્મિકતામાં ગુરુની ભૂમિકા શું છે?',
      'answerEnglish': 'Guide and mentor on spiritual path',
      'answerGujarati': 'આધ્યાત્મિક માર્ગે માર્ગદર્શક અને શિક્ષક',
    },
    {
      'textEnglish': 'What are the benefits of satsang?',
      'textGujarati': 'સત્સંગનાં લાભો શું છે?',
      'answerEnglish': 'Spiritual growth and moral development',
      'answerGujarati': 'આધ્યાત્મિક વૃદ્ધિ અને નૈતિક વિકાસ',
    },
    {
      'textEnglish': 'How should one respect the guru?',
      'textGujarati': 'ગુરુને કેવી રીતે શ્રદ્ધા મૂકવી?',
      'answerEnglish': 'With total faith and obedience',
      'answerGujarati': 'સંપૂર્ણ શ્રદ્ધા અને આજ્ઞાકારથી',
    },
    {
      'textEnglish': 'What is the meaning of a guru mantra?',
      'textGujarati': 'ગુરુ મંત્રનો અર્થ શું છે?',
      'answerEnglish': 'Sacred words given by the guru for meditation',
      'answerGujarati': 'ગુરુ દ્વારા આપવામાં આવેલ પવિત્ર શબ્દો',
    },
  ];
}
