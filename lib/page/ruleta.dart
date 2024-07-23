import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:asmquiz/page/question_page.dart';
import 'package:asmquiz/services/firebase_services.dart';

class SpinWheel extends StatefulWidget {
  const SpinWheel({Key? key}) : super(key: key);

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  final selected = BehaviorSubject<int>();
  String reward = '';
  bool isLoading = false;
  List<Map<String, dynamic>> allQuestions = [];
  String selectedDifficulty = ''; // Variable para almacenar la dificultad seleccionada

  List<String> items = [
    'historia', 'ejercicios', 'programacion', 'teoria'
  ];

  Map<String, String> categoryImages = {
    'historia': 'assets/images/historia.jpg',
    'ejercicios': 'assets/images/ejercicio.png',
    'programacion': 'assets/images/programacion.png',
    'teoria': 'assets/images/teoria.png',
  };

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  // Función para mostrar el diálogo de selección de dificultad
  void _showDifficultyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona la dificultad'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Fácil'),
                onTap: () {
                  setState(() {
                    selectedDifficulty = 'easy';
                    selected.add(Fortune.randomInt(0, items.length)); // Añadir esta línea para girar la ruleta después de seleccionar la dificultad
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Intermedio'),
                onTap: () {
                  setState(() {
                    selectedDifficulty = 'normal';
                    selected.add(Fortune.randomInt(0, items.length)); // Gira la ruleta despues de seleccionar la dificultad
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Difícil'),
                onTap: () {
                  setState(() {
                    selectedDifficulty = 'hard';
                    selected.add(Fortune.randomInt(0, items.length)); // Gira la ruleta despues de seleccionar la dificultad
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruleta de Categorías', style: TextStyle(color: Colors.greenAccent)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Gira la Ruleta',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                  fontFamily: 'Courier',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: FortuneWheel(
                  selected: selected.stream,
                  animateFirst: false,
                  items: [
                    for (int i = 0; i < items.length; i++)
                      FortuneItem(
                        child: Text(
                          items[i],
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Courier',
                            fontSize: 18,
                          ),
                        ),
                      ),
                  ],
                  onAnimationEnd: () {
                    setState(() {
                      reward = items[selected.value];
                      isLoading = true;
                    });

                    // Aquí se obtienen las preguntas y respuestas de la categoría seleccionada
                    getPreguntasYRespuestas(reward, selectedDifficulty).then((data) {
                      setState(() {
                        isLoading = false;
                      });

                      if (data.isNotEmpty) {
                        allQuestions = data;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionPage(
                              selectedOption: "$reward - $selectedDifficulty",
                              allQuestions: allQuestions,
                              imagePath: categoryImages[reward]!,
                            ),
                          ),
                        );

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al obtener preguntas')),
                        );
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              if (isLoading)
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                )
              else
                GestureDetector(
                  onTap: () {
                    _showDifficultyDialog(); // Mostrar el diálogo de selección de dificultad
                  },
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Center(
                      child: Text(
                        "SPIN",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Courier',
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
