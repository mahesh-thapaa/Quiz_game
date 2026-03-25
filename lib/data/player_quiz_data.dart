// lib/data/player_quiz_data.dart

import '../models/player_question_model.dart';

class PlayerQuizData {
  static List<PlayerQuestion> getQuestions() {
    return [
      PlayerQuestion(
        questionNumber: 1,
        totalQuestions: 10,
        imagePath: "asstes/images/ronaldo.png",
        questionText: "WHO IS THIS PLAYER?",
        options: [
          "Tom Brady",
          "Cristiano Ronaldo",
          "Patrick Mahomes",
          "Aaron Rodgers",
        ],
        correctIndex: 2,
      ),
      PlayerQuestion(
        questionNumber: 2,
        totalQuestions: 10,
        imagePath: "asstes/images/lm10.jpeg",
        questionText: "WHO IS THIS PLAYER?",
        options: [
          "Cristiano Ronaldo",
          "Ronaldinho",
          "Linol Messi",
          "Zinedine Zidane",
        ],
        correctIndex: 3,
      ),
      PlayerQuestion(
        questionNumber: 3,
        totalQuestions: 10,
        imagePath: "asstes/images/vini.jpeg",
        questionText: "WHO IS THIS PLAYER?",
        options: [
          "Sadio Mané",
          "Mohamed Salah",
          "Riyad Mahrez",
          "Vinicious Jr",
        ],
        correctIndex: 4,
      ),
      PlayerQuestion(
        questionNumber: 4,
        totalQuestions: 10,
        imagePath: "asstes/images/njr.jpeg",
        questionText: "WHO IS THIS PLAYER?",
        options: [
          "Neymar Jr",
          "Luis Suárez",
          "Edinson Cavani",
          "Sergio Agüero",
        ],
        correctIndex: 1,
      ),
      PlayerQuestion(
        questionNumber: 5,
        totalQuestions: 10,
        imagePath: "asstes/images/hk.jpeg",
        questionText: "WHO IS THIS PLAYER?",
        options: [
          "Cristiano Ronaldo",
          "Antoine Griezmann",
          "Harry Kane",
          "Romelu Lukaku",
        ],
        correctIndex: 3,
      ),
      PlayerQuestion(
        questionNumber: 6,
        totalQuestions: 10,
        imagePath: "asstes/images/kdb.jpeg",
        questionText: "WHO IS THIS PLAYER?",
        options: [
          "Kevin De Bruyne",
          "Luka Modrić",
          "Romelu Lukaku",
          "Paul Pogba",
        ],
        correctIndex: 1,
      ),
      PlayerQuestion(
        questionNumber: 7,
        totalQuestions: 10,
        imagePath: "asstes/images/zinedinezidande.jpeg",
        questionText: "WHO IS THIS PLAYER?",
        options: ["Pelé", "Diego Maradona", "Ronaldo", "Zidane"],
        correctIndex: 4,
      ),
      PlayerQuestion(
        questionNumber: 8,
        totalQuestions: 10,
        imagePath: "asstes/images/andycole.jpeg",
        questionText: "WHO IS THIS PLAYER?",
        options: [
          "Wayne Rooney",
          "Andrew Cole",
          "Alan Shearer",
          "Frank Lampard",
        ],
        correctIndex: 2,
      ),
      PlayerQuestion(
        questionNumber: 9,
        totalQuestions: 10,
        imagePath: "asstes/images/martinodegaard.jpeg",
        questionText: "WHO IS THIS PLAYER?",
        options: [
          "Martin Ødegaard",
          "Erling Haaland",
          "Marcus Rashford",
          "Darwin Núñez",
        ],
        correctIndex: 1,
      ),
      PlayerQuestion(
        questionNumber: 10,
        totalQuestions: 10,
        imagePath: "asstes/images/romario.jpeg",
        questionText: "WHO IS THIS PLAYER?",
        options: ["Lionel Messi", "Cristiano Ronaldo", "Ali Daei", "Romário"],
        correctIndex: 4,
      ),
    ];
  }
}
