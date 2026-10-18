// ignore_for_file: non_constant_identifier_names

part of 'generated.dart';

class SavePathVariablesBuilder {
  String collectionId;
  String pathId;

  final FirebaseDataConnect _dataConnect;
  SavePathVariablesBuilder(
    this._dataConnect, {
    required this.collectionId,
    required this.pathId,
  });
  Deserializer<SavePathData> dataDeserializer =
      (dynamic json) => SavePathData.fromJson(jsonDecode(json));
  Serializer<SavePathVariables> varsSerializer =
      (SavePathVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<SavePathData, SavePathVariables>> execute() {
    return ref().execute();
  }

  MutationRef<SavePathData, SavePathVariables> ref() {
    SavePathVariables vars = SavePathVariables(
      collectionId: collectionId,
      pathId: pathId,
    );
    return _dataConnect.mutation(
        "SavePath", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class SavePathSavedPathInsert {
  final String collectionId;
  final String pathId;
  SavePathSavedPathInsert.fromJson(dynamic json)
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

    final SavePathSavedPathInsert otherTyped = other as SavePathSavedPathInsert;
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

  const SavePathSavedPathInsert({
    required this.collectionId,
    required this.pathId,
  });
}

@immutable
class SavePathData {
  final SavePathSavedPathInsert savedPath_insert;
  SavePathData.fromJson(dynamic json)
      : savedPath_insert =
            SavePathSavedPathInsert.fromJson(json['savedPath_insert']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final SavePathData otherTyped = other as SavePathData;
    return savedPath_insert == otherTyped.savedPath_insert;
  }

  @override
  int get hashCode => savedPath_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['savedPath_insert'] = savedPath_insert.toJson();
    return json;
  }

  const SavePathData({
    required this.savedPath_insert,
  });
}

@immutable
class SavePathVariables {
  final String collectionId;
  final String pathId;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  SavePathVariables.fromJson(Map<String, dynamic> json)
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

    final SavePathVariables otherTyped = other as SavePathVariables;
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

  const SavePathVariables({
    required this.collectionId,
    required this.pathId,
  });
}
