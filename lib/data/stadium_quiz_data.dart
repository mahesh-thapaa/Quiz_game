import '../models/stadium_question_model.dart';

class StadiumQuizData {
  static List<StadiumQuestionModel> getQuestions() {
    return [
      StadiumQuestionModel(
        questionNumber: 1,
        totalQuestions: 10,
        imagePath: "assets/stadiums/camp_nou.jpg",
        questionText: "WHICH STADIUM IS THIS?",
        options: [
          "Santiago Bernabéu",
          "Camp Nou",
          "Old Trafford",
          "Allianz Arena",
        ],
        correctIndex: 1,
      ),

      StadiumQuestionModel(
        questionNumber: 2,
        totalQuestions: 10,
        imagePath: "assets/stadiums/old_trafford.jpg",
        questionText: "WHICH STADIUM IS THIS?",
        options: [
          "Anfield",
          "Old Trafford",
          "Etihad Stadium",
          "Emirates Stadium",
        ],
        correctIndex: 3,
      ),

      StadiumQuestionModel(
        questionNumber: 3,
        totalQuestions: 10,
        imagePath: "assets/stadiums/santiago_bernabeu.jpg",
        questionText: "WHICH STADIUM IS THIS?",
        options: [
          "Camp Nou",
          "Signal Iduna Park",
          "Santiago Bernabéu",
          "San Siro",
        ],
        correctIndex: 4,
      ),

      StadiumQuestionModel(
        questionNumber: 4,
        totalQuestions: 10,
        imagePath: "assets/stadiums/anfield.jpg",
        questionText: "WHICH STADIUM IS THIS?",
        options: [
          "Anfield",
          "Stamford Bridge",
          "Tottenham Stadium",
          "Wembley",
        ],
        correctIndex: 1,
      ),

      StadiumQuestionModel(
        questionNumber: 5,
        totalQuestions: 10,
        imagePath: "assets/stadiums/allianz_arena.jpg",
        questionText: "WHICH STADIUM IS THIS?",
        options: [
          "Allianz Arena",
          "Camp Nou",
          "Parc des Princes",
          "San Siro",
        ],
        correctIndex: 2,
      ),

      StadiumQuestionModel(
        questionNumber: 6,
        totalQuestions: 10,
        imagePath: "assets/stadiums/san_siro.jpg",
        questionText: "WHICH STADIUM IS THIS?",
        options: [
          "San Siro",
          "Old Trafford",
          "Signal Iduna Park",
          "Anfield",
        ],
        correctIndex: 3,
      ),

      StadiumQuestionModel(
        questionNumber: 7,
        totalQuestions: 10,
        imagePath: "assets/stadiums/signal_iduna_park.jpg",
        questionText: "WHICH STADIUM IS THIS?",
        options: [
          "Signal Iduna Park",
          "Allianz Arena",
          "Santiago Bernabéu",
          "Wembley",
        ],
        correctIndex: 2,
      ),

      StadiumQuestionModel(
        questionNumber: 8,
        totalQuestions: 10,
        imagePath: "assets/stadiums/wembley.jpg",
        questionText: "WHICH STADIUM IS THIS?",
        options: [
          "Emirates Stadium",
          "Wembley",
          "Etihad Stadium",
          "Anfield",
        ],
        correctIndex: 2,
      ),

      StadiumQuestionModel(
        questionNumber: 9,
        totalQuestions: 10,
        imagePath: "assets/stadiums/parc_des_princes.jpg",
        questionText: "WHICH STADIUM IS THIS?",
        options: [
          "Parc des Princes",
          "San Siro",
          "Camp Nou",
          "Allianz Arena",
        ],
        correctIndex: 0,
      ),

      StadiumQuestionModel(
        questionNumber: 10,
        totalQuestions: 10,
        imagePath: "assets/stadiums/emirates.jpg",
        questionText: "WHICH STADIUM IS THIS?",
        options: [
          "Old Trafford",
          "Emirates Stadium",
          "Tottenham Stadium",
          "Anfield",
        ],
        correctIndex: 1,
      ),
    ];
  }
}