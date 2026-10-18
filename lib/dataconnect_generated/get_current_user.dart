part of 'generated.dart';

class GetCurrentUserVariablesBuilder {
  final FirebaseDataConnect _dataConnect;
  GetCurrentUserVariablesBuilder(
    this._dataConnect,
  );
  Deserializer<GetCurrentUserData> dataDeserializer =
      (dynamic json) => GetCurrentUserData.fromJson(jsonDecode(json));

  Future<QueryResult<GetCurrentUserData, void>> execute(
      {QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetCurrentUserData, void> ref() {
    return _dataConnect.query(
        "GetCurrentUser", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetCurrentUserUser {
  final String username;
  final String email;
  final String? bio;
  final String? profileImageUrl;
  GetCurrentUserUser.fromJson(dynamic json)
      : username = nativeFromJson<String>(json['username']),
        email = nativeFromJson<String>(json['email']),
        bio = json['bio'] == null ? null : nativeFromJson<String>(json['bio']),
        profileImageUrl = json['profileImageUrl'] == null
            ? null
            : nativeFromJson<String>(json['profileImageUrl']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetCurrentUserUser otherTyped = other as GetCurrentUserUser;
    return username == otherTyped.username &&
        email == otherTyped.email &&
        bio == otherTyped.bio &&
        profileImageUrl == otherTyped.profileImageUrl;
  }

  @override
  int get hashCode => Object.hashAll([
        username.hashCode,
        email.hashCode,
        bio.hashCode,
        profileImageUrl.hashCode
      ]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['username'] = nativeToJson<String>(username);
    json['email'] = nativeToJson<String>(email);
    if (bio != null) {
      json['bio'] = nativeToJson<String?>(bio);
    }
    if (profileImageUrl != null) {
      json['profileImageUrl'] = nativeToJson<String?>(profileImageUrl);
    }
    return json;
  }

  const GetCurrentUserUser({
    required this.username,
    required this.email,
    this.bio,
    this.profileImageUrl,
  });
}

@immutable
class GetCurrentUserData {
  final GetCurrentUserUser? user;
  GetCurrentUserData.fromJson(dynamic json)
      : user = json['user'] == null
            ? null
            : GetCurrentUserUser.fromJson(json['user']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final GetCurrentUserData otherTyped = other as GetCurrentUserData;
    return user == otherTyped.user;
  }

  @override
  int get hashCode => user.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (user != null) {
      json['user'] = user!.toJson();
    }
    return json;
  }

  const GetCurrentUserData({
    this.user,
  });
}
