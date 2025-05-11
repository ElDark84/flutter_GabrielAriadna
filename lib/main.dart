// Importación de los paquetes necesarios de Flutter
import 'package:flutter/material.dart';  // Paquete principal de Flutter para widgets y material design
import 'package:provider/provider.dart';  // Paquete para manejo de estado con Provider
import 'package:flutter/services.dart';  // Paquete para servicios del sistema
import 'controllers/view_model.dart';  // Importación del controlador de vista
import 'views/movie_list_screen.dart';  // Importación de la pantalla principal de lista de películas

// Función principal que inicia la aplicación
void main() {
  // Asegura que Flutter esté inicializado antes de ejecutar la app
  WidgetsFlutterBinding.ensureInitialized();
  // Configura la UI del sistema para modo inmersivo (oculta la barra de estado y navegación)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // Inicia la aplicación con el widget raíz MyApp
  runApp(const MyApp());
}

// Widget raíz de la aplicación que define la estructura básica
class MyApp extends StatelessWidget {
  // Constructor con super.key para pasar la clave al widget padre
  const MyApp({super.key});

  @override
  // Método que construye la interfaz de usuario de la aplicación
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Proporciona el ViewModel a toda la aplicación
      create: (_) => MovieViewModel(),
      child: MaterialApp(
        // Configuración del tema oscuro para la aplicación
        theme: ThemeData.dark().copyWith(
          // Personalización de los colores del tema
          colorScheme: ColorScheme.dark(
            // Color de fondo principal
            background: const Color(0xFF1A1A1A),
            // Color de superficie para tarjetas y contenedores
            surface: const Color(0xFF2D2D2D),
            // Color primario para elementos destacados
            primary: Colors.blue.shade400,
            // Color secundario para elementos de acento
            secondary: Colors.blue.shade200,
          ),
          // Estilo de texto predeterminado
          textTheme: const TextTheme(
            // Estilo para títulos grandes
            headlineLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            // Estilo para títulos medianos
            headlineMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            // Estilo para texto del cuerpo
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        // Pantalla inicial de la aplicación
        home: const MovieListScreen(),
        // Desactiva el banner de debug
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
