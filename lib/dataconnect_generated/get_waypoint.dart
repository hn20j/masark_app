part of 'generated.dart';

class GetWaypointVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetWaypointVariablesBuilder(
    this._dataConnect, {
    required this.id,
  });
  Deserializer<GetWaypointData> dataDeserializer =
      (dynamic json) => GetWaypointData.fromJson(jsonDecode(json));
  Serializer<GetWaypointVariables> varsSerializer =
      (GetWaypointVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetWaypointData, GetWaypointVariables>> execute(
      {QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetWaypointData, GetWaypointVariables> ref() {
    GetWaypointVariables vars = GetWaypointVariables(
      id: id,
    );
    return _dataConnect.query(
        "GetWaypoint", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetWaypointWaypoint {
  final String coordinates;
  final int orderIndex;
  final String? note;
  final String? photoUrl;
  GetWaypointWaypoint.fromJson(dynamic json)
      : coordinates = nativeFromJson<String>(json['coordinates']),
        orderIndex = nativeFromJson<int>(json['orderIndex']),
        note =
            json['note'] == null ? null : nativeFromJson<String>(json['note']),
        photoUrl = json['photoUrl'] == null
            ? null
            : nativeFromJson<String>(json['photoUrl']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetWaypointWaypoint otherTyped = other as GetWaypointWaypoint;
    return coordinates == otherTyped.coordinates &&
        orderIndex == otherTyped.orderIndex &&
        note == otherTyped.note &&
        photoUrl == otherTyped.photoUrl;
  }

  @override
  int get hashCode => Object.hashAll([
        coordinates.hashCode,
        orderIndex.hashCode,
        note.hashCode,
        photoUrl.hashCode
      ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['coordinates'] = nativeToJson<String>(coordinates);
    json['orderIndex'] = nativeToJson<int>(orderIndex);
    if (note != null) {
      json['note'] = nativeToJson<String?>(note);
    }
    if (photoUrl != null) {
      json['photoUrl'] = nativeToJson<String?>(photoUrl);
    }
    return json;
  }

  const GetWaypointWaypoint({
    required this.coordinates,
    required this.orderIndex,
    this.note,
    this.photoUrl,
  });
}

@immutable
class GetWaypointData {
  final GetWaypointWaypoint? waypoint;
  GetWaypointData.fromJson(dynamic json)
      : waypoint = json['waypoint'] == null
            ? null
            : GetWaypointWaypoint.fromJson(json['waypoint']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetWaypointData otherTyped = other as GetWaypointData;
    return waypoint == otherTyped.waypoint;
  }

  @override
  int get hashCode => waypoint.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (waypoint != null) {
      json['waypoint'] = waypoint!.toJson();
    }
    return json;
  }

  const GetWaypointData({
    this.waypoint,
  });
}

@immutable
class GetWaypointVariables {
  final String id;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetWaypointVariables.fromJson(Map<String, dynamic> json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetWaypointVariables otherTyped = other as GetWaypointVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const GetWaypointVariables({
    required this.id,
  });
}
