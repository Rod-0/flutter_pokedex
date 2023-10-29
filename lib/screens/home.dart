import 'package:flutter/material.dart';
import 'package:flutter_pokedex/screens/favorite_pokemons.dart';
import 'package:flutter_pokedex/screens/pokemon_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedTab = 0;

  final List<Widget> _children = [
    const PokemonList(),
    const FavoritePokemons()
  ];

  _changeTab(int index){
    setState(() {
      _selectedTab = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokedex"),
      ),
      body: _children[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (index) => _changeTab(index),
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Pokemons"),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          ]),
    );
  }
}
