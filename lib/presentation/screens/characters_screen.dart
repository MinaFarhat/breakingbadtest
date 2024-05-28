import '../../business_logic/cubit/characters_cubit.dart';
import '../../constants/mycolor.dart';
import '../../data/models/character.dart';
import '../widgets/character_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class Characterscreen extends StatefulWidget {
  const Characterscreen({Key? key}) : super(key: key);

  @override
  State<Characterscreen> createState() => _CharacterscreenState();
}

class _CharacterscreenState extends State<Characterscreen> {
  late List<Character> allCharacters;
  late List<Character> searchedForCharacters;
  bool _isSearching = false;
  final _searchcontroller = TextEditingController();

  Widget _searcheField() {
    return TextField(
      controller: _searchcontroller,
      cursorColor: Mycolors.myGrey,
      decoration: InputDecoration(
        hintText: "Find a Character...",
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Mycolors.myGrey,
          fontSize: 18,
        ),
      ),
      style: TextStyle(
        color: Mycolors.myGrey,
        fontSize: 18,
      ),
      onChanged: (searchedItem) {
        addSearchedForItemToSearchedList(searchedItem);
      },
    );
  }

  void addSearchedForItemToSearchedList(String searchedItem) {
    searchedForCharacters = allCharacters
        .where((character) =>
            character.name.toLowerCase().startsWith(searchedItem))
        .toList();
    setState(() {});
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearching();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.clear,
            color: Mycolors.myGrey,
          ),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: startSearch,
          icon: Icon(
            Icons.search,
            color: Mycolors.myGrey,
          ),
        ),
      ];
    }
  }

  void startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearching();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearching() {
    setState(() {
      _searchcontroller.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  buildCharactersList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4 / 6,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: _searchcontroller.text.isEmpty
          ? allCharacters.length
          : searchedForCharacters.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (ctx, index) {
        return CharacterItem(
          character: _searchcontroller.text.isEmpty
              ? allCharacters[index]
              : searchedForCharacters[index],
        );
      },
    );
  }

  buildLoadedListWidgets() {
    return SingleChildScrollView(
      child: Container(
        color: Mycolors.myGrey,
        child: Column(
          children: [
            buildCharactersList(),
          ],
        ),
      ),
    );
  }

  buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
      builder: (context, state) {
        if (state is CharactersLoaded) {
          allCharacters = state.characters;
          return buildLoadedListWidgets();
        } else {
          return showLoadingIndicator();
        }
      },
    );
  }

  showLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: Mycolors.myYellow,
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return Text(
      "Characters",
      style: TextStyle(color: Mycolors.myGrey),
    );
  }

  Widget buildNoInternetWidget() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "can't connect....Check The Internet",
              style: TextStyle(
                fontSize: 22,
                color: Mycolors.myGrey,
              ),
            ),
            Image.asset(
              "assets/images/noInternet.png",
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Mycolors.myYellow,
        title: _isSearching ? _searcheField() : _buildAppBarTitle(),
        actions: _buildAppBarActions(),
        leading: _isSearching
            ? BackButton(
                color: Mycolors.myGrey,
              )
            : Container(),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          if (connected) {
            return buildBlocWidget();
          } else {
            return buildNoInternetWidget();
          }
        },
        child: showLoadingIndicator(),
      ),
    );
  }
}
