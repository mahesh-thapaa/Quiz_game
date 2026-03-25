// lib/data/club_data.dart

import '../models/club_question_model.dart';

class ClubData {
  static List<ClubQuestionModel> getQuestions() {
    return [
      ClubQuestionModel(
        questionNumber: 1,
        totalQuestions: 10,
        questionText:
            "WHICH CLUB HAS WON THE MOST UEFA CHAMPIONS LEAGUE TITLES?",
        options: ["Barcelona", "AC Milan", "Real Madrid", "Bayern Munich"],
        correctIndex: 2,
      ),
      ClubQuestionModel(
        questionNumber: 2,
        totalQuestions: 10,
        questionText: "IN WHICH YEAR WAS FC BARCELONA FOUNDED?",
        options: ["1892", "1899", "1905", "1910"],
        correctIndex: 1,
      ),
      ClubQuestionModel(
        questionNumber: 3,
        totalQuestions: 10,
        questionText: "WHICH CLUB IS KNOWN AS 'THE RED DEVILS'?",
        options: ["Liverpool", "Arsenal", "Manchester United", "Chelsea"],
        correctIndex: 2,
      ),
      ClubQuestionModel(
        questionNumber: 4,
        totalQuestions: 10,
        questionText: "WHICH STADIUM IS KNOWN AS 'THE THEATRE OF DREAMS'?",
        options: [
          "Anfield",
          "Old Trafford",
          "Stamford Bridge",
          "Emirates Stadium",
        ],
        correctIndex: 1,
      ),
      ClubQuestionModel(
        questionNumber: 5,
        totalQuestions: 10,
        questionText:
            "WHICH CLUB WON THE FIRST EVER PREMIER LEAGUE TITLE IN 1992-93?",
        options: [
          "Arsenal",
          "Chelsea",
          "Manchester United",
          "Blackburn Rovers",
        ],
        correctIndex: 2,
      ),
      ClubQuestionModel(
        questionNumber: 6,
        totalQuestions: 10,
        questionText: "WHICH ITALIAN CLUB HAS WON THE MOST SERIE A TITLES?",
        options: ["AC Milan", "Inter Milan", "Juventus", "AS Roma"],
        correctIndex: 2,
      ),
      ClubQuestionModel(
        questionNumber: 7,
        totalQuestions: 10,
        questionText: "WHICH CLUB IS NICKNAMED 'THE GUNNERS'?",
        options: ["Tottenham", "Arsenal", "West Ham", "Everton"],
        correctIndex: 1,
      ),
      ClubQuestionModel(
        questionNumber: 8,
        totalQuestions: 10,
        questionText: "REAL MADRID PLAYS THEIR HOME GAMES AT WHICH STADIUM?",
        options: [
          "Camp Nou",
          "Wanda Metropolitano",
          "Santiago Bernabéu",
          "Mestalla",
        ],
        correctIndex: 2,
      ),
      ClubQuestionModel(
        questionNumber: 9,
        totalQuestions: 10,
        questionText: "WHICH CLUB DID PELE SPEND MOST OF HIS CAREER AT?",
        options: ["Flamengo", "Santos", "Corinthians", "Vasco da Gama"],
        correctIndex: 1,
      ),
      ClubQuestionModel(
        questionNumber: 10,
        totalQuestions: 10,
        questionText:
            "WHICH ENGLISH CLUB HAS WON THE MOST TOP-FLIGHT LEAGUE TITLES?",
        options: ["Liverpool", "Arsenal", "Chelsea", "Manchester United"],
        correctIndex: 3,
      ),
    ];
  }
}
