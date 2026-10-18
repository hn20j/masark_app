part of 'generated.dart';

class ListMyPinsVariablesBuilder {
  final FirebaseDataConnect _dataConnect;
  ListMyPinsVariablesBuilder(
    this._dataConnect,
  );
  Deserializer<ListMyPinsData> dataDeserializer =
      (dynamic json) => ListMyPinsData.fromJson(jsonDecode(json));

  Future<QueryResult<ListMyPinsData, void>> execute(
      {QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListMyPinsData, void> ref() {
    return _dataConnect.query(
        "ListMyPins", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListMyPinsPins {
  final String? title;
  final String coordinates;
  ListMyPinsPins.fromJson(dynamic json)
      : title = json['title'] == null
            ? null
            : nativeFromJson<String>(json['title']),
        coordinates = nativeFromJson<String>(json['coordinates']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListMyPinsPins otherTyped = other as ListMyPinsPins;
    return title == otherTyped.title && coordinates == otherTyped.coordinates;
  }

  @override
  int get hashCode => Object.hashAll([title.hashCode, coordinates.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (title != null) {
      json['title'] = nativeToJson<String?>(title);
    }
    json['coordinates'] = nativeToJson<String>(coordinates);
    return json;
  }

  const ListMyPinsPins({
    this.title,
    required this.coordinates,
  });
}

@immutable
class ListMyPinsData {
  final List<ListMyPinsPins> pins;
  ListMyPinsData.fromJson(dynamic json)
      : pins = (json['pins'] as List<dynamic>)
            .map((e) => ListMyPinsPins.fromJson(e))
            .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListMyPinsData otherTyped = other as ListMyPinsData;
    return pins == otherTyped.pins;
  }

  @override
  int get hashCode => pins.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['pins'] = pins.map((e) => e.toJson()).toList();
    return json;
  }

  const ListMyPinsData({
    required this.pins,
  });
}
