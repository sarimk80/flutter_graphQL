import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink =
        HttpLink(uri: 'https://rickandmortyapi.com/graphql/');

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
          cache: NormalizedInMemoryCache(
              dataIdFromObject: typenameDataIdFromObject),
          link: httpLink as Link),
    );
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        home: MyHomePage(
          title: "GraphQL",
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String query = """
                query {
  characters(page:10) {
    results {
      name
      species
      gender
      image
      type
    }
  }
}""";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Query(
          options: QueryOptions(document: query),
          builder: (
            QueryResult result, {
            VoidCallback refetch,
          }) {
            if (result.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (result.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.all(5),
                  onTap: ()=>{},
                  title:
                      Text(result.data['characters']['results'][index]['name']),
                  leading: Image.network(result.data['characters']['results'][index]['image']),
                  subtitle: Text(result.data['characters']['results'][index]['species']),
                );
              },
              itemCount: result.data['characters']['results'].length,
            );
          },
        ));
  }
}
