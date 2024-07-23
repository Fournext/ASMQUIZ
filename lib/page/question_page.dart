import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'score_page.dart';
import 'spin_count_service.dart';

class QuestionPage extends StatefulWidget {
  final String selectedOption;
  final List<Map<String, dynamic>> allQuestions;
  final String imagePath;

  const QuestionPage({
    Key? key,
    required this.selectedOption,
    required this.allQuestions,
    required this.imagePath,
  }) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int i = 0;
  late Timer _timer;
  int _secondsRemaining = 30;
  int _score = 0;
  late Map<String, dynamic> _currentQuestion;
  final int _cantidadDePreguntas = 5;
  bool _isDisposed = false;
  Set<int> _usedQuestionIndexes = {};
  List<Map<String, dynamic>> _selectedQuestions = [];
  late String _currentImage;
  String _selectedOption = '';
  bool _isOptionSelected = false;
  List<bool> _isOptionCorrect = [];

  @override
  void initState() {
    super.initState();
    _currentQuestion = _getRandomQuestion();
    _currentImage = _getImageForQuestion();
    _isOptionCorrect = List.filled(_currentQuestion['respuestas'].length, false);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isDisposed) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            timer.cancel();
            _handleTimeUp();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _handleTimeUp() {
    if (!_isDisposed) {
      if (_usedQuestionIndexes.length >= _cantidadDePreguntas || _usedQuestionIndexes.length >= widget.allQuestions.length) {
        _navigateToScorePage();
      } else {
        _navigateToNextQuestion();
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _isDisposed = true;
    super.dispose();
  }

  Map<String, dynamic> _getRandomQuestion() {
    final random = Random();
    int randomIndex;

    do {
      randomIndex = random.nextInt(widget.allQuestions.length);
    } while (_usedQuestionIndexes.contains(randomIndex));
    i = 1 + randomIndex;
    _usedQuestionIndexes.add(randomIndex);
    _selectedQuestions.add(widget.allQuestions[randomIndex]);
    return widget.allQuestions[randomIndex];
  }

  // Saca la imagen de la caretoria con la dificultad
  String _getImageForQuestion() {
    final String category = widget.selectedOption.split(' - ')[0];
    final String difficulty = widget.selectedOption.split(' - ')[1];
    if (category == 'programacion' && difficulty == 'easy') {
      return 'assets/images/$category-$difficulty $i.png';
    } else {
      return widget.imagePath;
    }
  }

  void _onOptionSelected(Map<String, dynamic> option, int index) {
    if (mounted && !_isOptionSelected) {
      setState(() {
        _selectedOption = option['rest'];
        _isOptionSelected = true;
        _timer.cancel();

        for (int i = 0; i < _currentQuestion['respuestas'].length; i++) {
          if (_currentQuestion['respuestas'][i] == option) {
            _isOptionCorrect[i] = true;
          } else {
            _isOptionCorrect[i] = false;
          }
        }

        if (option['rest_correct'] == 1) {
          _score += _calculateScore(option);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('¡Respuesta correcta! Puntaje: $_score')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Respuesta incorrecta')),
          );
        }

        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _handleTimeUp();
              _isOptionSelected = false;
              _selectedOption = '';
              _isOptionCorrect = List.filled(_currentQuestion['respuestas'].length, false);
            });
          }
        });
      });
    }
  }

  int _calculateScore(Map<String, dynamic> option) {
    return 10;
  }

  void _navigateToScorePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ScorePage(
          score: _score,
          restartScore: _restartScore,
          restartTimer: _restartTimer,
          allQuestions: _selectedQuestions,
          correctAnswers: _selectedQuestions.map((question) => question['respuestas'].firstWhere((answer) => answer['rest_correct'] == 1)).toList().cast<Map<String, dynamic>>(),
        ),
      ),
    );
  }

  void _navigateToNextQuestion() {
    setState(() {
      _secondsRemaining = 30;
      _currentQuestion = _getRandomQuestion();
      _currentImage = _getImageForQuestion();
    });
    _startTimer();
  }

  void _restartScore() {
    if (!_isDisposed) {
      setState(() {
        _score = 0;
        _usedQuestionIndexes.clear();
        SpinCountService().resetSpinCount();
      });
    }
  }

  void _restartTimer() {
    if (mounted) {
      setState(() {
        _secondsRemaining = 30;
      });
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    String timerText = '${(_secondsRemaining % 60).toString().padLeft(2, '0')}';
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.selectedOption,
              style: TextStyle(color: Colors.greenAccent, fontSize: 16),
            ),
            Text(
              '${_usedQuestionIndexes.length}/$_cantidadDePreguntas',
              style: TextStyle(color: Colors.greenAccent, fontSize: 16),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/IconoTemporizador2.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 8),
                Text(
                  timerText,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.greenAccent,
                    fontFamily: 'Courier',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          padding: const EdgeInsets.only(top: 20),
          children: [
            Text(
              _currentQuestion['pregunta'] as String,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
                fontFamily: 'Courier',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  _currentImage,
                  width: 300,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 20),
            for (int index = 0; index < _currentQuestion['respuestas'].length; index++) ...[
              ElevatedButton(
                onPressed: () => _onOptionSelected(_currentQuestion['respuestas'][index], index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedOption.isNotEmpty && _selectedOption == _currentQuestion['respuestas'][index]['rest']
                      ? (_currentQuestion['respuestas'][index]['rest_correct'] == 1 ? Colors.green : Colors.red)
                      : _isOptionCorrect[index]
                          ? Colors.green
                          : Colors.greenAccent,
                ),
                child: Text(
                  _currentQuestion['respuestas'][index]['rest'] != null
                      ? _currentQuestion['respuestas'][index]['rest'] as String
                      : 'Opción inválida',
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Courier',
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}
