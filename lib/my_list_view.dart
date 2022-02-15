import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:listview/utils.dart';

class MyListView extends StatefulWidget {
  const MyListView({Key? key}) : super(key: key);

  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildSuggestions(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text(
        "VBT ListView Homework",
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.list),
          onPressed: _pushSaved,
          tooltip: 'Saved Suggestions',
        ),
      ],
    );
  }

  ListView _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, i) {
        if (i.isOdd) {
          return const Divider();
        }
        final index = i ~/ 2;
        if (index >= Utils.suggestions.length) {
          Utils.suggestions.addAll(generateWordPairs().take(10));
        }
        return Dismissible(
          key: Key(
            Utils.suggestions[index].toString(),
          ),
          onDismissed: (direction) {
            setState(() {
              Utils.suggestions.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${Utils.suggestions[index]} dismissed'),
              ),
            );
          },
          background: _removeAction(),
          child: _buildRow(Utils.suggestions[index]),
        );
      },
    );
  }

  Widget _removeAction() {
    return Container(
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = Utils.saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: Utils.biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
      ),
      onTap: () {
        setState(
          () {
            if (alreadySaved) {
              Utils.saved.remove(pair);
            } else {
              Utils.saved.add(pair);
            }
          },
        );
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = Utils.saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: Utils.biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Favorited Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}
