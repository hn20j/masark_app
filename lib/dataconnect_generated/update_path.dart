// ignore_for_file: non_constant_identifier_names

part of 'generated.dart';

class UpdatePathVariablesBuilder {
  String id;
  final Optional<String> _title =
      Optional.optional(nativeFromJson, nativeToJson);
  final Optional<String> _description =
      Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  UpdatePathVariablesBuilder title(String? t) {
    _title.value = t;
    return this;
  }

  UpdatePathVariablesBuilder description(String? t) {
    _description.value = t;
    return this;
  }

  UpdatePathVariablesBuilder(
    this._dataConnect, {
    required this.id,
  });
  Deserializer<UpdatePathData> dataDeserializer =
      (dynamic json) => UpdatePathData.fromJson(jsonDecode(json));
  Serializer<UpdatePathVariables> varsSerializer =
      (UpdatePathVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdatePathData, UpdatePathVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdatePathData, UpdatePathVariables> ref() {
    UpdatePathVariables vars = UpdatePathVariables(
      id: id,
      title: _title,
      description: _description,
    );
    return _dataConnect.mutation(
        "UpdatePath", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdatePathPathUpdate {
  final String id;
  UpdatePathPathUpdate.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdatePathPathUpdate otherTyped = other as UpdatePathPathUpdate;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const UpdatePathPathUpdate({
    required this.id,
  });
}

@immutable
class UpdatePathData {
  final UpdatePathPathUpdate? path_update;
  UpdatePathData.fromJson(dynamic json)
      : path_update = json['path_update'] == null
            ? null
            : UpdatePathPathUpdate.fromJson(json['path_update']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdatePathData otherTyped = other as UpdatePathData;
    return path_update == otherTyped.path_update;
  }

  @override
  int get hashCode => path_update.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (path_update != null) {
      json['path_update'] = path_update!.toJson();
    }
    return json;
  }

  const UpdatePathData({
    this.path_update,
  });
}

@immutable
class UpdatePathVariables {
  final String id;
  final Optional<String> title;
  final Optional<String> description;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdatePathVariables.fromJson(Map<String, dynamic> json)
      : id = nativeFromJson<String>(json['id']),
        title = Optional.optional(nativeFromJson, nativeToJson)
          ..value = json['title'] == null
              ? null
              : nativeFromJson<String>(json['title']),
        description = Optional.optional(nativeFromJson, nativeToJson)
          ..value = json['description'] == null
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

    final UpdatePathVariables otherTyped = other as UpdatePathVariables;
    return id == otherTyped.id &&
        title == otherTyped.title &&
        description == otherTyped.description;
  }

  @override
  int get hashCode =>
      Object.hashAll([id.hashCode, title.hashCode, description.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (title.state == OptionalState.set) {
      json['title'] = title.toJson();
    }
    if (description.state == OptionalState.set) {
      json['description'] = description.toJson();
    }
    return json;
  }

  const UpdatePathVariables({
    required this.id,
    required this.title,
    required this.description,
  });
}
