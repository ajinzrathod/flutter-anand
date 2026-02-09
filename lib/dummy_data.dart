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
      final options = (data['options'] as List<dynamic>?)?.cast<String>() ?? [];
      final optionsGujarati = (data['optionsGujarati'] as List<dynamic>?)?.cast<String>() ?? [];
      
      // Shuffle options and find correct index
      final shuffledOptions = List<String>.from(options)..shuffle();
      final shuffledGujaratiOptions = List<String>.from(optionsGujarati)..shuffle();
      
      final correctIndex = shuffledOptions.indexOf(data['answerEnglish'] as String);

      questions.add(
        Question(
          id: '${idPrefix}_${i + 1}',
          textEnglish: data['textEnglish'] as String? ?? '',
          textGujarati: data['textGujarati'] as String? ?? '',
          answerEnglish: data['answerEnglish'] as String? ?? '',
          answerGujarati: data['answerGujarati'] as String? ?? '',
          difficulty: _getDifficulty(i),
          options: shuffledOptions,
          optionsGujarati: shuffledGujaratiOptions,
          correctOptionIndex: correctIndex,
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

  // Sample questions for Vachanamrut with MCQ options in English and Gujarati
  static final vachanamrutQuestions = [
    {
      'textEnglish': 'Who founded the Swaminarayan Sampraday?',
      'textGujarati': 'સ્વામીનારાયણ સમ્પ્રદાયની સ્થાપના કોણે કરી?',
      'answerEnglish': 'Lord Swaminarayan',
      'answerGujarati': 'પ્રભુ સ્વામીનારાયણ',
      'options': ['Lord Swaminarayan', 'Lord Krishna', 'Lord Shiva', 'Lord Brahma'],
      'optionsGujarati': ['પ્રભુ સ્વામીનારાયણ', 'પ્રભુ કૃષ્ણ', 'પ્રભુ શિવ', 'પ્રભુ બ્રહ્મા'],
    },
    {
      'textEnglish': 'What is the main purpose of Vachanamrut?',
      'textGujarati': 'વચનામૃતનો મુખ્ય હેતુ શું છે?',
      'answerEnglish': 'To provide spiritual guidance and teachings',
      'answerGujarati': 'આધ્યાત્મિક માર્ગદર્શન અને શીક્ષા આપવા',
      'options': ['To provide spiritual guidance and teachings', 'To tell stories of battles', 'To describe historical events', 'To teach medicine'],
      'optionsGujarati': ['આધ્યાત્મિક માર્ગદર્શન અને શીક્ષા આપવા', 'યુદ્ધોની કહાણીઓ કહેવી', 'ઐતિહાસિક ઘટનાઓ વર્ણવવી', 'દવા શીખવવી'],
    },
    {
      'textEnglish': 'In which year did Lord Swaminarayan attain moksha?',
      'textGujarati': 'પ્રભુ સ્વામીનારાયણ ક્યાં વર્ષે મોક્ષ પામ્યા?',
      'answerEnglish': '1830',
      'answerGujarati': '1830',
      'options': ['1830', '1820', '1840', '1850'],
      'optionsGujarati': ['1830', '1820', '1840', '1850'],
    },
    {
      'textEnglish': 'How many Vachanamruts are recorded?',
      'textGujarati': 'કેટલા વચનામૃત નોંધવામાં આવ્યા છે?',
      'answerEnglish': '262',
      'answerGujarati': '262',
      'options': ['262', '250', '300', '325'],
      'optionsGujarati': ['262', '250', '300', '325'],
    },
    {
      'textEnglish': 'What is Aksharbrahman?',
      'textGujarati': 'અક્ષરબ્રહ્મ શું છે?',
      'answerEnglish': 'The supreme abode of God',
      'answerGujarati': 'ભગવાનનું સર્વોચ્ચ આધાર',
      'options': ['The supreme abode of God', 'A type of meditation', 'A sacred ritual', 'A mountain'],
      'optionsGujarati': ['ભગવાનનું સર્વોચ્ચ આધાર', 'ધ્યાન કરવાનો પ્રકાર', 'પવિત્ર અનુષ્ઠાન', 'એક પર્વત'],
    },
    {
      'textEnglish': 'Who compiled the Vachanamrut?',
      'textGujarati': 'વચનામૃતનો સંકલન કોણે કર્યો?',
      'answerEnglish': 'The followers of Swaminarayan',
      'answerGujarati': 'સ્વામીનારાયણના અનુયાયીઓ',
      'options': ['The followers of Swaminarayan', 'Royal scholars', 'Foreign translators', 'Ancient saints'],
      'optionsGujarati': ['સ્વામીનારાયણના અનુયાયીઓ', 'રાજસત્તાના વિદ્વાનો', 'વિદેશી અનુવાદક', 'પ્રાચીન સાધુઓ'],
    },
    {
      'textEnglish': 'What is the concept of Brahman?',
      'textGujarati': 'બ્રહ્મ શું હોય છે?',
      'answerEnglish': 'The supreme reality',
      'answerGujarati': 'સર્વોચ્ચ વાસ્તવિકતા',
      'options': ['The supreme reality', 'A type of prayer', 'A holy person', 'A sacred place'],
      'optionsGujarati': ['સર્વોચ્ચ વાસ્તવિકતા', 'પ્રાર્થનાનો પ્રકાર', 'એક પવિત્ર વ્યક્તિ', 'એક પવિત્ર સ્થળ'],
    },
    {
      'textEnglish': 'Define Mukti according to Vachanamrut',
      'textGujarati': 'વચનામૃત અનુસાર મુક્તિ શું છે?',
      'answerEnglish': 'Liberation from the cycle of rebirth',
      'answerGujarati': 'પુનર્જન્મના ચક્રમાંથી મુક્તિ',
      'options': ['Liberation from the cycle of rebirth', 'Achievement of wealth', 'Physical strength', 'Political power'],
      'optionsGujarati': ['પુનર્જન્મના ચક્રમાંથી મુક્તિ', 'સંપત્તિની પ્રાપ્તિ', 'શારીરિક શક્તિ', 'રાજનીતિક શક્તિ'],
    },
    {
      'textEnglish': 'What are the four Vedas?',
      'textGujarati': 'ચાર વેદ કયા છે?',
      'answerEnglish': 'Rigveda, Yajurveda, Samaveda, Atharvaveda',
      'answerGujarati': 'ઋગ્વેદ, યજુર્વેદ, સામવેદ, અથર્વવેદ',
      'options': ['Rigveda, Yajurveda, Samaveda, Atharvaveda', 'Vedanta, Upanishads, Brahma, Vishnu', 'Purana, Itihas, Smriti, Shruti', 'Shastra, Tantra, Mantra, Yantra'],
      'optionsGujarati': ['ઋગ્વેદ, યજુર્વેદ, સામવેદ, અથર્વવેદ', 'વેદાંત, ઉપનિષદ, બ્રહ્મા, વિષ્ણુ', 'પુરાણ, ઇતિહાસ, સ્મૃતિ, શ્રુતિ', 'શાસ્ત્ર, તંત્ર, મંત્ર, યંત્ર'],
    },
    {
      'textEnglish': 'What is the significance of Maya?',
      'textGujarati': 'માયાનું મહત્વ શું છે?',
      'answerEnglish': 'The illusion of the material world',
      'answerGujarati': 'સામગ્રી પૃથ્વીનો ભ્રમણ',
      'options': ['The illusion of the material world', 'A type of dance', 'A goddess name', 'A mathematical principle'],
      'optionsGujarati': ['સામગ્રી પૃથ્વીનો ભ્રમણ', 'નૃત્યનો પ્રકાર', 'દેવીનું નામ', 'ગણિતીય સિદ્ધાંત'],
    },
  ];

  static final shikshapatriQuestions = [
    {
      'textEnglish': 'Who wrote the Shikshapatri?',
      'textGujarati': 'શિક્ષાપત્રી કોણે લખ્યો?',
      'answerEnglish': 'Lord Swaminarayan',
      'answerGujarati': 'પ્રભુ સ્વામીનારાયણ',
      'options': ['Lord Swaminarayan', 'Vivekswarupanand', 'Gopalanand', 'Muktanand'],
      'optionsGujarati': ['પ્રભુ સ્વામીનારાયણ', 'વિવેક સ્વરૂપાનંદ', 'ગોપાલાનંદ', 'મુક્તાનંદ'],
    },
    {
      'textEnglish': 'How many verses are in Shikshapatri?',
      'textGujarati': 'શિક્ષાપત્રીમાં કેટલી બાણીઓ છે?',
      'answerEnglish': '212',
      'answerGujarati': '212',
      'options': ['212', '200', '250', '300'],
      'optionsGujarati': ['212', '200', '250', '300'],
    },
    {
      'textEnglish': 'What is the main theme of Shikshapatri?',
      'textGujarati': 'શિક્ષાપત્રીનો મુખ્ય વિષય શું છે?',
      'answerEnglish': 'Moral conduct and social ethics',
      'answerGujarati': 'નૈતિક આચરણ અને સામાજિક નિતિશાસ્ત્ર',
      'options': ['Moral conduct and social ethics', 'Military tactics', 'Scientific discoveries', 'Business management'],
      'optionsGujarati': ['નૈતિક આચરણ અને સામાજિક નિતિશાસ્ત્ર', 'લશ્કરી યુક્તિઓ', 'વૈજ્ઞાનિક શોધો', 'વ્યવસાય વ્યવસ્થાપન'],
    },
    {
      'textEnglish': 'To whom was Shikshapatri sent?',
      'textGujarati': 'શિક્ષાપત્રી કોને મોકલ્યો હતો?',
      'answerEnglish': 'The followers of Swaminarayan',
      'answerGujarati': 'સ્વામીનારાયણના અનુયાયીઓ',
      'options': ['The followers of Swaminarayan', 'The King of Gujarat', 'Foreign scholars', 'Muslim leaders'],
      'optionsGujarati': ['સ્વામીનારાયણના અનુયાયીઓ', 'ગુજરાતના રાજા', 'વિદેશી વિદ્વાનો', 'મુસ્લિમ નેતાઓ'],
    },
    {
      'textEnglish': 'What are the core duties of a satsangi?',
      'textGujarati': 'સત્સંગીના મુખ્ય કર્તવ્યો શું છે?',
      'answerEnglish': 'Devotion, truthfulness, and purity',
      'answerGujarati': 'ભક્તિ, સત્યતા અને શુદ્ધતા',
      'options': ['Devotion, truthfulness, and purity', 'Wealth, power, and status', 'Travel, music, and dance', 'War, politics, and strategy'],
      'optionsGujarati': ['ભક્તિ, સત્યતા અને શુદ્ધતા', 'સંપત્તિ, શક્તિ અને દર્જો', 'ભ્રમણ, સંગીત અને નૃત્ય', 'યુદ્ધ, રાજનીતિ અને આયોજન'],
    },
    {
      'textEnglish': 'What does Shikshapatri teach about family life?',
      'textGujarati': 'શિક્ષાપત્રી પરિવાર જીવન વિશે શું શીખવે છે?',
      'answerEnglish': 'Maintain harmony and devotion to God',
      'answerGujarati': 'સમન્વય અને ભગવાન પ્રતિ ભક્તિ જાળવવી',
      'options': ['Maintain harmony and devotion to God', 'Accumulate wealth and property', 'Pursue fame and recognition', 'Seek power and dominance'],
      'optionsGujarati': ['સમન્વય અને ભગવાન પ્રતિ ભક્તિ જાળવવી', 'સંપત્તિ અને મિલકત એકત્ર કરવી', 'પ્રખ્યાતિ અને સ્વીકૃતિ અનુસરવી', 'શક્તિ અને આધિપત્ય શોધવું'],
    },
    {
      'textEnglish': 'How should one treat elders?',
      'textGujarati': 'વૃદ્ધોને કેવી રીતે વર્તવું?',
      'answerEnglish': 'With respect and obedience',
      'answerGujarati': 'આદર અને આજ્ઞાકારથી',
      'options': ['With respect and obedience', 'With indifference', 'With criticism', 'With authority'],
      'optionsGujarati': ['આદર અને આજ્ઞાકારથી', 'ઉદાસીનતા સાથે', 'ટીકા સાથે', 'સત્તા સાથે'],
    },
    {
      'textEnglish': 'What is the significance of proper diet?',
      'textGujarati': 'યોગ્ય આહારનું મહત્વ શું છે?',
      'answerEnglish': 'It purifies the mind and body',
      'answerGujarati': 'તે મન અને શરીર શુદ્ધ કરે છે',
      'options': ['It purifies the mind and body', 'It increases wealth', 'It brings fame', 'It grants power'],
      'optionsGujarati': ['તે મન અને શરીર શુદ્ધ કરે છે', 'તે સંપત્તિ વધારે છે', 'તે પ્રખ્યાતિ લાવે છે', 'તે શક્તિ આપે છે'],
    },
    {
      'textEnglish': 'How should wealth be used?',
      'textGujarati': 'સંપત્તિનો ઉપયોગ કેવી રીતે કરવો?',
      'answerEnglish': 'For righteous purposes and charity',
      'answerGujarati': 'ધર્મીય કાર્યો અને દાન માટે',
      'options': ['For righteous purposes and charity', 'For self-indulgence', 'For domination', 'For hoarding'],
      'optionsGujarati': ['ધર્મીય કાર્યો અને દાન માટે', 'આત્મ-ભોગવલાસ માટે', 'આધિપત્ય માટે', 'સંચય માટે'],
    },
    {
      'textEnglish': 'What is the importance of celibacy?',
      'textGujarati': 'બ્રહ્મચર્યનું મહત્વ શું છે?',
      'answerEnglish': 'It leads to spiritual progress',
      'answerGujarati': 'તે આધ્યાત્મિક પ્રગતિ નિર્દેશ કરે છે',
      'options': ['It leads to spiritual progress', 'It brings physical health only', 'It increases wealth', 'It gains social status'],
      'optionsGujarati': ['તે આધ્યાત્મિક પ્રગતિ નિર્દેશ કરે છે', 'તે શારીરિક સ્વાસ્થ્ય જ લાવે છે', 'તે સંપત્તિ વધારે છે', 'તે સામાજિક દર્જો મેળવાય છે'],
    },
  ];

  static final generalReligionQuestions = [
    {
      'textEnglish': 'What is the ultimate goal of Hindu philosophy?',
      'textGujarati': 'હિંદુ તત્ત્વશાસ્ત્રનો અંતિમ લક્ષ્ય શું છે?',
      'answerEnglish': 'Moksha or Liberation',
      'answerGujarati': 'મોક્ષ અથવા મુક્તિ',
      'options': ['Moksha or Liberation', 'Wealth and power', 'Fame and glory', 'Pleasure and comfort'],
      'optionsGujarati': ['મોક્ષ અથવા મુક્તિ', 'સંપત્તિ અને શક્તિ', 'પ્રખ્યાતિ અને મહિમા', 'આનંદ અને સુવિધા'],
    },
    {
      'textEnglish': 'How many Upanishads are there?',
      'textGujarati': 'કેટલા ઉપનિષદ છે?',
      'answerEnglish': '108 major Upanishads',
      'answerGujarati': '108 મુખ્ય ઉપનિષદ',
      'options': ['108 major Upanishads', '52 Upanishads', '200 Upanishads', '75 Upanishads'],
      'optionsGujarati': ['108 મુખ્ય ઉપનિષદ', '52 ઉપનિષદ', '200 ઉપનિષદ', '75 ઉપનિષદ'],
    },
    {
      'textEnglish': 'What are the four Ashrams?',
      'textGujarati': 'ચાર આશ્રમો કયા છે?',
      'answerEnglish': 'Brahmacharya, Grihastha, Vanaprastha, Sanyasa',
      'answerGujarati': 'બ્રહ્મચર્ય, ગૃહસ્થ, વનપ્રસ્થ, સંન્યાસ',
      'options': ['Brahmacharya, Grihastha, Vanaprastha, Sanyasa', 'Dev, Demon, Human, Animal', 'Vedic, Epic, Puran, Tantra', 'Karma, Bhakti, Jnana, Raja'],
      'optionsGujarati': ['બ્રહ્મચર્ય, ગૃહસ્થ, વનપ્રસ્થ, સંન્યાસ', 'દેવતા, રાક્ષસ, માનવ, પશુ', 'વૈદિક, મહાકાવ્ય, પુરાણ, તંત્ર', 'કર્મ, ભક્તિ, જ્ઞાન, રાજ'],
    },
    {
      'textEnglish': 'What are the four Purusharthas?',
      'textGujarati': 'ચાર પુરુષાર્થ શું છે?',
      'answerEnglish': 'Dharma, Artha, Kama, Moksha',
      'answerGujarati': 'ધર્મ, અર્થ, કામ, મોક્ષ',
      'options': ['Dharma, Artha, Kama, Moksha', 'Birth, Growth, Decay, Death', 'Earth, Water, Fire, Air', 'Morning, Afternoon, Evening, Night'],
      'optionsGujarati': ['ધર્મ, અર્થ, કામ, મોક્ષ', 'જન્મ, વૃદ્ધિ, ક્ષય, મૃત્યુ', 'પૃથ્વી, પાણી, અગ્નિ, વાયુ', 'સવાર, બપોર, સાંજ, રાત'],
    },
    {
      'textEnglish': 'What is the concept of Karma?',
      'textGujarati': 'કર્મનો સિદ્ધાંત શું છે?',
      'answerEnglish': 'Every action has consequences',
      'answerGujarati': 'દરેક કર્મનું પરિણામ છે',
      'options': ['Every action has consequences', 'Life is predetermined', 'Only intentions matter', 'Actions are meaningless'],
      'optionsGujarati': ['દરેક કર્મનું પરિણામ છે', 'જીવન પૂર્વનિર્ધારિત છે', 'માત્ર ઈરાદો મહત્વનો છે', 'કર્મો અર્થહીન છે'],
    },
    {
      'textEnglish': 'Define Dharma',
      'textGujarati': 'ધર્મ શું છે?',
      'answerEnglish': 'Righteous duty and moral law',
      'answerGujarati': 'ધર્મીય કર્તવ્ય અને નૈતિક નિયમ',
      'options': ['Righteous duty and moral law', 'Religious building', 'Personal wealth', 'Social status'],
      'optionsGujarati': ['ધર્મીય કર્તવ્ય અને નૈતિક નિયમ', 'ધાર્મિક બાંધકામ', 'ગુજારાતી સંપત્તિ', 'સામાજિક દર્જો'],
    },
    {
      'textEnglish': 'What is Brahman?',
      'textGujarati': 'બ્રહ્મ શું છે?',
      'answerEnglish': 'The ultimate reality',
      'answerGujarati': 'સર્વોચ્ચ વાસ્તવિકતા',
      'options': ['The ultimate reality', 'A god of creation', 'A type of prayer', 'A sacred animal'],
      'optionsGujarati': ['સર્વોચ્ચ વાસ્તવિકતા', 'સર્જનના દેવતા', 'પ્રાર્થનાનો પ્રકાર', 'પવિત્ર પશુ'],
    },
    {
      'textEnglish': 'How many paths to God are in Bhagavad Gita?',
      'textGujarati': 'ભગવદ્ગીતામાં કેટલા માર્ગ છે?',
      'answerEnglish': 'Three - Karma, Bhakti, and Jnana',
      'answerGujarati': 'ત્રણ - કર્મ, ભક્તિ, અને જ્ઞાન',
      'options': ['Three - Karma, Bhakti, and Jnana', 'Two - Theory and Practice', 'Five major paths', 'Seven spiritual methods'],
      'optionsGujarati': ['ત્રણ - કર્મ, ભક્તિ, અને જ્ઞાન', 'બે - સિદ્ધાંત અને પ્રક્રિયા', 'પાંચ મુખ્ય માર્ગો', 'સાત આધ્યાત્મિક પદ્ધતિઓ'],
    },
    {
      'textEnglish': 'What is the Bhagavad Gita?',
      'textGujarati': 'ભગવદ્ગીતા શું છે?',
      'answerEnglish': 'Divine teachings of Krishna to Arjun',
      'answerGujarati': 'શ્રી કૃષ્ણના આર્જુનને આપેલ શીક્ષા',
      'options': ['Divine teachings of Krishna to Arjun', 'A love story of gods', 'A military strategy book', 'A collection of poems'],
      'optionsGujarati': ['શ્રી કૃષ્ણના આર્જુનને આપેલ શીક્ષા', 'દેવતાઓની પ્રેમકથા', 'લશ્કરી આયોજન પુસ્તક', 'કવિતાઓનો સંગ્રહ'],
    },
    {
      'textEnglish': 'What are Hindu philosophy systems?',
      'textGujarati': 'હિંદુ તત્ત્વશાસ્ત્રની પ્રણાલીઓ શું છે?',
      'answerEnglish': 'Six major systems',
      'answerGujarati': 'છ મુખ્ય પ્રણાલીઓ',
      'options': ['Six major systems', 'Four main systems', 'Ten systems', 'Eight sacred systems'],
      'optionsGujarati': ['છ મુખ્ય પ્રણાલીઓ', 'ચાર મુખ્ય પ્રણાલીઓ', 'દશ પ્રણાલીઓ', 'આઠ પવિત્ર પ્રણાલીઓ'],
    },
  ];

  static final satsangiJivanQuestions = [
    {
      'textEnglish': 'Who was first follower of Swaminarayan?',
      'textGujarati': 'સ્વામીનારાયણનો પ્રથમ અનુયાયી કોણ હતો?',
      'answerEnglish': 'Nityananda Swami',
      'answerGujarati': 'નિત્યાનંદ સ્વામી',
      'options': ['Nityananda Swami', 'Gunatitanand Swami', 'Brahmanand Swami', 'Muktanand Swami'],
      'optionsGujarati': ['નિત્યાનંદ સ્વામી', 'ગુણાતીતાનંદ સ્વામી', 'બ્રહ્માનંદ સ્વામી', 'મુક્તાનંદ સ્વામી'],
    },
    {
      'textEnglish': 'What message did Swaminarayan bring?',
      'textGujarati': 'સ્વામીનારાયણ શું સંદેશ લાવ્યા?',
      'answerEnglish': 'Message of devotion and morality',
      'answerGujarati': 'ભક્તિ અને નૈતિકતાનો સંદેશ',
      'options': ['Message of devotion and morality', 'Message of wealth accumulation', 'Message of military strength', 'Message of political power'],
      'optionsGujarati': ['ભક્તિ અને નૈતિકતાનો સંદેશ', 'સંપત્તિ એકત્ર કરવાનો સંદેશ', 'લશ્કરી શક્તિનો સંદેશ', 'રાજનીતિક શક્તિનો સંદેશ'],
    },
    {
      'textEnglish': 'How many principal disciples did Swaminarayan have?',
      'textGujarati': 'સ્વામીનારાયણને કેટલા મુખ્ય શિષ્યો હતા?',
      'answerEnglish': 'Five main disciples',
      'answerGujarati': 'પાંચ મુખ્ય શિષ્યો',
      'options': ['Five main disciples', 'Three disciples', 'Seven disciples', 'Twelve disciples'],
      'optionsGujarati': ['પાંચ મુખ્ય શિષ્યો', 'ત્રણ શિષ્યો', 'સાત શિષ્યો', 'બાર શિષ્યો'],
    },
    {
      'textEnglish': 'What is a satsangi?',
      'textGujarati': 'સત્સંગી શું છે?',
      'answerEnglish': 'A true devotee of God',
      'answerGujarati': 'ભગવાનનો સાચો ભક્ત',
      'options': ['A true devotee of God', 'A political leader', 'A business person', 'A military general'],
      'optionsGujarati': ['ભગવાનનો સાચો ભક્ત', 'એક રાજનીતિક નેતા', 'એક વ્યવસાયી', 'એક લશ્કરી જનરલ'],
    },
    {
      'textEnglish': 'What are the qualities of a satsangi?',
      'textGujarati': 'સત્સંગીના ગુણો શું છે?',
      'answerEnglish': 'Truthfulness, purity, and devotion',
      'answerGujarati': 'સત્યતા, શુદ્ધતા અને ભક્તિ',
      'options': ['Truthfulness, purity, and devotion', 'Wealth, power, and fame', 'Strength, intelligence, and beauty', 'Cunning, intelligence, and strategy'],
      'optionsGujarati': ['સત્યતા, શુદ્ધતા અને ભક્તિ', 'સંપત્તિ, શક્તિ અને પ્રખ્યાતિ', 'શક્તિ, બુદ્ધિમત્તા અને સુંદરતા', 'કપટ, બુદ્ધિમત્તા અને આયોજન'],
    },
    {
      'textEnglish': 'How did Swaminarayan spread the faith?',
      'textGujarati': 'સ્વામીનારાયણ આસ્થા કેવી રીતે ફેલાવી?',
      'answerEnglish': 'Through personal example and teachings',
      'answerGujarati': 'વ્યક્તિગત ઉદાહરણ અને શીક્ષા દ્વારા',
      'options': ['Through personal example and teachings', 'Through force and conquest', 'Through political influence', 'Through economic control'],
      'optionsGujarati': ['વ્યક્તિગત ઉદાહરણ અને શીક્ષા દ્વારા', 'બળ અને વિજય દ્વારા', 'રાજનીતિક પ્રભાવ દ્વારા', 'આર્થિક નિયંત્રણ દ્વારા'],
    },
    {
      'textEnglish': 'What role does a guru play?',
      'textGujarati': 'આધ્યાત્મિક માર્ગે ગુરુની ભૂમિકા શું છે?',
      'answerEnglish': 'Guide and mentor on spiritual path',
      'answerGujarati': 'આધ્યાત્મિક માર્ગે માર્ગદર્શક અને શિક્ષક',
      'options': ['Guide and mentor on spiritual path', 'Provider of material wealth', 'Political advisor', 'Military commander'],
      'optionsGujarati': ['આધ્યાત્મિક માર્ગે માર્ગદર્શક અને શિક્ષક', 'ભૌતિક સંપત્તિનો પ્રદાતા', 'રાજનીતિક સલાહકાર', 'લશ્કરી કમાન્ડર'],
    },
    {
      'textEnglish': 'What are benefits of satsang?',
      'textGujarati': 'સત્સંગનાં લાભો શું છે?',
      'answerEnglish': 'Spiritual growth and moral development',
      'answerGujarati': 'આધ્યાત્મિક વૃદ્ધિ અને નૈતિક વિકાસ',
      'options': ['Spiritual growth and moral development', 'Financial gains', 'Political power', 'Social status'],
      'optionsGujarati': ['આધ્યાત્મિક વૃદ્ધિ અને નૈતિક વિકાસ', 'આર્થિક લાભ', 'રાજનીતિક શક્તિ', 'સામાજિક દર્જો'],
    },
    {
      'textEnglish': 'How should one respect a guru?',
      'textGujarati': 'ગુરુને કેવી રીતે શ્રદ્ધા મૂકવી?',
      'answerEnglish': 'With total faith and obedience',
      'answerGujarati': 'સંપૂર્ણ શ્રદ્ધા અને આજ્ઞાકારથી',
      'options': ['With total faith and obedience', 'With skepticism and doubt', 'With indifference', 'With criticism'],
      'optionsGujarati': ['સંપૂર્ણ શ્રદ્ધા અને આજ્ઞાકારથી', 'શંકા અને સંદેહ સાથે', 'ઉદાસીનતા સાથે', 'ટીકા સાથે'],
    },
    {
      'textEnglish': 'What is a guru mantra?',
      'textGujarati': 'ગુરુ મંત્રનો અર્થ શું છે?',
      'answerEnglish': 'Sacred words for meditation by guru',
      'answerGujarati': 'ગુરુ દ્વારા આપવામાં આવેલ પવિત્ર શબ્દો',
      'options': ['Sacred words for meditation by guru', 'A business contract', 'A political agreement', 'A military strategy'],
      'optionsGujarati': ['ગુરુ દ્વારા આપવામાં આવેલ પવિત્ર શબ્દો', 'એક વ્યવસાયી સમજૂતી', 'એક રાજનીતિક સમજૂતી', 'એક લશ્કરી આયોજન'],
    },
  ];
}
