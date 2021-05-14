import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chips_input/chips_input.dart';

void main() => runApp(MyApp());

class Tag {
  final String name;
  final int total;

  const Tag(this.name, this.total);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return name;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const mockResults = <Tag>[
      Tag('passable', 10),
      Tag('perfect', 15),
      Tag('good', 12),
      Tag('bad', 105),
      Tag('great', 1023),
      Tag('okay', 9213),
      Tag('cool', 1),
      Tag('terrible', 0),
      Tag('awful', 1238),
    ];

    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: ChipsInput(
          initialValue: [mockResults[1]],
          findSuggestions: (String query) {
            if (query.isNotEmpty) {
              var lowercaseQuery = query.toLowerCase();
              final results = mockResults.where((profile) {
                return profile.name.toLowerCase().contains(query.toLowerCase());
              }).toList(growable: false)
                ..sort((a, b) => a.name
                    .toLowerCase()
                    .indexOf(lowercaseQuery)
                    .compareTo(b.name.toLowerCase().indexOf(lowercaseQuery)));
              return results;
            }
            return mockResults;
          },
          onChanged: (data) {
            print(data);
          },
          chipBuilder: (context, state, Tag tag) {
            return InputChip(
              key: ObjectKey(tag),
              label: Text(tag.name),
              onDeleted: () => state.deleteChip(tag),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          },
          // suggestionBuilder: (context, Tag tag) {
          //   return ListTile(
          //     key: ObjectKey(tag),
          //     title: Text(tag.name),
          //     // tileColor: Colors.red,
          //     trailing: Text(tag.total.toString()),
          //   );
          // },
          optionsViewBuilder:
              (context, AutocompleteOnSelected<Tag> onSelected, Iterable<Tag> tags) {
            return Material(
              child: Container(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: tags.length,
                  separatorBuilder: (_, __) => Divider(height: 1),
                  itemBuilder: (BuildContext context, int index) {
                    final Tag tag = tags.elementAt(index);
                    return InkWell(
                      onTap: () {
                        onSelected(tag);
                      },
                      child: ListTile(
                        key: ObjectKey(tag),
                        title: Text(tag.name),
                        tileColor: Colors.red,
                        trailing: Text(tag.total.toString()),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
