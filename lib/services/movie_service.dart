import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = 'fa4912f208d8c9000b8d8d009c28e2b5';
  static const String _token = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYTQ5MTJmMjA4ZDhjOTAwMGI4ZDhkMDA5YzI4ZTJiNSIsIm5iZiI6MTc0MzY5NTA2NS40ODcsInN1YiI6IjY3ZWVhY2Q5MTVmNmJhODZmMWUxYTcwMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.yACTJlfSWaWUvtN7Iak36-gIqxlsh1JKzoFBa0hxNDU';

  Future<Map<String, dynamic>> getPopularMovies(int page) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/movie/popular?page=$page'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return {
          'movies': results.map((json) => Movie.fromJson(json)).toList(),
          'totalPages': data['total_pages'],
          'currentPage': data['page'],
        };
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to the server: $e');
    }
  }

  Future<Map<String, dynamic>> getPopularTVShows(int page) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/tv/popular?page=$page'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return {
          'movies': results.map((json) => Movie.fromJson(json)).toList(),
          'totalPages': data['total_pages'],
          'currentPage': data['page'],
        };
      } else {
        throw Exception('Failed to load TV shows: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to the server: $e');
    }
  }

  Future<Map<String, dynamic>> searchMovies(String query, int page) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search/movie?query=$query&page=$page'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return {
          'movies': results.map((json) => Movie.fromJson(json)).toList(),
          'totalPages': data['total_pages'],
          'currentPage': data['page'],
        };
      } else {
        throw Exception('Failed to search movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to the server: $e');
    }
  }

  Future<Map<String, dynamic>> searchTVShows(String query, int page) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search/tv?query=$query&page=$page'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return {
          'movies': results.map((json) => Movie.fromJson(json)).toList(),
          'totalPages': data['total_pages'],
          'currentPage': data['page'],
        };
      } else {
        throw Exception('Failed to search TV shows: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to the server: $e');
    }
  }
}