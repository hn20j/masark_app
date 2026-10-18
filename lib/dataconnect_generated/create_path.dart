// ignore_for_file: non_constant_identifier_names

part of 'generated.dart';

class CreatePathVariablesBuilder {
  String title;
  String startCoordinates;
  String endCoordinates;
  final Optional<String> _description =
      Optional.optional(nativeFromJson, nativeToJson);
  final Optional<String> _tags =
      Optional.optional(nativeFromJson, nativeToJson);
  final Optional<bool> _isPublic =
      Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  CreatePathVariablesBuilder description(String? t) {
    _description.value = t;
    return this;
  }

  CreatePathVariablesBuilder tags(String? t) {
    _tags.value = t;
    return this;
  }

  CreatePathVariablesBuilder isPublic(bool? t) {
    _isPublic.value = t;
    return this;
  }

  CreatePathVariablesBuilder(
    this._dataConnect, {
    required this.title,
    required this.startCoordinates,
    required this.endCoordinates,
  });
  Deserializer<CreatePathData> dataDeserializer =
      (dynamic json) => CreatePathData.fromJson(jsonDecode(json));
  Serializer<CreatePathVariables> varsSerializer =
      (CreatePathVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreatePathData, CreatePathVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreatePathData, CreatePathVariables> ref() {
    CreatePathVariables vars = CreatePathVariables(
      title: title,
      startCoordinates: startCoordinates,
      endCoordinates: endCoordinates,
      description: _description,
      tags: _tags,
      isPublic: _isPublic,
    );
    return _dataConnect.mutation(
        "CreatePath", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreatePathPathInsert {
  final String id;
  CreatePathPathInsert.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePathPathInsert otherTyped = other as CreatePathPathInsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const CreatePathPathInsert({
    required this.id,
  });
}

@immutable
class CreatePathData {
  final CreatePathPathInsert path_insert;
  CreatePathData.fromJson(dynamic json)
      : path_insert = CreatePathPathInsert.fromJson(json['path_insert']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePathData otherTyped = other as CreatePathData;
    return path_insert == otherTyped.path_insert;
  }

  @override
  int get hashCode => path_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['path_insert'] = path_insert.toJson();
    return json;
  }

  const CreatePathData({
    required this.path_insert,
  });
}

@immutable
class CreatePathVariables {
  final String title;
  final String startCoordinates;
  final String endCoordinates;
  final Optional<String> description;
  final Optional<String> tags;
  final Optional<bool> isPublic;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreatePathVariables.fromJson(Map<String, dynamic> json)
      : title = nativeFromJson<String>(json['title']),
        startCoordinates = nativeFromJson<String>(json['startCoordinates']),
        endCoordinates = nativeFromJson<String>(json['endCoordinates']),
        description = Optional.optional(nativeFromJson, nativeToJson),
        tags = Optional.optional(nativeFromJson, nativeToJson),
        isPublic = Optional.optional(nativeFromJson, nativeToJson) {
    description.value = json['description'] == null
        ? null
        : nativeFromJson<String>(json['description']);

    tags.value =
        json['tags'] == null ? null : nativeFromJson<String>(json['tags']);

    isPublic.value = json['isPublic'] == null
        ? null
        : nativeFromJson<bool>(json['isPublic']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreatePathVariables otherTyped = other as CreatePathVariables;
    return title == otherTyped.title &&
        startCoordinates == otherTyped.startCoordinates &&
        endCoordinates == otherTyped.endCoordinates &&
        description == otherTyped.description &&
        tags == otherTyped.tags &&
        isPublic == otherTyped.isPublic;
  }

  @override
  int get hashCode => Object.hashAll([
        title.hashCode,
        startCoordinates.hashCode,
        endCoordinates.hashCode,
        description.hashCode,
        tags.hashCode,
        isPublic.hashCode
      ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['title'] = nativeToJson<String>(title);
    json['startCoordinates'] = nativeToJson<String>(startCoordinates);
    json['endCoordinates'] = nativeToJson<String>(endCoordinates);
    if (description.state == OptionalState.set) {
      json['description'] = description.toJson();
    }
    if (tags.state == OptionalState.set) {
      json['tags'] = tags.toJson();
    }
    if (isPublic.state == OptionalState.set) {
      json['isPublic'] = isPublic.toJson();
    }
    return json;
  }

  const CreatePathVariables({
    required this.title,
    required this.startCoordinates,
    required this.endCoordinates,
    required this.description,
    required this.tags,
    required this.isPublic,
  });
}
