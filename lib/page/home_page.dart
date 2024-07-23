import 'package:asmquiz/page/ruleta.dart';
//import 'package:asmquiz/page/scores.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = '';
  bool _isFirstTime = true;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('userName');
    if (name != null) {
      setState(() {
        _userName = name;
        _isFirstTime = false;
      });
    }
  }

  Future<void> _saveName() async {
    if (_nameController.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', _nameController.text);
      setState(() {
        _userName = _nameController.text;
        _isFirstTime = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ASM Quiz',
          style: TextStyle(
            color: Colors.greenAccent,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.black,
        child: _isFirstTime ? _buildWelcomeScreen() : _buildMainScreen(),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Bienvenido a ASM Quiz',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent,
            fontFamily: 'Courier', // Estilo de fuente monoespaciada
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        const Text(
          'Por favor, introduce tu nombre:',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontFamily: 'Courier',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _nameController,
          style: const TextStyle(
            color: Colors.greenAccent, 
            fontFamily: 'Courier'
          ),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nombre de usuario',
            labelStyle: TextStyle(color: Colors.greenAccent),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _saveName,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
          ),
          child: const Text(
            'Guardar Nombre',
            style: TextStyle(
              color: Colors.black, 
              fontFamily: 'Courier',
              fontSize: 20
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Bienvenido, $_userName',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent,
            fontFamily: 'Courier',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        const Text(
          'Ponte a prueba con nuestras preguntas y mejora tus conocimientos.',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontFamily: 'Courier',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SpinWheel()), // Ajustado a SpinWheel
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
          ),
          child: const Text(
            'Comenzar Quiz',
            style: TextStyle(
              color: Colors.black, 
              fontFamily: 'Courier',
              fontSize: 20
            ),
          ),
        ),
        
      ],
    );
  }
}
