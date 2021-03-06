import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:quotes_generator/components/back_nav_btn.dart';
import 'package:quotes_generator/theme/styles.dart';
import 'package:quotes_generator/blocs/favorite/quotes.dart';
import 'package:quotes_generator/blocs/favorite/state.dart';
import 'package:quotes_generator/components/bottom_bar.dart';
import 'package:quotes_generator/components/quote_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool isEmpty = true;

  @override
  void initState() {
    context.read<FavoriteQuotesCubit>().getFavoriteQuotes();
    super.initState();
  }

  Widget _body() {
    return BlocConsumer<FavoriteQuotesCubit, FavoriteQuotesState>(
        listener: (BuildContext context, FavoriteQuotesState state) {
      if (state is FavoriteQuotesLoaded) {
        if (state.quotes != null && state.quotes.isNotEmpty) {
          setState(() {
            isEmpty = false;
          });
        }
      }
    }, builder: (BuildContext context, FavoriteQuotesState state) {
      if (state is FavoriteQuotesInitial) {
        return Container();
      } else if (state is FavoriteQuotesLoading) {
        return const Center(
          child: NeumorphicProgressIndeterminate(
            duration: Duration(seconds: 10),
          ),
        );
      } else if (state is FavoriteQuotesLoaded) {
        return Center(
          child: (state.quotes == null || state.quotes.isEmpty)
              ? Text('You have no favorite values for now',
                  style: infoTextStyle(context))
              : SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ListView.builder(
                      padding: listPadding(context),
                      itemCount: state.quotes.length,
                      itemBuilder: (BuildContext context, int position) {
                        return QuoteCard(value: state.quotes[position]);
                      }),
                ),
        );
      } else {
        return Center(child: Text((state as FavoriteQuotesError).message));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        leading: BackNavBtn(),
        centerTitle: true,
        title: const Text('Favorite Values'),
      ),
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: _body(),
      bottomNavigationBar: isEmpty ? BottomBar() : null,
    );
  }
}
