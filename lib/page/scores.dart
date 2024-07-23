import 'package:flutter/material.dart';

class Scores extends StatelessWidget {
  final String userName;
  final int score;
  final String difficulty;

  const Scores({
    super.key,
    required this.userName,
    required this.score,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados del Quiz'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Resultados',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
                fontFamily: 'Courier',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Center(
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text(
                      'Usuario',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 18,
                        fontFamily: 'Courier',
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Puntaje',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 18,
                        fontFamily: 'Courier',
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Dificultad',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 18,
                        fontFamily: 'Courier',
                      ),
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Courier',
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          '$score',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Courier',
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          difficulty,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Courier',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
