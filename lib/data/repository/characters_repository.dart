import '../api/characters_api.dart';
import '../models/quote.dart';

import '../models/character.dart';

class CharactersRepository {
  final CharactersApi charactersApi;

  CharactersRepository(this.charactersApi);

  Future<List<Character>> getAllCharacters() async {
    final characters = await charactersApi.getAllCharacters();

    return characters
        .map((character) => Character.fromJson(character))
        .toList();
  }

  Future<List<Quote>> getQuotes(String charName) async {
    final quotes = await charactersApi.getQuotes(charName);

    return quotes.map((quote) => Quote.fromJson(quote)).toList();
  }
}
