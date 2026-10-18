part of 'generated.dart';

class GetPinVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  GetPinVariablesBuilder(
    this._dataConnect, {
    required this.id,
  });
  Deserializer<GetPinData> dataDeserializer =
      (dynamic json) => GetPinData.fromJson(jsonDecode(json));
  Serializer<GetPinVariables> varsSerializer =
      (GetPinVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetPinData, GetPinVariables>> execute(
      {QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetPinData, GetPinVariables> ref() {
    GetPinVariables vars = GetPinVariables(
      id: id,
    );
    return _dataConnect.query("GetPin", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetPinPin {
  final String? title;
  final String coordinates;
  final String category;
  final String? description;
  GetPinPin.fromJson(dynamic json)
      : title = json['title'] == null
            ? null
            : nativeFromJson<String>(json['title']),
        coordinates = nativeFromJson<String>(json['coordinates']),
        category = nativeFromJson<String>(json['category']),
        description = json['description'] == null
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

    final GetPinPin otherTyped = other as GetPinPin;
    return title == otherTyped.title &&
        coordinates == otherTyped.coordinates &&
        category == otherTyped.category &&
        description == otherTyped.description;
  }

  @override
  int get hashCode => Object.hashAll([
        title.hashCode,
        coordinates.hashCode,
        category.hashCode,
        description.hashCode
      ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (title != null) {
      json['title'] = nativeToJson<String?>(title);
    }
    json['coordinates'] = nativeToJson<String>(coordinates);
    json['category'] = nativeToJson<String>(category);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    return json;
  }

  const GetPinPin({
    this.title,
    required this.coordinates,
    required this.category,
    this.description,
  });
}

@immutable
class GetPinData {
  final GetPinPin? pin;
  GetPinData.fromJson(dynamic json)
      : pin = json['pin'] == null ? null : GetPinPin.fromJson(json['pin']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetPinData otherTyped = other as GetPinData;
    return pin == otherTyped.pin;
  }

  @override
  int get hashCode => pin.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (pin != null) {
      json['pin'] = pin!.toJson();
    }
    return json;
  }

  const GetPinData({
    this.pin,
  });
}

@immutable
class GetPinVariables {
  final String id;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetPinVariables.fromJson(Map<String, dynamic> json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetPinVariables otherTyped = other as GetPinVariables;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const GetPinVariables({
    required this.id,
  });
}
