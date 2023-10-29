import 'package:flutter/material.dart';
import 'package:flutter_pokedex/models/pokemon.dart';
import 'package:flutter_pokedex/repository/pokemon_repository.dart';
import 'package:flutter_pokedex/screens/pokemon_detail.dart';
import 'package:flutter_pokedex/utils/functions.dart';

class FavoritePokemons extends StatefulWidget {
   const FavoritePokemons({super.key});

  @override
  State<FavoritePokemons> createState() => _FavoritePokemons();
}

class _FavoritePokemons extends State<FavoritePokemons> {
  PokemonRepository? _pokemonRepository;
  List<Pokemon>? _pokemons;

  initialize() async {
    _pokemons = await _pokemonRepository?.getAll() ?? [];
    setState(() {
      _pokemons = _pokemons;
    });
  }

  @override
  void initState() {
    _pokemonRepository = PokemonRepository();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
     
      body: ListView.builder(
          itemCount: _pokemons?.length ?? 0,
          itemBuilder: ((context, index) {
            return GestureDetector(
              child: Card(
                child: ListTile(
                  leading: Hero(tag:_pokemons?[index].id ?? "1"  ,child: Image(image: getImage(_pokemons?[index].id ?? "1"))),
                  title: Text(_pokemons?[index].name ?? ""),
                ),
              ),
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => PokemonDetail(id:_pokemons?[index].id ?? "1")));
              },
            );
          })),
    );
  }
}





