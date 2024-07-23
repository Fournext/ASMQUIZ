import 'package:asmquiz/page/respuestas.dart';
import 'package:flutter/material.dart';
import 'ruleta.dart'; // Importa el archivo donde está definida SpinWheel

class ScorePage extends StatelessWidget {
  final int score;
  final VoidCallback restartScore;
  final VoidCallback restartTimer;
  final List<Map<String, dynamic>> allQuestions; // Añade la lista de preguntas
  final List<Map<String, dynamic>> correctAnswers; // Añade la lista de respuestas correctas

  const ScorePage({
    Key? key,
    required this.score,
    required this.restartScore,
    required this.restartTimer,
    required this.allQuestions,
    required this.correctAnswers,
  }) : super(key: key);

  void _restartQuiz(BuildContext context) {
    restartScore();
    restartTimer();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SpinWheel(), // Navega a SpinWheel al reiniciar
      ),
    );
  }

  void _viewAnswers(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnswersPage(allQuestions: allQuestions, correctAnswers: correctAnswers),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados', style: TextStyle(color: Colors.greenAccent)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
      ),
      body: Container(
        color: Colors.black,
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Puntaje Final: $score',
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _restartQuiz(context),
              child: Container(
                height: 40,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Center(
                  child: Text(
                    "REINICIAR",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _viewAnswers(context),
              child: Container(
                height: 40,
                width: 160, // Ajusta el ancho según tu diseño
                decoration: BoxDecoration(
                  color: Colors.greenAccent, // Color para "Ver Respuestas"
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Center(
                  child: Text(
                    "VER RESPUESTAS",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
