import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/services.dart';
import 'controllers/view_model.dart';
import 'widgets/movie_card.dart';
import 'widgets/review_card.dart';

void main() {
  //Pantalla completa
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieViewModel(),
      child: MaterialApp(
        title: 'Movie App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF1A1A1A),
          colorScheme: ColorScheme.dark(
            primary: Colors.blue.shade400,
            secondary: Colors.blue.shade200,
            surface: const Color(0xFF2A2A2A),
            background: const Color(0xFF1A1A1A),
          ),
        ),
        home: const MovieListScreen(),
      ),
    );
  }
}

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MovieViewModel>().loadContent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
