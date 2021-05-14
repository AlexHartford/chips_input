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
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Yolo(),
      ),
    );
  }
}

class Yolo extends StatefulWidget {
  Yolo({Key? key}) : super(key: key);

  @override
  _YoloState createState() => _YoloState();
}

class _YoloState extends State<Yolo> {
  final mockResults = <Tag>[
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

  List<Tag> activeTags = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Stack(
        children: [
          Positioned.directional(
            top: -2,
            // height: 96,
            end: 0,
            start: 0,
            textDirection: TextDirection.ltr,
            child: Container(
              child: ChipsInput<Tag>(
                decoration: InputDecoration(
                  // border: InputBorder.none,
                  prefix: SizedBox(width: 96),
                  contentPadding: EdgeInsets.only(bottom: activeTags.length > 3 ? 12 : 48, top: 16),
                ),
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
                  setState(() {
                    activeTags = data;
                  });
                  print('activeTags: $activeTags');
                },
                chipBuilder: (context, state, Tag tag) {
                  return InputChip(
                    key: ObjectKey(tag),
                    label: Text(
                      tag.name,
                      style: TextStyle(fontSize: 16),
                    ),
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
                        padding: EdgeInsets.zero,
                        itemCount: tags.length,
                        separatorBuilder: (_, __) => Divider(height: 1, thickness: 1),
                        itemBuilder: (BuildContext context, int index) {
                          final Tag tag = tags.elementAt(index);
                          return InkWell(
                            onTap: () {
                              onSelected(tag);
                            },
                            child: ListTile(
                              key: ObjectKey(tag),
                              title: Text(tag.name),
                              // tileColor: Colors.red,
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
          ),
          Align(
            alignment: Alignment.topLeft,
            child: MealSavePagePhotoArea(),
          ),
        ],
      ),
    );
  }
}

class MealSavePagePhotoArea extends StatelessWidget {
  const MealSavePagePhotoArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: 64,
      margin: const EdgeInsets.fromLTRB(16, 16, 0, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black12,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Icon(
            Icons.camera,
            size: 32,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
