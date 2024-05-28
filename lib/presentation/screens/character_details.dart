import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import '../../business_logic/cubit/characters_cubit.dart';
import '../../constants/mycolor.dart';
import '../../data/models/character.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailsScreen({super.key, required this.character});

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: Mycolors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          character.nickName,
          style: TextStyle(color: Mycolors.myWhite),
          textAlign: TextAlign.center,
        ),
        background: Hero(
          tag: character.charid,
          child: Image.network(
            character.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget characterInfo(String title, String value) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              color: Mycolors.myWhite,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(color: Mycolors.myWhite, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget buildDivider(double endIndent) {
    return Divider(
      color: Mycolors.myYellow,
      height: 30,
      endIndent: endIndent,
      thickness: 2,
    );
  }

  Widget checkIfQuotesAreLoaded(CharactersState state) {
    if (state is QuotesLoaded) {
      return desplayRandomQuotesOrEmptySpace(state);
    } else {
      return const CircularProgressIndicator();
    }
  }

  Widget desplayRandomQuotesOrEmptySpace(state) {
    var quotes = state.quotes;
    if (quotes.length != 0) {
      int randomQuotesIndex = Random().nextInt(quotes.length - 1);
      return DefaultTextStyle(
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: Mycolors.myWhite,
          shadows: [
            Shadow(
              blurRadius: 7,
              color: Mycolors.myYellow,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: AnimatedTextKit(
          repeatForever: true,
          animatedTexts: [
            FlickerAnimatedText(quotes[randomQuotesIndex].quote),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

 
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getQuotes(character.name);
    return Scaffold(
      backgroundColor: Mycolors.myGrey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      characterInfo("Job : ", character.jobs.join(' / ')),
                      buildDivider(335),
                      characterInfo(
                          "Appeared in : ", character.categoryForTwoSeries),
                      buildDivider(272),
                      characterInfo("Seasons : ",
                          character.appearanceOfSeasones.join(' / ')),
                      buildDivider(300),
                      characterInfo("Status : ", character.statusIfDeadOrAlive),
                      buildDivider(315),
                      character.betterCallSaulAppearance.isEmpty
                          ? Container()
                          : characterInfo("Better Call Saul Seasons : ",
                              character.betterCallSaulAppearance.join(' / ')),
                      character.betterCallSaulAppearance.isEmpty
                          ? Container()
                          : buildDivider(170),
                      characterInfo("Actor/Actress : ", character.actorName),
                      buildDivider(253),
                      const SizedBox(height: 10),
                      BlocBuilder<CharactersCubit, CharactersState>(
                        builder: (context, state) {
                          return checkIfQuotesAreLoaded(state);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 500),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
