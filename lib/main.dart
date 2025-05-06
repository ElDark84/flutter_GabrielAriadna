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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.background,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey.shade400),
                        onPressed: () {
                          _searchController.clear();
                          context.read<MovieViewModel>().searchContent('');
                        },
                      ),
                    ),
                    onChanged: (value) {
                      context.read<MovieViewModel>().searchContent(value);
                    },
                  ),
                ),
              ),
              Consumer<MovieViewModel>(
                builder: (context, movieViewModel, child) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildCategoryChip(
                          context,
                          'Películas',
                          ContentType.movies,
                          movieViewModel.selectedType,
                        ),
                        const SizedBox(width: 8),
                        _buildCategoryChip(
                          context,
                          'Series',
                          ContentType.tvShows,
                          movieViewModel.selectedType,
                        ),
                        const SizedBox(width: 8),
                        _buildCategoryChip(
                          context,
                          'Reviews',
                          ContentType.reviews,
                          movieViewModel.selectedType,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Consumer<MovieViewModel>(
                  builder: (context, movieViewModel, child) {
                    if (movieViewModel.isLoading &&
                        ((movieViewModel.selectedType == ContentType.reviews && movieViewModel.reviews.isEmpty) ||
                            (movieViewModel.selectedType != ContentType.reviews && movieViewModel.movies.isEmpty))) {
                      return const Center(
                        child: SpinKitDoubleBounce(
                          color: Colors.blue,
                          size: 50.0,
                        ),
                      );
                    }
