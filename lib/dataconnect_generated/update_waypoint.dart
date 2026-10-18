// ignore_for_file: non_constant_identifier_names

part of 'generated.dart';

class UpdateWaypointVariablesBuilder {
  String id;
  final Optional<String> _note =
      Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  UpdateWaypointVariablesBuilder note(String? t) {
    _note.value = t;
    return this;
  }

  UpdateWaypointVariablesBuilder(
    this._dataConnect, {
    required this.id,
  });
  Deserializer<UpdateWaypointData> dataDeserializer =
      (dynamic json) => UpdateWaypointData.fromJson(jsonDecode(json));
  Serializer<UpdateWaypointVariables> varsSerializer =
      (UpdateWaypointVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateWaypointData, UpdateWaypointVariables>>
      execute() {
    return ref().execute();
  }

  MutationRef<UpdateWaypointData, UpdateWaypointVariables> ref() {
    UpdateWaypointVariables vars = UpdateWaypointVariables(
      id: id,
      note: _note,
    );
    return _dataConnect.mutation(
        "UpdateWaypoint", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateWaypointWaypointUpdate {
  final String id;
  UpdateWaypointWaypointUpdate.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateWaypointWaypointUpdate otherTyped =
        other as UpdateWaypointWaypointUpdate;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const UpdateWaypointWaypointUpdate({
    required this.id,
  });
}

@immutable
class UpdateWaypointData {
  final UpdateWaypointWaypointUpdate? waypoint_update;
  UpdateWaypointData.fromJson(dynamic json)
      : waypoint_update = json['waypoint_update'] == null
            ? null
            : UpdateWaypointWaypointUpdate.fromJson(json['waypoint_update']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateWaypointData otherTyped = other as UpdateWaypointData;
    return waypoint_update == otherTyped.waypoint_update;
  }

  @override
  int get hashCode => waypoint_update.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (waypoint_update != null) {
      json['waypoint_update'] = waypoint_update!.toJson();
    }
    return json;
  }

  const UpdateWaypointData({
    this.waypoint_update,
  });
}

@immutable
class UpdateWaypointVariables {
  final String id;
  final Optional<String> note;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateWaypointVariables.fromJson(Map<String, dynamic> json)
      : id = nativeFromJson<String>(json['id']),
        note = Optional.optional(nativeFromJson, nativeToJson) {
    note.value =
        json['note'] == null ? null : nativeFromJson<String>(json['note']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateWaypointVariables otherTyped = other as UpdateWaypointVariables;
    return id == otherTyped.id && note == otherTyped.note;
  }

  @override
  int get hashCode => Object.hashAll([id.hashCode, note.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (note.state == OptionalState.set) {
      json['note'] = note.toJson();
    }
    return json;
  }

  const UpdateWaypointVariables({
    required this.id,
    required this.note,
  });
}
