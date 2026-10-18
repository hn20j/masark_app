// ignore_for_file: non_constant_identifier_names

part of 'generated.dart';

class CreateCollectionVariablesBuilder {
  String name;
  final Optional<String> _description =
      Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  CreateCollectionVariablesBuilder description(String? t) {
    _description.value = t;
    return this;
  }

  CreateCollectionVariablesBuilder(
    this._dataConnect, {
    required this.name,
  });
  Deserializer<CreateCollectionData> dataDeserializer =
      (dynamic json) => CreateCollectionData.fromJson(jsonDecode(json));
  Serializer<CreateCollectionVariables> varsSerializer =
      (CreateCollectionVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateCollectionData, CreateCollectionVariables>>
      execute() {
    return ref().execute();
  }

  MutationRef<CreateCollectionData, CreateCollectionVariables> ref() {
    CreateCollectionVariables vars = CreateCollectionVariables(
      name: name,
      description: _description,
    );
    return _dataConnect.mutation(
        "CreateCollection", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateCollectionCollectionInsert {
  final String id;
  CreateCollectionCollectionInsert.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCollectionCollectionInsert otherTyped =
        other as CreateCollectionCollectionInsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const CreateCollectionCollectionInsert({
    required this.id,
  });
}

@immutable
class CreateCollectionData {
  final CreateCollectionCollectionInsert collection_insert;
  CreateCollectionData.fromJson(dynamic json)
      : collection_insert = CreateCollectionCollectionInsert.fromJson(
            json['collection_insert']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCollectionData otherTyped = other as CreateCollectionData;
    return collection_insert == otherTyped.collection_insert;
  }

  @override
  int get hashCode => collection_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['collection_insert'] = collection_insert.toJson();
    return json;
  }

  const CreateCollectionData({
    required this.collection_insert,
  });
}

@immutable
class CreateCollectionVariables {
  final String name;
  final Optional<String> description;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateCollectionVariables.fromJson(Map<String, dynamic> json)
      : name = nativeFromJson<String>(json['name']),
        description = Optional.optional(nativeFromJson, nativeToJson) {
    description.value = json['description'] == null
        ? null
        : nativeFromJson<String>(json['description']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCollectionVariables otherTyped =
        other as CreateCollectionVariables;
    return name == otherTyped.name && description == otherTyped.description;
  }

  @override
  int get hashCode => Object.hashAll([name.hashCode, description.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = nativeToJson<String>(name);
    if (description.state == OptionalState.set) {
      json['description'] = description.toJson();
    }
    return json;
  }

  const CreateCollectionVariables({
    required this.name,
    required this.description,
  });
}
