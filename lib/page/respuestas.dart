import 'package:flutter/material.dart';

class AnswersPage extends StatelessWidget {
  final List<Map<String, dynamic>> allQuestions;
  final List<Map<String, dynamic>> correctAnswers;

  const AnswersPage({
    Key? key,
    required this.allQuestions,
    required this.correctAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Respuestas Correctas', style: TextStyle(color: Colors.greenAccent)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: allQuestions.length,
          itemBuilder: (context, index) {
            final question = allQuestions[index];
            final correctAnswer = correctAnswers[index];

            return Card(
              color: Colors.grey[800],
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pregunta ${index + 1}: ${question['pregunta']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Respuesta Correcta: ${correctAnswer['rest']}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
