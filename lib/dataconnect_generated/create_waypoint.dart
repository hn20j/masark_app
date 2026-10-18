// ignore_for_file: non_constant_identifier_names

part of 'generated.dart';

class CreateWaypointVariablesBuilder {
  String pathId;
  String coordinates;
  int orderIndex;
  final Optional<String> _note =
      Optional.optional(nativeFromJson, nativeToJson);
  final Optional<String> _photoUrl =
      Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  CreateWaypointVariablesBuilder note(String? t) {
    _note.value = t;
    return this;
  }

  CreateWaypointVariablesBuilder photoUrl(String? t) {
    _photoUrl.value = t;
    return this;
  }

  CreateWaypointVariablesBuilder(
    this._dataConnect, {
    required this.pathId,
    required this.coordinates,
    required this.orderIndex,
  });
  Deserializer<CreateWaypointData> dataDeserializer =
      (dynamic json) => CreateWaypointData.fromJson(jsonDecode(json));
  Serializer<CreateWaypointVariables> varsSerializer =
      (CreateWaypointVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateWaypointData, CreateWaypointVariables>>
      execute() {
    return ref().execute();
  }

  MutationRef<CreateWaypointData, CreateWaypointVariables> ref() {
    CreateWaypointVariables vars = CreateWaypointVariables(
      pathId: pathId,
      coordinates: coordinates,
      orderIndex: orderIndex,
      note: _note,
      photoUrl: _photoUrl,
    );
    return _dataConnect.mutation(
        "CreateWaypoint", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateWaypointWaypointInsert {
  final String id;
  CreateWaypointWaypointInsert.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateWaypointWaypointInsert otherTyped =
        other as CreateWaypointWaypointInsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const CreateWaypointWaypointInsert({
    required this.id,
  });
}

@immutable
class CreateWaypointData {
  final CreateWaypointWaypointInsert waypoint_insert;
  CreateWaypointData.fromJson(dynamic json)
      : waypoint_insert =
            CreateWaypointWaypointInsert.fromJson(json['waypoint_insert']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateWaypointData otherTyped = other as CreateWaypointData;
    return waypoint_insert == otherTyped.waypoint_insert;
  }

  @override
  int get hashCode => waypoint_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['waypoint_insert'] = waypoint_insert.toJson();
    return json;
  }

  const CreateWaypointData({
    required this.waypoint_insert,
  });
}

@immutable
class CreateWaypointVariables {
  final String pathId;
  final String coordinates;
  final int orderIndex;
  final Optional<String> note;
  final Optional<String> photoUrl;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateWaypointVariables.fromJson(Map<String, dynamic> json)
      : pathId = nativeFromJson<String>(json['pathId']),
        coordinates = nativeFromJson<String>(json['coordinates']),
        orderIndex = nativeFromJson<int>(json['orderIndex']),
        note = Optional.optional(nativeFromJson, nativeToJson),
        photoUrl = Optional.optional(nativeFromJson, nativeToJson) {
    note.value =
        json['note'] == null ? null : nativeFromJson<String>(json['note']);

    photoUrl.value = json['photoUrl'] == null
        ? null
        : nativeFromJson<String>(json['photoUrl']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateWaypointVariables otherTyped = other as CreateWaypointVariables;
    return pathId == otherTyped.pathId &&
        coordinates == otherTyped.coordinates &&
        orderIndex == otherTyped.orderIndex &&
        note == otherTyped.note &&
        photoUrl == otherTyped.photoUrl;
  }

  @override
  int get hashCode => Object.hashAll([
        pathId.hashCode,
        coordinates.hashCode,
        orderIndex.hashCode,
        note.hashCode,
        photoUrl.hashCode
      ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['pathId'] = nativeToJson<String>(pathId);
    json['coordinates'] = nativeToJson<String>(coordinates);
    json['orderIndex'] = nativeToJson<int>(orderIndex);
    if (note.state == OptionalState.set) {
      json['note'] = note.toJson();
    }
    if (photoUrl.state == OptionalState.set) {
      json['photoUrl'] = photoUrl.toJson();
    }
    return json;
  }

  const CreateWaypointVariables({
    required this.pathId,
    required this.coordinates,
    required this.orderIndex,
    required this.note,
    required this.photoUrl,
  });
}
