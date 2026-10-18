// ignore_for_file: non_constant_identifier_names

part of 'generated.dart';

class DeletePinVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeletePinVariablesBuilder(
    this._dataConnect, {
    required this.id,
  });
  Deserializer<DeletePinData> dataDeserializer =
      (dynamic json) => DeletePinData.fromJson(jsonDecode(json));
  Serializer<DeletePinVariables> varsSerializer =
      (DeletePinVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeletePinData, DeletePinVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeletePinData, DeletePinVariables> ref() {
    DeletePinVariables vars = DeletePinVariables(
      id: id,
    );
    return _dataConnect.mutation(
        "DeletePin", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeletePinPinDelete {
  final String id;
  DeletePinPinDelete.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeletePinPinDelete otherTyped = other as DeletePinPinDelete;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const DeletePinPinDelete({
    required this.id,
  });
}

@immutable
class DeletePinData {
  final DeletePinPinDelete? pin_delete;
  DeletePinData.fromJson(dynamic json)
      : pin_delete = json['pin_delete'] == null
            ? null
            : DeletePinPinDelete.fromJson(json['pin_delete']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeletePinData otherTyped = other as DeletePinData;
    return pin_delete == otherTyped.pin_delete;
  }

  @override
  int get hashCode => pin_delete.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (pin_delete != null) {
      json['pin_delete'] = pin_delete!.toJson();
    }
    return json;
  }

  const DeletePinData({
    this.pin_delete,
  });
}

@immutable
class DeletePinVariables {
  final String id;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeletePinVariables.fromJson(Map<String, dynamic> json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeletePinVariables otherTyped = other as DeletePinVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const DeletePinVariables({
    required this.id,
  });
}
