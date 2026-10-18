// ignore_for_file: non_constant_identifier_names

part of 'generated.dart';

class DeleteCollectionVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteCollectionVariablesBuilder(
    this._dataConnect, {
    required this.id,
  });
  Deserializer<DeleteCollectionData> dataDeserializer =
      (dynamic json) => DeleteCollectionData.fromJson(jsonDecode(json));
  Serializer<DeleteCollectionVariables> varsSerializer =
      (DeleteCollectionVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteCollectionData, DeleteCollectionVariables>>
      execute() {
    return ref().execute();
  }

  MutationRef<DeleteCollectionData, DeleteCollectionVariables> ref() {
    DeleteCollectionVariables vars = DeleteCollectionVariables(
      id: id,
    );
    return _dataConnect.mutation(
        "DeleteCollection", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteCollectionCollectionDelete {
  final String id;
  DeleteCollectionCollectionDelete.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCollectionCollectionDelete otherTyped =
        other as DeleteCollectionCollectionDelete;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const DeleteCollectionCollectionDelete({
    required this.id,
  });
}

@immutable
class DeleteCollectionData {
  final DeleteCollectionCollectionDelete? collection_delete;
  DeleteCollectionData.fromJson(dynamic json)
      : collection_delete = json['collection_delete'] == null
            ? null
            : DeleteCollectionCollectionDelete.fromJson(
                json['collection_delete']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCollectionData otherTyped = other as DeleteCollectionData;
    return collection_delete == otherTyped.collection_delete;
  }

  @override
  int get hashCode => collection_delete.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (collection_delete != null) {
      json['collection_delete'] = collection_delete!.toJson();
    }
    return json;
  }

  const DeleteCollectionData({
    this.collection_delete,
  });
}

@immutable
class DeleteCollectionVariables {
  final String id;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteCollectionVariables.fromJson(Map<String, dynamic> json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCollectionVariables otherTyped =
        other as DeleteCollectionVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const DeleteCollectionVariables({
    required this.id,
  });
}
