import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Model {
  int id;

  Model(this.id);
}

class HomeListModel {
  final List<Model> _items = [
    Model(1),
    Model(2),
    Model(3),
    Model(4),
  ];

  StreamController<List<Model>> _controller;

  Stream<List<Model>> _stream;

  Stream<List<Model>> get stream => _stream;

  HomeListModel() {
    _controller = StreamController();
    _stream = _controller.stream;
    _controller.add(_items);
  }

  void moveToTop(Model model) {
    _items.remove(model);
    _items.insert(0, model);
    _controller.add(_items.map((e) => Model(e.id)).toList());
    print("item moved");
  }

  void dispose() {
    print('dispose');
    _controller.close();
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Model>>(
        initialData: [],
        stream: Provider.of<HomeListModel>(context).stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          final items = snapshot.data;
          return ListView.separated(
            itemBuilder: (context, idx) => HomeListTile(model: items[idx], key: ValueKey(items[idx].id)),
            separatorBuilder: (context, idx) => Divider(color: Theme.of(context).accentColor),
            itemCount: items.length,
          );
        },
      ),
    );
  }
}

class HomeListTile extends StatelessWidget {
  final Model model;

  const HomeListTile({
    Key key,
    @required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      closedColor: Theme.of(context).scaffoldBackgroundColor,
      closedBuilder: (BuildContext context, void Function() action) {
        return ListTile(
          title: Text('item ${model.id}'),
          onTap: action,
        );
      },
      openBuilder: (BuildContext context, void Function() action) => HomeOpenWidget(
        model: model,
        action: action,
      ),
    );
  }
}

class HomeOpenWidget extends StatelessWidget {
  final Model model;
  final void Function() action;

  const HomeOpenWidget({
    Key key,
    this.model,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('item ${model.id}'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: action,
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('item ${model.id}'),
            RaisedButton(
              onPressed: () {
                Provider.of<HomeListModel>(context, listen: false).moveToTop(model);
              },
              child: Text('Move me to top!'),
            )
          ],
        ),
      ),
    );
  }
}
