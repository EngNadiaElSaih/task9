import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostProvider extends ChangeNotifier {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';
  List posts = [];
  Map<String, dynamic> post = {};
  List comments = [];

  Future<void> fetchPosts() async {
    final response = await http.get(Uri.parse('$baseUrl/posts'));
    if (response.statusCode == 200) {
      posts = json.decode(response.body);
      notifyListeners();
    } else {
      print('Failed to load posts');
    }
  }

  Future<void> fetchPost(int postId) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/$postId'));
    if (response.statusCode == 200) {
      post = json.decode(response.body);
      notifyListeners();
    } else {
      print('Failed to load post');
    }
  }

  Future<void> fetchCommentsForPost(int postId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/posts/$postId/comments'));
    if (response.statusCode == 200) {
      comments = json.decode(response.body);
      notifyListeners();
    } else {
      print('Failed to load comments for post');
    }
  }

  Future<void> fetchCommentsWithQuery(int postId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/comments?postId=$postId'));
    if (response.statusCode == 200) {
      comments = json.decode(response.body);
      notifyListeners();
    } else {
      print('Failed to load comments with query');
    }
  }
}
