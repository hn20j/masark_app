part of 'generated.dart';

class GetPathVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetPathVariablesBuilder(
    this._dataConnect, {
    required this.id,
  });
  Deserializer<GetPathData> dataDeserializer =
      (dynamic json) => GetPathData.fromJson(jsonDecode(json));
  Serializer<GetPathVariables> varsSerializer =
      (GetPathVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetPathData, GetPathVariables>> execute(
      {QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetPathData, GetPathVariables> ref() {
    GetPathVariables vars = GetPathVariables(
      id: id,
    );
    return _dataConnect.query(
        "GetPath", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetPathPath {
  final String title;
  final String? description;
  final String startCoordinates;
  final String endCoordinates;
  GetPathPath.fromJson(dynamic json)
      : title = nativeFromJson<String>(json['title']),
        description = json['description'] == null
            ? null
            : nativeFromJson<String>(json['description']),
        startCoordinates = nativeFromJson<String>(json['startCoordinates']),
        endCoordinates = nativeFromJson<String>(json['endCoordinates']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetPathPath otherTyped = other as GetPathPath;
    return title == otherTyped.title &&
        description == otherTyped.description &&
        startCoordinates == otherTyped.startCoordinates &&
        endCoordinates == otherTyped.endCoordinates;
  }

  @override
  int get hashCode => Object.hashAll([
        title.hashCode,
        description.hashCode,
        startCoordinates.hashCode,
        endCoordinates.hashCode
      ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['title'] = nativeToJson<String>(title);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    json['startCoordinates'] = nativeToJson<String>(startCoordinates);
    json['endCoordinates'] = nativeToJson<String>(endCoordinates);
    return json;
  }

  const GetPathPath({
    required this.title,
    this.description,
    required this.startCoordinates,
    required this.endCoordinates,
  });
}

@immutable
class GetPathData {
  final GetPathPath? path;
  GetPathData.fromJson(dynamic json)
      : path = json['path'] == null ? null : GetPathPath.fromJson(json['path']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetPathData otherTyped = other as GetPathData;
    return path == otherTyped.path;
  }

  @override
  int get hashCode => path.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (path != null) {
      json['path'] = path!.toJson();
    }
    return json;
  }

  const GetPathData({
    this.path,
  });
}

@immutable
class GetPathVariables {
  final String id;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetPathVariables.fromJson(Map<String, dynamic> json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetPathVariables otherTyped = other as GetPathVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const GetPathVariables({
    required this.id,
  });
}
