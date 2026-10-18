part of 'generated.dart';

class ListMyCollectionsVariablesBuilder {
  final FirebaseDataConnect _dataConnect;
  ListMyCollectionsVariablesBuilder(
    this._dataConnect,
  );
  Deserializer<ListMyCollectionsData> dataDeserializer =
      (dynamic json) => ListMyCollectionsData.fromJson(jsonDecode(json));

  Future<QueryResult<ListMyCollectionsData, void>> execute(
      {QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListMyCollectionsData, void> ref() {
    return _dataConnect.query(
        "ListMyCollections", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListMyCollectionsCollections {
  final String name;
  final String? description;
  ListMyCollectionsCollections.fromJson(dynamic json)
      : name = nativeFromJson<String>(json['name']),
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

    final ListMyCollectionsCollections otherTyped =
        other as ListMyCollectionsCollections;
    return name == otherTyped.name && description == otherTyped.description;
  }

  @override
  int get hashCode => Object.hashAll([name.hashCode, description.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    return json;
  }

  const ListMyCollectionsCollections({
    required this.name,
    this.description,
  });
}

@immutable
class ListMyCollectionsData {
  final List<ListMyCollectionsCollections> collections;
  ListMyCollectionsData.fromJson(dynamic json)
      : collections = (json['collections'] as List<dynamic>)
            .map((e) => ListMyCollectionsCollections.fromJson(e))
            .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListMyCollectionsData otherTyped = other as ListMyCollectionsData;
    return collections == otherTyped.collections;
  }

  @override
  int get hashCode => collections.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['collections'] = collections.map((e) => e.toJson()).toList();
    return json;
  }

  const ListMyCollectionsData({
    required this.collections,
  });
}
