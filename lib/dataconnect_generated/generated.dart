library dataconnect_generated;

import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'create_user.dart';

part 'update_user.dart';

part 'delete_user.dart';

part 'get_current_user.dart';

part 'list_users.dart';

part 'create_path.dart';

part 'update_path.dart';

part 'delete_path.dart';

part 'get_path.dart';

part 'list_my_paths.dart';

part 'create_waypoint.dart';

part 'update_waypoint.dart';

part 'delete_waypoint.dart';

part 'get_waypoint.dart';

part 'list_path_waypoints.dart';

part 'create_pin.dart';

part 'update_pin.dart';

part 'delete_pin.dart';

part 'get_pin.dart';

part 'list_my_pins.dart';

part 'create_comment.dart';

part 'delete_comment.dart';

part 'list_path_comments.dart';

part 'create_collection.dart';

part 'update_collection.dart';

part 'delete_collection.dart';

part 'list_my_collections.dart';

part 'save_path.dart';

part 'remove_saved_path.dart';

part 'follow_user.dart';

part 'unfollow_user.dart';

class ExampleConnector {
  CreateUserVariablesBuilder createUser({
    required String username,
    required String email,
  }) {
    return CreateUserVariablesBuilder(
      dataConnect,
      username: username,
      email: email,
    );
  }

  UpdateUserVariablesBuilder updateUser() {
    return UpdateUserVariablesBuilder(
      dataConnect,
    );
  }

  DeleteUserVariablesBuilder deleteUser() {
    return DeleteUserVariablesBuilder(
      dataConnect,
    );
  }

  GetCurrentUserVariablesBuilder getCurrentUser() {
    return GetCurrentUserVariablesBuilder(
      dataConnect,
    );
  }

  ListUsersVariablesBuilder listUsers() {
    return ListUsersVariablesBuilder(
      dataConnect,
    );
  }

  CreatePathVariablesBuilder createPath({
    required String title,
    required String startCoordinates,
    required String endCoordinates,
  }) {
    return CreatePathVariablesBuilder(
      dataConnect,
      title: title,
      startCoordinates: startCoordinates,
      endCoordinates: endCoordinates,
    );
  }

  UpdatePathVariablesBuilder updatePath({
    required String id,
  }) {
    return UpdatePathVariablesBuilder(
      dataConnect,
      id: id,
    );
  }

  DeletePathVariablesBuilder deletePath({
    required String id,
  }) {
    return DeletePathVariablesBuilder(
      dataConnect,
      id: id,
    );
  }

  GetPathVariablesBuilder getPath({
    required String id,
  }) {
    return GetPathVariablesBuilder(
      dataConnect,
      id: id,
    );
  }

  ListMyPathsVariablesBuilder listMyPaths() {
    return ListMyPathsVariablesBuilder(
      dataConnect,
    );
  }

  CreateWaypointVariablesBuilder createWaypoint({
    required String pathId,
    required String coordinates,
    required int orderIndex,
  }) {
    return CreateWaypointVariablesBuilder(
      dataConnect,
      pathId: pathId,
      coordinates: coordinates,
      orderIndex: orderIndex,
    );
  }

  UpdateWaypointVariablesBuilder updateWaypoint({
    required String id,
  }) {
    return UpdateWaypointVariablesBuilder(
      dataConnect,
      id: id,
    );
  }

  DeleteWaypointVariablesBuilder deleteWaypoint({
    required String id,
  }) {
    return DeleteWaypointVariablesBuilder(
      dataConnect,
      id: id,
    );
  }

  GetWaypointVariablesBuilder getWaypoint({
    required String id,
  }) {
    return GetWaypointVariablesBuilder(
      dataConnect,
      id: id,
    );
  }

  ListPathWaypointsVariablesBuilder listPathWaypoints({
    required String pathId,
  }) {
    return ListPathWaypointsVariablesBuilder(
      dataConnect,
      pathId: pathId,
    );
  }

  CreatePinVariablesBuilder createPin({
    required String coordinates,
    required String category,
  }) {
    return CreatePinVariablesBuilder(
      dataConnect,
      coordinates: coordinates,
      category: category,
    );
  }

  UpdatePinVariablesBuilder updatePin({
    required String id,
  }) {
    return UpdatePinVariablesBuilder(
      dataConnect,
      id: id,
    );
  }

  DeletePinVariablesBuilder deletePin({
    required String id,
  }) {
    return DeletePinVariablesBuilder(
      dataConnect,
      id: id,
    );
  }

  GetPinVariablesBuilder getPin({
    required String id,
  }) {
    return GetPinVariablesBuilder(
      dataConnect,
      id: id,
    );
  }

  ListMyPinsVariablesBuilder listMyPins() {
    return ListMyPinsVariablesBuilder(
      dataConnect,
    );
  }

  CreateCommentVariablesBuilder createComment({
    required String pathId,
    required String text,
  }) {
    return CreateCommentVariablesBuilder(
      dataConnect,
      pathId: pathId,
      text: text,
    );
  }

  DeleteCommentVariablesBuilder deleteComment({
    required String id,
  }) {
    return DeleteCommentVariablesBuilder(
      dataConnect,
      id: id,
    );
  }

  ListPathCommentsVariablesBuilder listPathComments({
    required String pathId,
  }) {
    return ListPathCommentsVariablesBuilder(
      dataConnect,
      pathId: pathId,
    );
  }

  CreateCollectionVariablesBuilder createCollection({
    required String name,
  }) {
    return CreateCollectionVariablesBuilder(
      dataConnect,
      name: name,
    );
  }

  UpdateCollectionVariablesBuilder updateCollection({
    required String id,
  }) {
    return UpdateCollectionVariablesBuilder(
      dataConnect,
      id: id,
    );
  }

  DeleteCollectionVariablesBuilder deleteCollection({
    required String id,
  }) {
    return DeleteCollectionVariablesBuilder(
      dataConnect,
      id: id,
    );
  }

  ListMyCollectionsVariablesBuilder listMyCollections() {
    return ListMyCollectionsVariablesBuilder(
      dataConnect,
    );
  }

  SavePathVariablesBuilder savePath({
    required String collectionId,
    required String pathId,
  }) {
    return SavePathVariablesBuilder(
      dataConnect,
      collectionId: collectionId,
      pathId: pathId,
    );
  }

  RemoveSavedPathVariablesBuilder removeSavedPath({
    required String collectionId,
    required String pathId,
  }) {
    return RemoveSavedPathVariablesBuilder(
      dataConnect,
      collectionId: collectionId,
      pathId: pathId,
    );
  }

  FollowUserVariablesBuilder followUser({
    required String followingId,
  }) {
    return FollowUserVariablesBuilder(
      dataConnect,
      followingId: followingId,
    );
  }

  UnfollowUserVariablesBuilder unfollowUser({
    required String followingId,
  }) {
    return UnfollowUserVariablesBuilder(
      dataConnect,
      followingId: followingId,
    );
  }

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'europe-west1',
    'example',
    'masarakapp',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    CacheSettings cacheSettings = CacheSettings(
      maxAge: const Duration(milliseconds: 0),
      storage: CacheStorage.persistent,
    );

    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            cacheSettings: cacheSettings,
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
