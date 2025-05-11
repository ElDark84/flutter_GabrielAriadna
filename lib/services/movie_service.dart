import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

// Servicio que maneja las peticiones a la API de TMDB
class MovieService {
  // URL base de la API de TMDB
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  // Clave de API para autenticación
  static const String _apiKey = 'fa4912f208d8c9000b8d8d009c28e2b5';
  // Token de autenticación para la API
  static const String _token = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYTQ5MTJmMjA4ZDhjOTAwMGI4ZDhkMDA5YzI4ZTJiNSIsIm5iZiI6MTc0MzY5NTA2NS40ODcsInN1YiI6IjY3ZWVhY2Q5MTVmNmJhODZmMWUxYTcwMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.yACTJlfSWaWUvtN7Iak36-gIqxlsh1JKzoFBa0hxNDU';

  // Método para obtener películas populares
  Future<Map<String, dynamic>> getPopularMovies(int page) async {
    try {
      // Realiza la petición GET a la API
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/popular?page=$page'),  // Endpoint para películas populares
        headers: {
          'Authorization': 'Bearer $_token',  // Token de autenticación
          'Content-Type': 'application/json',  // Tipo de contenido
        },
      );

      if (response.statusCode == 200) {  // Si la petición fue exitosa
        final data = json.decode(response.body);  // Decodifica la respuesta JSON
        final List<dynamic> results = data['results'];  // Obtiene la lista de resultados
        return {
          'movies': results.map((json) => Movie.fromJson(json)).toList(),  // Convierte cada resultado a un objeto Movie
          'totalPages': data['total_pages'],  // Total de páginas disponibles
          'currentPage': data['page'],  // Página actual
        };
      } else {
        throw Exception('Error al cargar películas: ${response.statusCode}');  // Lanza error si la petición falló
      }
    } catch (e) {
      throw Exception('Error de conexión al servidor: $e');  // Lanza error si hay problemas de conexión
    }
  }

  // Método para obtener series de TV populares
  Future<Map<String, dynamic>> getPopularTVShows(int page) async {
    try {
      // Realiza la petición GET a la API
      final response = await http.get(
        Uri.parse('$_baseUrl/tv/popular?page=$page'),  // Endpoint para series populares
        headers: {
          'Authorization': 'Bearer $_token',  // Token de autenticación
          'Content-Type': 'application/json',  // Tipo de contenido
        },
      );

      if (response.statusCode == 200) {  // Si la petición fue exitosa
        final data = json.decode(response.body);  // Decodifica la respuesta JSON
        final List<dynamic> results = data['results'];  // Obtiene la lista de resultados
        return {
          'movies': results.map((json) => Movie.fromJson(json)).toList(),  // Convierte cada resultado a un objeto Movie
          'totalPages': data['total_pages'],  // Total de páginas disponibles
          'currentPage': data['page'],  // Página actual
        };
      } else {
        throw Exception('Error al cargar series: ${response.statusCode}');  // Lanza error si la petición falló
      }
    } catch (e) {
      throw Exception('Error de conexión al servidor: $e');  // Lanza error si hay problemas de conexión
    }
  }

  // Método para buscar películas
  Future<Map<String, dynamic>> searchMovies(String query, int page) async {
    try {
      // Realiza la petición GET a la API
      final response = await http.get(
        Uri.parse('$_baseUrl/search/movie?query=$query&page=$page'),  // Endpoint para búsqueda de películas
        headers: {
          'Authorization': 'Bearer $_token',  // Token de autenticación
          'Content-Type': 'application/json',  // Tipo de contenido
        },
      );

      if (response.statusCode == 200) {  // Si la petición fue exitosa
        final data = json.decode(response.body);  // Decodifica la respuesta JSON
        final List<dynamic> results = data['results'];  // Obtiene la lista de resultados
        return {
          'movies': results.map((json) => Movie.fromJson(json)).toList(),  // Convierte cada resultado a un objeto Movie
          'totalPages': data['total_pages'],  // Total de páginas disponibles
          'currentPage': data['page'],  // Página actual
        };
      } else {
        throw Exception('Error al buscar películas: ${response.statusCode}');  // Lanza error si la petición falló
      }
    } catch (e) {
      throw Exception('Error de conexión al servidor: $e');  // Lanza error si hay problemas de conexión
    }
  }

  // Método para buscar series de TV
  Future<Map<String, dynamic>> searchTVShows(String query, int page) async {
    try {
      // Realiza la petición GET a la API
      final response = await http.get(
        Uri.parse('$_baseUrl/search/tv?query=$query&page=$page'),  // Endpoint para búsqueda de series
        headers: {
          'Authorization': 'Bearer $_token',  // Token de autenticación
          'Content-Type': 'application/json',  // Tipo de contenido
        },
      );

      if (response.statusCode == 200) {  // Si la petición fue exitosa
        final data = json.decode(response.body);  // Decodifica la respuesta JSON
        final List<dynamic> results = data['results'];  // Obtiene la lista de resultados
        return {
          'movies': results.map((json) => Movie.fromJson(json)).toList(),  // Convierte cada resultado a un objeto Movie
          'totalPages': data['total_pages'],  // Total de páginas disponibles
          'currentPage': data['page'],  // Página actual
        };
      } else {
        throw Exception('Error al buscar series: ${response.statusCode}');  // Lanza error si la petición falló
      }
    } catch (e) {
      throw Exception('Error de conexión al servidor: $e');  // Lanza error si hay problemas de conexión
    }
  }
}