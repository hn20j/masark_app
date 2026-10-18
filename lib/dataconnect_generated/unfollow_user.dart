// ignore_for_file: non_constant_identifier_names

part of 'generated.dart';

class UnfollowUserVariablesBuilder {
  String followingId;

  final FirebaseDataConnect _dataConnect;
  UnfollowUserVariablesBuilder(
    this._dataConnect, {
    required this.followingId,
  });
  Deserializer<UnfollowUserData> dataDeserializer =
      (dynamic json) => UnfollowUserData.fromJson(jsonDecode(json));
  Serializer<UnfollowUserVariables> varsSerializer =
      (UnfollowUserVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UnfollowUserData, UnfollowUserVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UnfollowUserData, UnfollowUserVariables> ref() {
    UnfollowUserVariables vars = UnfollowUserVariables(
      followingId: followingId,
    );
    return _dataConnect.mutation(
        "UnfollowUser", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UnfollowUserFollowDelete {
  final String followerId;
  final String followingId;
  UnfollowUserFollowDelete.fromJson(dynamic json)
      : followerId = nativeFromJson<String>(json['followerId']),
        followingId = nativeFromJson<String>(json['followingId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UnfollowUserFollowDelete otherTyped =
        other as UnfollowUserFollowDelete;
    return followerId == otherTyped.followerId &&
        followingId == otherTyped.followingId;
  }

  @override
  int get hashCode =>
      Object.hashAll([followerId.hashCode, followingId.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['followerId'] = nativeToJson<String>(followerId);
    json['followingId'] = nativeToJson<String>(followingId);
    return json;
  }

  const UnfollowUserFollowDelete({
    required this.followerId,
    required this.followingId,
  });
}

@immutable
class UnfollowUserData {
  final UnfollowUserFollowDelete? follow_delete;
  UnfollowUserData.fromJson(dynamic json)
      : follow_delete = json['follow_delete'] == null
            ? null
            : UnfollowUserFollowDelete.fromJson(json['follow_delete']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UnfollowUserData otherTyped = other as UnfollowUserData;
    return follow_delete == otherTyped.follow_delete;
  }

  @override
  int get hashCode => follow_delete.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (follow_delete != null) {
      json['follow_delete'] = follow_delete!.toJson();
    }
    return json;
  }

  const UnfollowUserData({
    this.follow_delete,
  });
}

@immutable
class UnfollowUserVariables {
  final String followingId;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UnfollowUserVariables.fromJson(Map<String, dynamic> json)
      : followingId = nativeFromJson<String>(json['followingId']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final UnfollowUserVariables otherTyped = other as UnfollowUserVariables;
    return followingId == otherTyped.followingId;
  }

  @override
  int get hashCode => followingId.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['followingId'] = nativeToJson<String>(followingId);
    return json;
  }

  const UnfollowUserVariables({
    required this.followingId,
  });
}
