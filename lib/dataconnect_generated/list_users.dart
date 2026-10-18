part of 'generated.dart';

class ListUsersVariablesBuilder {
  final FirebaseDataConnect _dataConnect;
  ListUsersVariablesBuilder(
    this._dataConnect,
  );
  Deserializer<ListUsersData> dataDeserializer =
      (dynamic json) => ListUsersData.fromJson(jsonDecode(json));

  Future<QueryResult<ListUsersData, void>> execute(
      {QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListUsersData, void> ref() {
    return _dataConnect.query(
        "ListUsers", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListUsersUsers {
  final String username;
  final String? profileImageUrl;
  ListUsersUsers.fromJson(dynamic json)
      : username = nativeFromJson<String>(json['username']),
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

    final ListUsersUsers otherTyped = other as ListUsersUsers;
    return username == otherTyped.username &&
        profileImageUrl == otherTyped.profileImageUrl;
  }

  @override
  int get hashCode =>
      Object.hashAll([username.hashCode, profileImageUrl.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['username'] = nativeToJson<String>(username);
    if (profileImageUrl != null) {
      json['profileImageUrl'] = nativeToJson<String?>(profileImageUrl);
    }
    return json;
  }

  const ListUsersUsers({
    required this.username,
    this.profileImageUrl,
  });
}

@immutable
class ListUsersData {
  final List<ListUsersUsers> users;
  ListUsersData.fromJson(dynamic json)
      : users = (json['users'] as List<dynamic>)
            .map((e) => ListUsersUsers.fromJson(e))
            .toList();
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final ListUsersData otherTyped = other as ListUsersData;
    return users == otherTyped.users;
  }

  @override
  int get hashCode => users.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['users'] = users.map((e) => e.toJson()).toList();
    return json;
  }

  const ListUsersData({
    required this.users,
  });
}
