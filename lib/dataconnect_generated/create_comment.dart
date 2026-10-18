// ignore_for_file: non_constant_identifier_names

part of 'generated.dart';

class CreateCommentVariablesBuilder {
  String pathId;
  String text;

  final FirebaseDataConnect _dataConnect;
  CreateCommentVariablesBuilder(
    this._dataConnect, {
    required this.pathId,
    required this.text,
  });
  Deserializer<CreateCommentData> dataDeserializer =
      (dynamic json) => CreateCommentData.fromJson(jsonDecode(json));
  Serializer<CreateCommentVariables> varsSerializer =
      (CreateCommentVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateCommentData, CreateCommentVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateCommentData, CreateCommentVariables> ref() {
    CreateCommentVariables vars = CreateCommentVariables(
      pathId: pathId,
      text: text,
    );
    return _dataConnect.mutation(
        "CreateComment", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateCommentCommentInsert {
  final String id;
  CreateCommentCommentInsert.fromJson(dynamic json)
      : id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCommentCommentInsert otherTyped =
        other as CreateCommentCommentInsert;
    return id == otherTyped.id;
  }

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  const CreateCommentCommentInsert({
    required this.id,
  });
}

@immutable
class CreateCommentData {
  final CreateCommentCommentInsert comment_insert;
  CreateCommentData.fromJson(dynamic json)
      : comment_insert =
            CreateCommentCommentInsert.fromJson(json['comment_insert']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCommentData otherTyped = other as CreateCommentData;
    return comment_insert == otherTyped.comment_insert;
  }

  @override
  int get hashCode => comment_insert.hashCode;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['comment_insert'] = comment_insert.toJson();
    return json;
  }

  const CreateCommentData({
    required this.comment_insert,
  });
}

@immutable
class CreateCommentVariables {
  final String pathId;
  final String text;
  @Deprecated(
      'fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateCommentVariables.fromJson(Map<String, dynamic> json)
      : pathId = nativeFromJson<String>(json['pathId']),
        text = nativeFromJson<String>(json['text']);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    final CreateCommentVariables otherTyped = other as CreateCommentVariables;
    return pathId == otherTyped.pathId && text == otherTyped.text;
  }

  @override
  int get hashCode => Object.hashAll([pathId.hashCode, text.hashCode]);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['pathId'] = nativeToJson<String>(pathId);
    json['text'] = nativeToJson<String>(text);
    return json;
  }

  const CreateCommentVariables({
    required this.pathId,
    required this.text,
  });
}
