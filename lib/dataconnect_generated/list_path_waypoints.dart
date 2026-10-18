part of 'generated.dart';

class ListPathWaypointsVariablesBuilder {
  String pathId;

  final FirebaseDataConnect _dataConnect;
  ListPathWaypointsVariablesBuilder(
    this._dataConnect, {
    required this.pathId,
  });
  Deserializer<ListPathWaypointsData> dataDeserializer =
      (dynamic json) => ListPathWaypointsData.fromJson(jsonDecode(json));
  Serializer<ListPathWaypointsVariables> varsSerializer =
      (ListPathWaypointsVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ListPathWaypointsData, ListPathWaypointsVariables>>
      execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListPathWaypointsData, ListPathWaypointsVariables> ref() {
    ListPathWaypointsVariables vars = ListPathWaypointsVariables(
      pathId: pathId,
    );
    return _dataConnect.query(
        "ListPathWaypoints", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ListPathWaypointsWaypoints {
  final String coordinates;
  final int orderIndex;
  final String? note;
  ListPathWaypointsWaypoints.fromJson(dynamic json)
      : coordinates = nativeFromJson<String>(json['coordinates']),
        orderIndex = nativeFromJson<int>(json['orderIndex']),
        note =
            json['note'] == null ? null : nativeFromJson<String>(json['note']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListPathWaypointsWaypoints otherTyped =
        other as ListPathWaypointsWaypoints;
    return coordinates == otherTyped.coordinates &&
        orderIndex == otherTyped.orderIndex &&
        note == otherTyped.note;
  }

  @override
  int get hashCode => Object.hashAll(
      [coordinates.hashCode, orderIndex.hashCode, note.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['coordinates'] = nativeToJson<String>(coordinates);
    json['orderIndex'] = nativeToJson<int>(orderIndex);
    if (note != null) {
      json['note'] = nativeToJson<String?>(note);
    }
    return json;
  }

  const ListPathWaypointsWaypoints({
    required this.coordinates,
    required this.orderIndex,
    this.note,
  });
}

@immutable
class ListPathWaypointsData {
  final List<ListPathWaypointsWaypoints> waypoints;
  ListPathWaypointsData.fromJson(dynamic json)
      : waypoints = (json['waypoints'] as List<dynamic>)
            .map((e) => ListPathWaypointsWaypoints.fromJson(e))
            .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListPathWaypointsData otherTyped = other as ListPathWaypointsData;
    return waypoints == otherTyped.waypoints;
  }

  @override
  int get hashCode => waypoints.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['waypoints'] = waypoints.map((e) => e.toJson()).toList();
    return json;
  }

  const ListPathWaypointsData({
    required this.waypoints,
  });
}

@immutable
class ListPathWaypointsVariables {
  final String pathId;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ListPathWaypointsVariables.fromJson(Map<String, dynamic> json)
      : pathId = nativeFromJson<String>(json['pathId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListPathWaypointsVariables otherTyped =
        other as ListPathWaypointsVariables;
    return pathId == otherTyped.pathId;
  }

  @override
  int get hashCode => pathId.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['pathId'] = nativeToJson<String>(pathId);
    return json;
  }

  const ListPathWaypointsVariables({
    required this.pathId,
  });
}
