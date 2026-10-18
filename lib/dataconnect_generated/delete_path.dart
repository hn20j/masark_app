// ignore_for_file: non_constant_identifier_names

part of 'generated.dart';

class DeletePathVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeletePathVariablesBuilder(
    this._dataConnect, {
    required this.id,
  });
  Deserializer<DeletePathData> dataDeserializer =
      (dynamic json) => DeletePathData.fromJson(jsonDecode(json));
  Serializer<DeletePathVariables> varsSerializer =
      (DeletePathVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeletePathData, DeletePathVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeletePathData, DeletePathVariables> ref() {
    DeletePathVariables vars = DeletePathVariables(
      id: id,
    );
    return _dataConnect.mutation(
        "DeletePath", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeletePathPathDelete {
  final String id;
  DeletePathPathDelete.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeletePathPathDelete otherTyped = other as DeletePathPathDelete;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const DeletePathPathDelete({
    required this.id,
  });
}

@immutable
class DeletePathData {
  final DeletePathPathDelete? path_delete;
  DeletePathData.fromJson(dynamic json)
      : path_delete = json['path_delete'] == null
            ? null
            : DeletePathPathDelete.fromJson(json['path_delete']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeletePathData otherTyped = other as DeletePathData;
    return path_delete == otherTyped.path_delete;
  }

  @override
  int get hashCode => path_delete.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (path_delete != null) {
      json['path_delete'] = path_delete!.toJson();
    }
    return json;
  }

  const DeletePathData({
    this.path_delete,
  });
}

@immutable
class DeletePathVariables {
  final String id;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeletePathVariables.fromJson(Map<String, dynamic> json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeletePathVariables otherTyped = other as DeletePathVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const DeletePathVariables({
    required this.id,
  });
}
