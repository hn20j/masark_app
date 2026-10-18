// ignore_for_file: non_constant_identifier_names

part of 'generated.dart';

class CreatePinVariablesBuilder {
  String coordinates;
  String category;
  final Optional<String> _title =
      Optional.optional(nativeFromJson, nativeToJson);
  final Optional<String> _description =
      Optional.optional(nativeFromJson, nativeToJson);
  final Optional<String> _photoUrl =
      Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  CreatePinVariablesBuilder title(String? t) {
    _title.value = t;
    return this;
  }

  CreatePinVariablesBuilder description(String? t) {
    _description.value = t;
    return this;
  }

  CreatePinVariablesBuilder photoUrl(String? t) {
    _photoUrl.value = t;
    return this;
  }

  CreatePinVariablesBuilder(
    this._dataConnect, {
    required this.coordinates,
    required this.category,
  });
  Deserializer<CreatePinData> dataDeserializer =
      (dynamic json) => CreatePinData.fromJson(jsonDecode(json));
  Serializer<CreatePinVariables> varsSerializer =
      (CreatePinVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreatePinData, CreatePinVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreatePinData, CreatePinVariables> ref() {
    CreatePinVariables vars = CreatePinVariables(
      coordinates: coordinates,
      category: category,
      title: _title,
      description: _description,
      photoUrl: _photoUrl,
    );
    return _dataConnect.mutation(
        "CreatePin", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreatePinPinInsert {
  final String id;
  CreatePinPinInsert.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePinPinInsert otherTyped = other as CreatePinPinInsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const CreatePinPinInsert({
    required this.id,
  });
}

@immutable
class CreatePinData {
  final CreatePinPinInsert pinInsert;
  CreatePinData.fromJson(dynamic json)
      : pinInsert = CreatePinPinInsert.fromJson(json['pin_insert']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePinData otherTyped = other as CreatePinData;
    return pinInsert == otherTyped.pinInsert;
  }

  @override
  int get hashCode => pinInsert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['pin_insert'] = pinInsert.toJson();
    return json;
  }

  const CreatePinData({
    required this.pinInsert,
  });
}

@immutable
class CreatePinVariables {
  final String coordinates;
  final String category;
  final Optional<String> title;
  final Optional<String> description;
  final Optional<String> photoUrl;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreatePinVariables.fromJson(Map<String, dynamic> json)
      : coordinates = nativeFromJson<String>(json['coordinates']),
        category = nativeFromJson<String>(json['category']),
        title = Optional.optional(nativeFromJson, nativeToJson),
        description = Optional.optional(nativeFromJson, nativeToJson),
        photoUrl = Optional.optional(nativeFromJson, nativeToJson) {
    title.value =
        json['title'] == null ? null : nativeFromJson<String>(json['title']);

    description.value = json['description'] == null
        ? null
        : nativeFromJson<String>(json['description']);

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

    final CreatePinVariables otherTyped = other as CreatePinVariables;
    return coordinates == otherTyped.coordinates &&
        category == otherTyped.category &&
        title == otherTyped.title &&
        description == otherTyped.description &&
        photoUrl == otherTyped.photoUrl;
  }

  @override
  int get hashCode => Object.hashAll([
        coordinates.hashCode,
        category.hashCode,
        title.hashCode,
        description.hashCode,
        photoUrl.hashCode
      ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['coordinates'] = nativeToJson<String>(coordinates);
    json['category'] = nativeToJson<String>(category);
    if (title.state == OptionalState.set) {
      json['title'] = title.toJson();
    }
    if (description.state == OptionalState.set) {
      json['description'] = description.toJson();
    }
    if (photoUrl.state == OptionalState.set) {
      json['photoUrl'] = photoUrl.toJson();
    }
    return json;
  }

  const CreatePinVariables({
    required this.coordinates,
    required this.category,
    required this.title,
    required this.description,
    required this.photoUrl,
  });
}
