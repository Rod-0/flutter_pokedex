import 'dart:convert';
import 'dart:io';

import 'package:flutter_pokedex/models/pokemon.dart';
import 'package:http/http.dart' as http;

class PokemonService{
  final baseUrl = 'https://pokeapi.co/api/v2/pokemon/';

    Future<List<Pokemon>?> getAll(int page, int size) async {
    http.Response response = await http.get(Uri.parse("$baseUrl?offset=${page*size}&limit=$size"));

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final List maps = jsonResponse["results"];
      final pokemons = maps.map((e) => Pokemon.fromJson(e)).toList();
      return pokemons;
    }
    return null;
  }
  //getPokemonByID
  Future<PokemonInfo?> getById(String id) async {
    http.Response response = await http.get(Uri.parse("$baseUrl$id"));

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final pokemonInfo = PokemonInfo.fromJson(jsonResponse);
      return pokemonInfo;
    }
    return null;
  }
  
  
}