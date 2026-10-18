// ignore_for_file: non_constant_identifier_names

part of 'generated.dart';

class UpdatePinVariablesBuilder {
  String id;
  final Optional<String> _title =
      Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  UpdatePinVariablesBuilder title(String? t) {
    _title.value = t;
    return this;
  }

  UpdatePinVariablesBuilder(
    this._dataConnect, {
    required this.id,
  });
  Deserializer<UpdatePinData> dataDeserializer =
      (dynamic json) => UpdatePinData.fromJson(jsonDecode(json));
  Serializer<UpdatePinVariables> varsSerializer =
      (UpdatePinVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdatePinData, UpdatePinVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdatePinData, UpdatePinVariables> ref() {
    UpdatePinVariables vars = UpdatePinVariables(
      id: id,
      title: _title,
    );
    return _dataConnect.mutation(
        "UpdatePin", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdatePinPinUpdate {
  final String id;
  UpdatePinPinUpdate.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdatePinPinUpdate otherTyped = other as UpdatePinPinUpdate;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const UpdatePinPinUpdate({
    required this.id,
  });
}

@immutable
class UpdatePinData {
  final UpdatePinPinUpdate? pin_update;
  UpdatePinData.fromJson(dynamic json)
      : pin_update = json['pin_update'] == null
            ? null
            : UpdatePinPinUpdate.fromJson(json['pin_update']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdatePinData otherTyped = other as UpdatePinData;
    return pin_update == otherTyped.pin_update;
  }

  @override
  int get hashCode => pin_update.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (pin_update != null) {
      json['pin_update'] = pin_update!.toJson();
    }
    return json;
  }

  const UpdatePinData({
    this.pin_update,
  });
}

@immutable
class UpdatePinVariables {
  final String id;
  final Optional<String> title;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdatePinVariables.fromJson(Map<String, dynamic> json)
      : id = nativeFromJson<String>(json['id']),
        title = Optional.optional(nativeFromJson, nativeToJson) {
    title.value =
        json['title'] == null ? null : nativeFromJson<String>(json['title']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdatePinVariables otherTyped = other as UpdatePinVariables;
    return id == otherTyped.id && title == otherTyped.title;
  }

  @override
  int get hashCode => Object.hashAll([id.hashCode, title.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (title.state == OptionalState.set) {
      json['title'] = title.toJson();
    }
    return json;
  }

  const UpdatePinVariables({
    required this.id,
    required this.title,
  });
}
