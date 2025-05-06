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
