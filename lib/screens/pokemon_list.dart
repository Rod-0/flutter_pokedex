import 'package:flutter/material.dart';
import 'package:flutter_pokedex/repository/pokemon_repository.dart';
import 'package:flutter_pokedex/utils/functions.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_pokedex/models/pokemon.dart';
import 'package:flutter_pokedex/screens/pokemon_detail.dart';
import 'package:flutter_pokedex/services/pokemon_service.dart';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  PokemonService? _pokemonService;
  final _pageSize = 20;

  final PagingController<int, Pokemon> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pokemonService = PokemonService();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future _fetchPage(int pageKey) async {
    try {
      final pokemons = await _pokemonService?.getAll(pageKey, _pageSize) ?? [];
      final isLastPage = pokemons.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(pokemons);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(pokemons, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Pokemon>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Pokemon>(
        itemBuilder: (context, item, index) => PokemonItem(
          pokemon: item,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class PokemonItem extends StatefulWidget {
  const PokemonItem({super.key, required this.pokemon});
  final Pokemon? pokemon;

  @override
  State<PokemonItem> createState() => _PokemonItemState();
}

class _PokemonItemState extends State<PokemonItem> {
  bool isFavorite = false;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    isFavorite = await PokemonRepository().isFavorite(widget.pokemon!);
    if (mounted) {
      setState(() {
        isFavorite = isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = getImage(widget.pokemon?.id ?? "");
    final icon =
        Icon(Icons.favorite, color: isFavorite ? Colors.red : Colors.grey);
    final pokemon = widget.pokemon;
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PokemonDetail(id: pokemon?.id ?? "1"))),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: Hero(
            tag: widget.pokemon?.id??'',
            child: Image(
              image: image,
            ), 
          ),
          title: Text(pokemon?.name ?? ""),
          trailing: IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              isFavorite
                  ? PokemonRepository().insert(pokemon!)
                  : PokemonRepository().delete(pokemon!);
            },
            icon: icon,
          ),
        ),
      ),
    );
  }
}
