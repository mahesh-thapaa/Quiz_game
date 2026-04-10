import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

final Random random = Random();

class Database {
  final String title;
  final List<String> options;
  final int correctAnswerIndex;
  final String? imagePath;

  Database({
    required this.title,
    required this.options,
    required this.correctAnswerIndex,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'imagePath': imagePath ?? '',
    };
  }
}

final List<Database> playerQuiz = [
  Database(
    title: "WHO IS THIS PLAYER?",
    options: [
      "Tom Brady",
      "Cristiano Ronaldo",
      "Patrick Mahomes",
      "Aaron Rodgers",
    ],
    correctAnswerIndex: 1,
    imagePath: "asstes/images/ronaldo.png",
  ),
  Database(
    title: "WHO IS THIS PLAYER?",
    options: [
      "Cristiano Ronaldo",
      "Ronaldinho",
      "Linol Messi",
      "Zinedine Zidane",
    ],
    correctAnswerIndex: 2,
    imagePath: "asstes/images/lm10.jpeg",
  ),
  Database(
    title: "WHO IS THIS PLAYER?",
    options: ["Sadio Mané", "Mohamed Salah", "Riyad Mahrez", "Vinicious Jr"],
    correctAnswerIndex: 3,
    imagePath: "asstes/images/vini.jpeg",
  ),
  Database(
    title: "WHO IS THIS PLAYER?",
    options: ["Neymar Jr", "Luis Suárez", "Edinson Cavani", "Sergio Agüero"],
    correctAnswerIndex: 1,
    imagePath: "asstes/images/njr.jpeg",
  ),
  Database(
    title: "WHO IS THIS PLAYER?",
    options: [
      "Cristiano Ronaldo",
      "Antoine Griezmann",
      "Harry Kane",
      "Romelu Lukaku",
    ],

    correctAnswerIndex: 2,
    imagePath: "asstes/images/hk.jpeg",
  ),
  Database(
    title: "WHO IS THIS PLAYER?",
    options: ["Kevin De Bruyne", "Luka Modrić", "Romelu Lukaku", "Paul Pogba"],
    correctAnswerIndex: 0,
    imagePath: "asstes/images/kdb.jpeg",
  ),
  Database(
    title: "WHO IS THIS PLAYER?",
    options: ["Pelé", "Diego Maradona", "Ronaldo", "Zidane"],
    correctAnswerIndex: 3,
    imagePath: "asstes/images/zinedinezidane.jpeg",
  ),
  Database(
    title: "WHO IS THIS PLAYER?",
    options: ["Lionel Messi", "Cristiano Ronaldo", "Ali Daei", "Romário"],
    correctAnswerIndex: 3,
    imagePath: "asstes/images/andycole.jpeg",
  ),
  Database(
    title: "WHO IS THIS PLAYER?",
    options: ["Wayne Rooney", "Andrew Cole", "Alan Shearer", "Frank Lampard"],
    correctAnswerIndex: 1,
    imagePath: '',
  ),
  Database(
    title: "WHO IS THIS PLAYER?",
    options: [
      "Martin Ødegaard",
      "Erling Haaland",
      "Marcus Rashford",
      "Darwin Núñez",
    ],
    correctAnswerIndex: 0,
    imagePath: "asstes/images/martinodegaard.jpeg",
  ),
  Database(
    title: "WHO IS THIS PLAYER?",
    options: ["Lionel Messi", "Cristiano Ronaldo", "Ali Daei", "Romário"],
    correctAnswerIndex: 3,
    imagePath: "asstes/images/romario.jpeg",
  ),
];

final List<Database> stadiumQuiz = [
  Database(
    title: "WHICH STADIUM IS THIS?",
    options: ["Santiago Bernabéu", "Camp Nou", "Old Trafford", "Allianz Arena"],
    correctAnswerIndex: 0,
    imagePath: "asstes/images/sb.jpeg",
  ),
  Database(
    title: "WHICH STADIUM IS THIS?",
    options: ["Anfield", "Old Trafford", "Etihad Stadium", "Emirates Stadium"],
    correctAnswerIndex: 2,
    imagePath: "asstes/images/es.jpeg",
  ),
  Database(
    title: "WHICH STADIUM IS THIS?",
    options: ["Camp Nou", "Signal Iduna Park", "Santiago Bernabéu", "San Siro"],
    correctAnswerIndex: 3,
    imagePath: "asstes/images/ss.jpeg",
  ),
  Database(
    title: "WHICH STADIUM IS THIS?",
    options: ["Anfield", "Stamford Bridge", "Tottenham Stadium", "Wembley"],
    correctAnswerIndex: 0,
    imagePath: "asstes/images/a.jpeg",
  ),
  Database(
    title: "WHICH STADIUM IS THIS?",
    options: ["Allianz Arena", "Camp Nou", "Parc des Princes", "San Siro"],

    correctAnswerIndex: 1,
    imagePath: "asstes/images/cn.jpeg",
  ),
  Database(
    title: "WHICH STADIUM IS THIS?",
    options: ["San Siro", "Old Trafford", "Signal Iduna Park", "Anfield"],
    correctAnswerIndex: 1,
    imagePath: "asstes/images/ot.jpeg",
  ),
  Database(
    title: "WHICH STADIUM IS THIS?",
    options: [
      "Signal Iduna Park",
      "Allianz Arena",
      "Santiago Bernabéu",
      "Wembley",
    ],
    correctAnswerIndex: 1,
    imagePath: "asstes/images/aa.jpeg",
  ),
  Database(
    title: "WHICH STADIUM IS THIS?",
    options: ["Emirates Stadium", "Wembley", "Etihad Stadium", "Anfield"],
    correctAnswerIndex: 1,
    imagePath: "asstes/images/w.jpeg",
  ),
  Database(
    title: "WHICH STADIUM IS THIS?",
    options: ["Parc des Princes", "San Siro", "Camp Nou", "Allianz Arena"],
    correctAnswerIndex: 1,
    imagePath: "asstes/images/pdl.jpeg",
  ),
  Database(
    title: "WHICH STADIUM IS THIS?",
    options: [
      "Anfield",
      "Emirates Stadium",
      "Tottenham Stadium",
      "Old Trafford",
    ],
    correctAnswerIndex: 2,
    imagePath: "asstes/images/ts.jpeg",
  ),
];

final List<Database> jerseyQuiz = [
  Database(
    title: "WHICH CLUB JERSEY IS THIS?",
    options: ["Arsenal", "Liverpool", "Manchester United", "Bayern Munich"],
    correctAnswerIndex: 0,
    imagePath: "asstes/images/arsenal.jpeg",
  ),
  Database(
    title: "WHICH CLUB JERSEY IS THIS?",
    options: ["Liverpool", "Chelsea", "Barcelona", "Juventus"],
    correctAnswerIndex: 1,
    imagePath: "asstes/images/chelsea.jpeg",
  ),
  Database(
    title: "WHICH CLUB JERSEY IS THIS?",
    options: ["Real Madrid", "Tottenham", "Leeds United", "Swansea City"],
    correctAnswerIndex: 0,
    imagePath: "asstes/images/real_madrid.jpeg",
  ),
  Database(
    title: "WHICH CLUB JERSEY IS THIS?",
    options: ["Chelsea", "Barcelona", "Real Madrid", "Juventus"],
    correctAnswerIndex: 1,
    imagePath: "asstes/images/barcelona.jpeg",
  ),
  Database(
    title: "WHICH CLUB JERSEY IS THIS?",
    options: ["Dortmund", "Juventus", "Inter Milan", "Newcast le United"],
    correctAnswerIndex: 1,
    imagePath: "asstes/images/dortmund.jpeg",
  ),
  Database(
    title: "WHICH CLUB JERSEY IS THIS?",
    options: ["Atletico Club", "Real Betis", "Arsenal", "Atletico"],
    correctAnswerIndex: 3,
    imagePath: "asstes/images/atletico.jpeg",
  ),
  Database(
    title: "WHICH CLUB JERSEY IS THIS?",
    options: ["AC Milan", "Juventus", "Atletico Madrid", "River Plate"],
    correctAnswerIndex: 1,
    imagePath: "asstes/images/juventus.jpeg",
  ),
  Database(
    title: "WHICH CLUB JERSEY IS THIS?",
    options: ["West Ham", "Man United", "Liverpool", "Man City"],
    correctAnswerIndex: 2,
    imagePath: "asstes/images/liverpool.jpeg",
  ),
  Database(
    title: "WHICH CLUB JERSEY IS THIS?",
    options: ["Manchester City", "Napoli", "Argentina", "Lazio"],
    correctAnswerIndex: 0,
    imagePath: "asstes/images/Manchester_City.jpeg",
  ),
  Database(
    title: "WHICH CLUB JERSEY IS THIS?",
    options: ["RC Lens", "Monaco", "Olympic Lyon", "PSG"],
    correctAnswerIndex: 3,
    imagePath: "asstes/images/psg.jpeg",
  ),
];
final List<Database> clubQuiz = [
  Database(
    title: "WHICH CLUB HAS WON THE MOST UEFA CHAMPIONS LEAGUE TITLES?",
    options: ["Real Madrid", "Barcelona", "Bayern Munich", "Liverpool"],
    correctAnswerIndex: 0,
  ),
  Database(
    title: "IN WHICH YEAR WAS FC BARCELONA FOUNDED?",
    options: ["1892", "1899", "1905", "1910"],
    correctAnswerIndex: 1,
  ),
  Database(
    title: "WHICH CLUB IS KNOWN AS 'THE RED DEVILS'?",
    options: ["Liverpool", "Arsenal", "Manchester United", "Chelsea"],
    correctAnswerIndex: 2,
  ),
  Database(
    title: "WHICH STADIUM IS KNOWN AS 'THE THEATRE OF DREAMS'?",
    options: ["Anfield", "Old Trafford", "Stamford Bridge", "Emirates Stadium"],
    correctAnswerIndex: 1,
  ),
  Database(
    title:
        "WHICH CLUB WON THE FIRST EVER PREMIER LEAGUE TITLE IN 1992-93            ?",
    options: ["Arsenal", "Chelsea", "Manchester United", "Blackburn Rovers"],
    correctAnswerIndex: 2,
  ),
  Database(
    title: "WHICH ITALIAN CLUB HAS WON THE MOST SERIE A TITLES?",
    options: ["AC Milan", "Inter Milan", "Juventus", "AS Roma"],
    correctAnswerIndex: 2,
  ),
  Database(
    title: "WHICH CLUB IS NICKNAMED 'THE GUNNERS'?",
    options: ["Tottenham", "Arsenal", "West Ham", "Everton"],
    correctAnswerIndex: 1,
  ),
  Database(
    title: "WHICH CLUB IS KNOWN AS 'THE BLUES'?",
    options: ["Chelsea", "Manchester City", "Inter Milan", "Napoli "],
    correctAnswerIndex: 0,
  ),
  Database(
    title: "WHICH CLUB IS NICKNAMED 'THE REDS'?",
    options: ["Liverpool", "Manchester United", "Arsenal", "Bayern Munich"],
    correctAnswerIndex: 0,
  ),
  Database(
    title: "WHICH CLUB HAS THE MOST LEGENDS IN THE BALLON D'OR HISTORY?",
    options: ["Real Madrid", "Barcelona", "AC Milan", "Juventus"],
    correctAnswerIndex: 0,
  ),
];

Future<void> _insertToCollection(
  String quizAppCollection,
  List<Database> list,
) async {
  try {
    final CollectionReference ref = FirebaseFirestore.instance.collection(
      quizAppCollection,
    );

    for (final Database database in list) {
      final String id =
          DateTime.now().millisecondsSinceEpoch.toString() +
          random.nextInt(1000).toString();

      await ref.doc(id).set(database.toMap());
      print('Inserted into $quizAppCollection: ${database.title}  ');

      await Future.delayed(const Duration(milliseconds: 100));
    }
  } catch (e) {
    print('Error inserting into $quizAppCollection: $e');
  }
}

Future<void> insertAllData() async {
  await _insertToCollection('playerQuiz', playerQuiz);
  await _insertToCollection('jerseyQuiz', jerseyQuiz);
  await _insertToCollection('stadiumQuiz', stadiumQuiz);
  await _insertToCollection('clubQuiz', clubQuiz);
}
