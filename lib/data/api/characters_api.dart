import '../../constants/strings.dart';
import 'package:dio/dio.dart';

class CharactersApi {
  late Dio dio;

  CharactersApi() {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: baseurl,
      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000, //20 seconds
      receiveTimeout: 20 * 1000, //20 seconds
    );

    dio = Dio(baseOptions);
  }

  Future<List<dynamic>> getAllCharacters() async {
    try {
      Response response = await dio.get("characters");
      // ignore: avoid_print
      print(response.data.toString());
      return response.data;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getQuotes(String charName) async {
    try {
      Response response =
          await dio.get("quote", queryParameters: {"author": charName});
      // ignore: avoid_print
      print(response.data.toString());
      return response.data;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return [];
    }
  }
}
