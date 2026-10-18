part of 'generated.dart';

class UpdateCollectionVariablesBuilder {
  String id;
  final Optional<String> _name =
      Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  UpdateCollectionVariablesBuilder name(String? t) {
    _name.value = t;
    return this;
  }

  UpdateCollectionVariablesBuilder(
    this._dataConnect, {
    required this.id,
  });
  Deserializer<UpdateCollectionData> dataDeserializer =
      (dynamic json) => UpdateCollectionData.fromJson(jsonDecode(json));
  Serializer<UpdateCollectionVariables> varsSerializer =
      (UpdateCollectionVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateCollectionData, UpdateCollectionVariables>>
      execute() {
    return ref().execute();
  }

  MutationRef<UpdateCollectionData, UpdateCollectionVariables> ref() {
    UpdateCollectionVariables vars = UpdateCollectionVariables(
      id: id,
      name: _name,
    );
    return _dataConnect.mutation(
        "UpdateCollection", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateCollectionCollectionUpdate {
  final String id;
  UpdateCollectionCollectionUpdate.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCollectionCollectionUpdate otherTyped =
        other as UpdateCollectionCollectionUpdate;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const UpdateCollectionCollectionUpdate({
    required this.id,
  });
}

@immutable
class UpdateCollectionData {
  final UpdateCollectionCollectionUpdate? collectionUpdate;
  UpdateCollectionData.fromJson(dynamic json)
      : collectionUpdate = json['collection_update'] == null
            ? null
            : UpdateCollectionCollectionUpdate.fromJson(
                json['collection_update']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCollectionData otherTyped = other as UpdateCollectionData;
    return collectionUpdate == otherTyped.collectionUpdate;
  }

  @override
  int get hashCode => collectionUpdate.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (collectionUpdate != null) {
      json['collection_update'] = collectionUpdate!.toJson();
    }
    return json;
  }

  const UpdateCollectionData({
    this.collectionUpdate,
  });
}

@immutable
class UpdateCollectionVariables {
  final String id;
  final Optional<String> name;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateCollectionVariables.fromJson(Map<String, dynamic> json)
      : id = nativeFromJson<String>(json['id']),
        name = Optional.optional(nativeFromJson, nativeToJson) {
    name.value =
        json['name'] == null ? null : nativeFromJson<String>(json['name']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateCollectionVariables otherTyped =
        other as UpdateCollectionVariables;
    return id == otherTyped.id && name == otherTyped.name;
  }

  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (name.state == OptionalState.set) {
      json['name'] = name.toJson();
    }
    return json;
  }

  const UpdateCollectionVariables({
    required this.id,
    required this.name,
  });
}
