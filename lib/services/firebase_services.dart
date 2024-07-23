import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getPreguntasYRespuestas(String categoria, String dificultad) async {
  try {
    // Obtener una referencia a la colección 'easy' dentro de la categoría proporcionada
    CollectionReference preguntasRef = db
        .collection('category')
        .doc(categoria)
        .collection(dificultad);

    // Obtener todos los documentos (preguntas) de la colección 'easy'
    QuerySnapshot preguntasSnapshot = await preguntasRef.get();

    List<Map<String, dynamic>> preguntasYRespuestas = [];

    // Iterar sobre cada documento (pregunta) en el snapshot
    int preguntaNumero = 1;
    await Future.forEach(preguntasSnapshot.docs, (pregDoc) async {
      // Obtener la pregunta
      String pregunta = '';
      var data = pregDoc.data();
      if (data is Map<String, dynamic>) {
        pregunta = data['pregt'] ?? '';
      }

      // Obtener todas las respuestas de la subcolección 'respuestas'
      QuerySnapshot respuestasSnapshot = await pregDoc.reference
          .collection('respuestas')
          .get();

      List<Map<String, dynamic>> respuestas = [];

      // Iterar sobre cada documento (respuesta) en el snapshot de respuestas
      respuestasSnapshot.docs.forEach((respDoc) {
        // Convertir explícitamente respDoc.data() a Map<String, dynamic>
        Map<String, dynamic> respuesta = respDoc.data() as Map<String, dynamic>;

        // Añadir el ID del documento a la respuesta si es necesario
        respuesta['id'] = respDoc.id;
        respuestas.add(respuesta);
      });

      // Crear un mapa que contenga la pregunta, sus respuestas y el número de pregunta
      Map<String, dynamic> preguntaYRespuestas = {
        'numero': preguntaNumero,
        'pregunta': pregunta,
        'respuestas': respuestas,
      };
      preguntasYRespuestas.add(preguntaYRespuestas);

      preguntaNumero++;
    });

    // Retornar la lista completa de preguntas y respuestas
    return preguntasYRespuestas;
  } catch (e) {
    // Manejo de errores
    print('Error al obtener datos: $e');
    return [];
  }
}
