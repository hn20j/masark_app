// ignore_for_file: non_constant_identifier_names

part of 'generated.dart';

class UpdateUserVariablesBuilder {
  final Optional<String> _bio = Optional.optional(nativeFromJson, nativeToJson);
  final Optional<String> _profileImageUrl =
      Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;
  UpdateUserVariablesBuilder bio(String? t) {
    _bio.value = t;
    return this;
  }

  UpdateUserVariablesBuilder profileImageUrl(String? t) {
    _profileImageUrl.value = t;
    return this;
  }

  UpdateUserVariablesBuilder(
    this._dataConnect,
  );
  Deserializer<UpdateUserData> dataDeserializer =
      (dynamic json) => UpdateUserData.fromJson(jsonDecode(json));
  Serializer<UpdateUserVariables> varsSerializer =
      (UpdateUserVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpdateUserData, UpdateUserVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpdateUserData, UpdateUserVariables> ref() {
    UpdateUserVariables vars = UpdateUserVariables(
      bio: _bio,
      profileImageUrl: _profileImageUrl,
    );
    return _dataConnect.mutation(
        "UpdateUser", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpdateUserUserUpdate {
  final String id;
  UpdateUserUserUpdate.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserUserUpdate otherTyped = other as UpdateUserUserUpdate;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const UpdateUserUserUpdate({
    required this.id,
  });
}

@immutable
class UpdateUserData {
  final UpdateUserUserUpdate? user_update;
  UpdateUserData.fromJson(dynamic json)
      : user_update = json['user_update'] == null
            ? null
            : UpdateUserUserUpdate.fromJson(json['user_update']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserData otherTyped = other as UpdateUserData;
    return user_update == otherTyped.user_update;
  }

  @override
  int get hashCode => user_update.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user_update != null) {
      json['user_update'] = user_update!.toJson();
    }
    return json;
  }

  const UpdateUserData({
    this.user_update,
  });
}

@immutable
class UpdateUserVariables {
  final Optional<String> bio;
  final Optional<String> profileImageUrl;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpdateUserVariables.fromJson(Map<String, dynamic> json)
      : bio = Optional.optional(nativeFromJson, nativeToJson),
        profileImageUrl = Optional.optional(nativeFromJson, nativeToJson) {
    bio.value =
        json['bio'] == null ? null : nativeFromJson<String>(json['bio']);

    profileImageUrl.value = json['profileImageUrl'] == null
        ? null
        : nativeFromJson<String>(json['profileImageUrl']);
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UpdateUserVariables otherTyped = other as UpdateUserVariables;
    return bio == otherTyped.bio &&
        profileImageUrl == otherTyped.profileImageUrl;
  }

  @override
  int get hashCode => Object.hashAll([bio.hashCode, profileImageUrl.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (bio.state == OptionalState.set) {
      json['bio'] = bio.toJson();
    }
    if (profileImageUrl.state == OptionalState.set) {
      json['profileImageUrl'] = profileImageUrl.toJson();
    }
    return json;
  }

  const UpdateUserVariables({
    required this.bio,
    required this.profileImageUrl,
  });
}
