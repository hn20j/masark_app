// ignore_for_file: non_constant_identifier_names

part of 'generated.dart';

class RemoveSavedPathVariablesBuilder {
  String collectionId;
  String pathId;

  final FirebaseDataConnect _dataConnect;
  RemoveSavedPathVariablesBuilder(
    this._dataConnect, {
    required this.collectionId,
    required this.pathId,
  });
  Deserializer<RemoveSavedPathData> dataDeserializer =
      (dynamic json) => RemoveSavedPathData.fromJson(jsonDecode(json));
  Serializer<RemoveSavedPathVariables> varsSerializer =
      (RemoveSavedPathVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<RemoveSavedPathData, RemoveSavedPathVariables>>
      execute() {
    return ref().execute();
  }

  MutationRef<RemoveSavedPathData, RemoveSavedPathVariables> ref() {
    RemoveSavedPathVariables vars = RemoveSavedPathVariables(
      collectionId: collectionId,
      pathId: pathId,
    );
    return _dataConnect.mutation(
        "RemoveSavedPath", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class RemoveSavedPathSavedPathDelete {
  final String collectionId;
  final String pathId;
  RemoveSavedPathSavedPathDelete.fromJson(dynamic json)
      : collectionId = nativeFromJson<String>(json['collectionId']),
        pathId = nativeFromJson<String>(json['pathId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final RemoveSavedPathSavedPathDelete otherTyped =
        other as RemoveSavedPathSavedPathDelete;
    return collectionId == otherTyped.collectionId &&
        pathId == otherTyped.pathId;
  }

  @override
  int get hashCode => Object.hashAll([collectionId.hashCode, pathId.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['collectionId'] = nativeToJson<String>(collectionId);
    json['pathId'] = nativeToJson<String>(pathId);
    return json;
  }

  const RemoveSavedPathSavedPathDelete({
    required this.collectionId,
    required this.pathId,
  });
}

@immutable
class RemoveSavedPathData {
  final RemoveSavedPathSavedPathDelete? savedPath_delete;
  RemoveSavedPathData.fromJson(dynamic json)
      : savedPath_delete = json['savedPath_delete'] == null
            ? null
            : RemoveSavedPathSavedPathDelete.fromJson(json['savedPath_delete']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final RemoveSavedPathData otherTyped = other as RemoveSavedPathData;
    return savedPath_delete == otherTyped.savedPath_delete;
  }

  @override
  int get hashCode => savedPath_delete.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (savedPath_delete != null) {
      json['savedPath_delete'] = savedPath_delete!.toJson();
    }
    return json;
  }

  const RemoveSavedPathData({
    this.savedPath_delete,
  });
}

@immutable
class RemoveSavedPathVariables {
  final String collectionId;
  final String pathId;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  RemoveSavedPathVariables.fromJson(Map<String, dynamic> json)
      : collectionId = nativeFromJson<String>(json['collectionId']),
        pathId = nativeFromJson<String>(json['pathId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final RemoveSavedPathVariables otherTyped =
        other as RemoveSavedPathVariables;
    return collectionId == otherTyped.collectionId &&
        pathId == otherTyped.pathId;
  }

  @override
  int get hashCode => Object.hashAll([collectionId.hashCode, pathId.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['collectionId'] = nativeToJson<String>(collectionId);
    json['pathId'] = nativeToJson<String>(pathId);
    return json;
  }

  const RemoveSavedPathVariables({
    required this.collectionId,
    required this.pathId,
  });
}
