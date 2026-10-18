// ignore_for_file: non_constant_identifier_names

part of 'generated.dart';

class DeleteWaypointVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteWaypointVariablesBuilder(
    this._dataConnect, {
    required this.id,
  });
  Deserializer<DeleteWaypointData> dataDeserializer =
      (dynamic json) => DeleteWaypointData.fromJson(jsonDecode(json));
  Serializer<DeleteWaypointVariables> varsSerializer =
      (DeleteWaypointVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteWaypointData, DeleteWaypointVariables>>
      execute() {
    return ref().execute();
  }

  MutationRef<DeleteWaypointData, DeleteWaypointVariables> ref() {
    DeleteWaypointVariables vars = DeleteWaypointVariables(
      id: id,
    );
    return _dataConnect.mutation(
        "DeleteWaypoint", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteWaypointWaypointDelete {
  final String id;
  DeleteWaypointWaypointDelete.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteWaypointWaypointDelete otherTyped =
        other as DeleteWaypointWaypointDelete;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const DeleteWaypointWaypointDelete({
    required this.id,
  });
}

@immutable
class DeleteWaypointData {
  final DeleteWaypointWaypointDelete? waypoint_delete;
  DeleteWaypointData.fromJson(dynamic json)
      : waypoint_delete = json['waypoint_delete'] == null
            ? null
            : DeleteWaypointWaypointDelete.fromJson(json['waypoint_delete']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteWaypointData otherTyped = other as DeleteWaypointData;
    return waypoint_delete == otherTyped.waypoint_delete;
  }

  @override
  int get hashCode => waypoint_delete.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (waypoint_delete != null) {
      json['waypoint_delete'] = waypoint_delete!.toJson();
    }
    return json;
  }

  const DeleteWaypointData({
    this.waypoint_delete,
  });
}

@immutable
class DeleteWaypointVariables {
  final String id;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteWaypointVariables.fromJson(Map<String, dynamic> json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteWaypointVariables otherTyped = other as DeleteWaypointVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const DeleteWaypointVariables({
    required this.id,
  });
}
