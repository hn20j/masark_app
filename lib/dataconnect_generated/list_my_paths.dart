part of 'generated.dart';

class ListMyPathsVariablesBuilder {
  final FirebaseDataConnect _dataConnect;
  ListMyPathsVariablesBuilder(
    this._dataConnect,
  );
  Deserializer<ListMyPathsData> dataDeserializer =
      (dynamic json) => ListMyPathsData.fromJson(jsonDecode(json));

  Future<QueryResult<ListMyPathsData, void>> execute(
      {QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListMyPathsData, void> ref() {
    return _dataConnect.query(
        "ListMyPaths", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListMyPathsPaths {
  final String title;
  final String? description;
  ListMyPathsPaths.fromJson(dynamic json)
      : title = nativeFromJson<String>(json['title']),
        description = json['description'] == null
            ? null
            : nativeFromJson<String>(json['description']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListMyPathsPaths otherTyped = other as ListMyPathsPaths;
    return title == otherTyped.title && description == otherTyped.description;
  }

  @override
  int get hashCode => Object.hashAll([title.hashCode, description.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['title'] = nativeToJson<String>(title);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    return json;
  }

  const ListMyPathsPaths({
    required this.title,
    this.description,
  });
}

@immutable
class ListMyPathsData {
  final List<ListMyPathsPaths> paths;
  ListMyPathsData.fromJson(dynamic json)
      : paths = (json['paths'] as List<dynamic>)
            .map((e) => ListMyPathsPaths.fromJson(e))
            .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListMyPathsData otherTyped = other as ListMyPathsData;
    return paths == otherTyped.paths;
  }

  @override
  int get hashCode => paths.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['paths'] = paths.map((e) => e.toJson()).toList();
    return json;
  }

  const ListMyPathsData({
    required this.paths,
  });
}
