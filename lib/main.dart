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
  // Método build que define la interfaz de usuario de la aplicación
  Widget build(BuildContext context) {
    // Envolvemos la aplicación con ChangeNotifierProvider para manejar el estado
    return ChangeNotifierProvider(
      // Creamos una instancia de MovieViewModel para gestionar el estado de las películas
      create: (context) => MovieViewModel(),
      child: MaterialApp(
        title: 'Movie App',  // Título de la aplicación
        debugShowCheckedModeBanner: false,  // Oculta la etiqueta de debug
        // Configuración del tema de la aplicación
        theme: ThemeData(
          primarySwatch: Colors.blue,  // Color primario de la aplicación
          useMaterial3: true,  // Habilita Material Design 3
          scaffoldBackgroundColor: const Color(0xFF1A1A1A),  // Color de fondo principal
          // Configuración del esquema de colores oscuro
          colorScheme: ColorScheme.dark(
            primary: Colors.blue.shade400,  // Color primario
            secondary: Colors.blue.shade200,  // Color secundario
            surface: const Color(0xFF2A2A2A),  // Color de superficie
            background: const Color(0xFF1A1A1A),  // Color de fondo
          ),
        ),
        // Define la pantalla inicial de la aplicación
        home: const MovieListScreen(),
      ),
    );
  }
}
