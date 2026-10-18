part of 'generated.dart';

class ListPathCommentsVariablesBuilder {
  String pathId;

  final FirebaseDataConnect _dataConnect;
  ListPathCommentsVariablesBuilder(
    this._dataConnect, {
    required this.pathId,
  });
  Deserializer<ListPathCommentsData> dataDeserializer =
      (dynamic json) => ListPathCommentsData.fromJson(jsonDecode(json));
  Serializer<ListPathCommentsVariables> varsSerializer =
      (ListPathCommentsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListPathCommentsData, ListPathCommentsVariables>> execute(
      {QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListPathCommentsData, ListPathCommentsVariables> ref() {
    ListPathCommentsVariables vars = ListPathCommentsVariables(
      pathId: pathId,
    );
    return _dataConnect.query(
        "ListPathComments", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListPathCommentsComments {
  final String text;
  final ListPathCommentsCommentsAuthor author;
  final Timestamp? createdAt;
  ListPathCommentsComments.fromJson(dynamic json)
      : text = nativeFromJson<String>(json['text']),
        author = ListPathCommentsCommentsAuthor.fromJson(json['author']),
        createdAt = json['createdAt'] == null
            ? null
            : Timestamp.fromJson(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListPathCommentsComments otherTyped =
        other as ListPathCommentsComments;
    return text == otherTyped.text &&
        author == otherTyped.author &&
        createdAt == otherTyped.createdAt;
  }

  @override
  int get hashCode =>
      Object.hashAll([text.hashCode, author.hashCode, createdAt.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['text'] = nativeToJson<String>(text);
    json['author'] = author.toJson();
    if (createdAt != null) {
      json['createdAt'] = createdAt!.toJson();
    }
    return json;
  }

  const ListPathCommentsComments({
    required this.text,
    required this.author,
    this.createdAt,
  });
}

@immutable
class ListPathCommentsCommentsAuthor {
  final String username;
  ListPathCommentsCommentsAuthor.fromJson(dynamic json)
      : username = nativeFromJson<String>(json['username']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListPathCommentsCommentsAuthor otherTyped =
        other as ListPathCommentsCommentsAuthor;
    return username == otherTyped.username;
  }

  @override
  int get hashCode => username.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['username'] = nativeToJson<String>(username);
    return json;
  }

  const ListPathCommentsCommentsAuthor({
    required this.username,
  });
}

@immutable
class ListPathCommentsData {
  final List<ListPathCommentsComments> comments;
  ListPathCommentsData.fromJson(dynamic json)
      : comments = (json['comments'] as List<dynamic>)
            .map((e) => ListPathCommentsComments.fromJson(e))
            .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListPathCommentsData otherTyped = other as ListPathCommentsData;
    return comments == otherTyped.comments;
  }

  @override
  int get hashCode => comments.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['comments'] = comments.map((e) => e.toJson()).toList();
    return json;
  }

  const ListPathCommentsData({
    required this.comments,
  });
}

@immutable
class ListPathCommentsVariables {
  final String pathId;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListPathCommentsVariables.fromJson(Map<String, dynamic> json)
      : pathId = nativeFromJson<String>(json['pathId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListPathCommentsVariables otherTyped =
        other as ListPathCommentsVariables;
    return pathId == otherTyped.pathId;
  }

  @override
  int get hashCode => pathId.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['pathId'] = nativeToJson<String>(pathId);
    return json;
  }

  const ListPathCommentsVariables({
    required this.pathId,
  });
}
