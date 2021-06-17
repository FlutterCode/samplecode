import 'dart:convert';

import 'package:http/http.dart';
import 'package:milanproject/entity/audios.dart';
import 'package:milanproject/entity/content.dart';
import 'package:milanproject/entity/data.dart';
import 'package:milanproject/entity/questionsmodel.dart';
import 'package:milanproject/entity/videos.dart';
import 'package:milanproject/provider/data_provider.dart';

class ProjectRepository {
  DataProvider _helper;

  ProjectRepository({DataProvider provider}) {
    _helper = provider ?? DataProvider();
  }

  Future<List<Photos>> getPhotos() async {
    try {
      Response response = await get(
        "http://pushtiras.co.in/api/galleries",
      );

      print(response.body);

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      final parsed = json.decode(response.body);

      return (parsed["data"] as List)
          .map<Photos>((json) => new Photos.fromJson(json))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  Future<List<Content>> getContent(String categoryId) async {
    try {
      Response response = await get(
        "http://pushtiras.co.in/api/granths?category_id=" + categoryId,
      );

      print(response.body);

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      final parsed = json.decode(response.body);

      return (parsed["data"] as List)
          .map<Content>((json) => new Content.fromJson(json))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  Future<List<Videos>> getVideos(String id) async {
    try {
      Response response = await get(
        "http://pushtiras.co.in/api/videos?category_id=" + id,
      );

      print(response.body);

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      final parsed = json.decode(response.body);

      return (parsed["data"] as List)
          .map<Videos>((json) => new Videos.fromJson(json))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  Future<List<Audios>> getAudios() async {
    try {
      Response response = await get(
        "http://pushtiras.co.in/api/audios",
      );

      print(response.body);

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      final parsed = json.decode(response.body);

      return (parsed["data"] as List)
          .map<Audios>((json) => new Audios.fromJson(json))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  Future<List<QuestionsModel>> getQuestionData() async {
    try {
      Response response = await get(
        "http://pushtiras.co.in/api/quizzes",
      );

      print(response.body);

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      final parsed = json.decode(response.body);

      return (parsed["data"] as List)
          .map<QuestionsModel>((json) => QuestionsModel.fromJson(json))
          .toList();
    } catch (e) {
      throw e;
    }
  }
}
