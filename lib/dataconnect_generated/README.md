# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetCurrentUser
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getCurrentUser().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetCurrentUserData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getCurrentUser();
GetCurrentUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getCurrentUser().ref();
ref.execute();

ref.subscribe(...);
```


### ListUsers
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.listUsers().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListUsersData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listUsers();
ListUsersData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.listUsers().ref();
ref.execute();

ref.subscribe(...);
```


### GetPath
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.getPath(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetPathData, GetPathVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getPath(
  id: id,
);
GetPathData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.getPath(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListMyPaths
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.listMyPaths().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListMyPathsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listMyPaths();
ListMyPathsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.listMyPaths().ref();
ref.execute();

ref.subscribe(...);
```


### GetWaypoint
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.getWaypoint(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetWaypointData, GetWaypointVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getWaypoint(
  id: id,
);
GetWaypointData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.getWaypoint(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListPathWaypoints
#### Required Arguments
```dart
String pathId = ...;
ExampleConnector.instance.listPathWaypoints(
  pathId: pathId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListPathWaypointsData, ListPathWaypointsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listPathWaypoints(
  pathId: pathId,
);
ListPathWaypointsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String pathId = ...;

final ref = ExampleConnector.instance.listPathWaypoints(
  pathId: pathId,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetPin
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.getPin(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetPinData, GetPinVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getPin(
  id: id,
);
GetPinData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.getPin(
  id: id,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListMyPins
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.listMyPins().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListMyPinsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listMyPins();
ListMyPinsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.listMyPins().ref();
ref.execute();

ref.subscribe(...);
```


### ListPathComments
#### Required Arguments
```dart
String pathId = ...;
ExampleConnector.instance.listPathComments(
  pathId: pathId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListPathCommentsData, ListPathCommentsVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listPathComments(
  pathId: pathId,
);
ListPathCommentsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String pathId = ...;

final ref = ExampleConnector.instance.listPathComments(
  pathId: pathId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ListMyCollections
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.listMyCollections().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListMyCollectionsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.listMyCollections();
ListMyCollectionsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.listMyCollections().ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreateUser
#### Required Arguments
```dart
String username = ...;
String email = ...;
ExampleConnector.instance.createUser(
  username: username,
  email: email,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateUser, we created `CreateUserBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateUserVariablesBuilder {
  ...
   CreateUserVariablesBuilder bio(String? t) {
   _bio.value = t;
   return this;
  }
  CreateUserVariablesBuilder profileImageUrl(String? t) {
   _profileImageUrl.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createUser(
  username: username,
  email: email,
)
.bio(bio)
.profileImageUrl(profileImageUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateUserData, CreateUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createUser(
  username: username,
  email: email,
);
CreateUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String username = ...;
String email = ...;

final ref = ExampleConnector.instance.createUser(
  username: username,
  email: email,
).ref();
ref.execute();
```


### UpdateUser
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.updateUser().execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateUser, we created `UpdateUserBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateUserVariablesBuilder {
  ...
 
  UpdateUserVariablesBuilder bio(String? t) {
   _bio.value = t;
   return this;
  }
  UpdateUserVariablesBuilder profileImageUrl(String? t) {
   _profileImageUrl.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.updateUser()
.bio(bio)
.profileImageUrl(profileImageUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateUserData, UpdateUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateUser();
UpdateUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.updateUser().ref();
ref.execute();
```


### DeleteUser
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.deleteUser().execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteUserData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteUser();
DeleteUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.deleteUser().ref();
ref.execute();
```


### CreatePath
#### Required Arguments
```dart
String title = ...;
String startCoordinates = ...;
String endCoordinates = ...;
ExampleConnector.instance.createPath(
  title: title,
  startCoordinates: startCoordinates,
  endCoordinates: endCoordinates,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreatePath, we created `CreatePathBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreatePathVariablesBuilder {
  ...
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

  ...
}
ExampleConnector.instance.createPath(
  title: title,
  startCoordinates: startCoordinates,
  endCoordinates: endCoordinates,
)
.description(description)
.tags(tags)
.isPublic(isPublic)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreatePathData, CreatePathVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createPath(
  title: title,
  startCoordinates: startCoordinates,
  endCoordinates: endCoordinates,
);
CreatePathData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String title = ...;
String startCoordinates = ...;
String endCoordinates = ...;

final ref = ExampleConnector.instance.createPath(
  title: title,
  startCoordinates: startCoordinates,
  endCoordinates: endCoordinates,
).ref();
ref.execute();
```


### UpdatePath
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.updatePath(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdatePath, we created `UpdatePathBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdatePathVariablesBuilder {
  ...
   UpdatePathVariablesBuilder title(String? t) {
   _title.value = t;
   return this;
  }
  UpdatePathVariablesBuilder description(String? t) {
   _description.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.updatePath(
  id: id,
)
.title(title)
.description(description)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdatePathData, UpdatePathVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updatePath(
  id: id,
);
UpdatePathData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.updatePath(
  id: id,
).ref();
ref.execute();
```


### DeletePath
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deletePath(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeletePathData, DeletePathVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deletePath(
  id: id,
);
DeletePathData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deletePath(
  id: id,
).ref();
ref.execute();
```


### CreateWaypoint
#### Required Arguments
```dart
String pathId = ...;
String coordinates = ...;
int orderIndex = ...;
ExampleConnector.instance.createWaypoint(
  pathId: pathId,
  coordinates: coordinates,
  orderIndex: orderIndex,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateWaypoint, we created `CreateWaypointBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateWaypointVariablesBuilder {
  ...
   CreateWaypointVariablesBuilder note(String? t) {
   _note.value = t;
   return this;
  }
  CreateWaypointVariablesBuilder photoUrl(String? t) {
   _photoUrl.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createWaypoint(
  pathId: pathId,
  coordinates: coordinates,
  orderIndex: orderIndex,
)
.note(note)
.photoUrl(photoUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateWaypointData, CreateWaypointVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createWaypoint(
  pathId: pathId,
  coordinates: coordinates,
  orderIndex: orderIndex,
);
CreateWaypointData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String pathId = ...;
String coordinates = ...;
int orderIndex = ...;

final ref = ExampleConnector.instance.createWaypoint(
  pathId: pathId,
  coordinates: coordinates,
  orderIndex: orderIndex,
).ref();
ref.execute();
```


### UpdateWaypoint
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.updateWaypoint(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateWaypoint, we created `UpdateWaypointBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateWaypointVariablesBuilder {
  ...
   UpdateWaypointVariablesBuilder note(String? t) {
   _note.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.updateWaypoint(
  id: id,
)
.note(note)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateWaypointData, UpdateWaypointVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateWaypoint(
  id: id,
);
UpdateWaypointData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.updateWaypoint(
  id: id,
).ref();
ref.execute();
```


### DeleteWaypoint
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteWaypoint(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteWaypointData, DeleteWaypointVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteWaypoint(
  id: id,
);
DeleteWaypointData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteWaypoint(
  id: id,
).ref();
ref.execute();
```


### CreatePin
#### Required Arguments
```dart
String coordinates = ...;
String category = ...;
ExampleConnector.instance.createPin(
  coordinates: coordinates,
  category: category,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreatePin, we created `CreatePinBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreatePinVariablesBuilder {
  ...
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

  ...
}
ExampleConnector.instance.createPin(
  coordinates: coordinates,
  category: category,
)
.title(title)
.description(description)
.photoUrl(photoUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreatePinData, CreatePinVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createPin(
  coordinates: coordinates,
  category: category,
);
CreatePinData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String coordinates = ...;
String category = ...;

final ref = ExampleConnector.instance.createPin(
  coordinates: coordinates,
  category: category,
).ref();
ref.execute();
```


### UpdatePin
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.updatePin(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdatePin, we created `UpdatePinBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdatePinVariablesBuilder {
  ...
   UpdatePinVariablesBuilder title(String? t) {
   _title.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.updatePin(
  id: id,
)
.title(title)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdatePinData, UpdatePinVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updatePin(
  id: id,
);
UpdatePinData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.updatePin(
  id: id,
).ref();
ref.execute();
```


### DeletePin
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deletePin(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeletePinData, DeletePinVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deletePin(
  id: id,
);
DeletePinData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deletePin(
  id: id,
).ref();
ref.execute();
```


### CreateComment
#### Required Arguments
```dart
String pathId = ...;
String text = ...;
ExampleConnector.instance.createComment(
  pathId: pathId,
  text: text,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateCommentData, CreateCommentVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createComment(
  pathId: pathId,
  text: text,
);
CreateCommentData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String pathId = ...;
String text = ...;

final ref = ExampleConnector.instance.createComment(
  pathId: pathId,
  text: text,
).ref();
ref.execute();
```


### DeleteComment
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteComment(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteCommentData, DeleteCommentVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteComment(
  id: id,
);
DeleteCommentData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteComment(
  id: id,
).ref();
ref.execute();
```


### CreateCollection
#### Required Arguments
```dart
String name = ...;
ExampleConnector.instance.createCollection(
  name: name,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateCollection, we created `CreateCollectionBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateCollectionVariablesBuilder {
  ...
   CreateCollectionVariablesBuilder description(String? t) {
   _description.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.createCollection(
  name: name,
)
.description(description)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateCollectionData, CreateCollectionVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.createCollection(
  name: name,
);
CreateCollectionData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String name = ...;

final ref = ExampleConnector.instance.createCollection(
  name: name,
).ref();
ref.execute();
```


### UpdateCollection
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.updateCollection(
  id: id,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpdateCollection, we created `UpdateCollectionBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpdateCollectionVariablesBuilder {
  ...
   UpdateCollectionVariablesBuilder name(String? t) {
   _name.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.updateCollection(
  id: id,
)
.name(name)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpdateCollectionData, UpdateCollectionVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.updateCollection(
  id: id,
);
UpdateCollectionData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.updateCollection(
  id: id,
).ref();
ref.execute();
```


### DeleteCollection
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteCollection(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteCollectionData, DeleteCollectionVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteCollection(
  id: id,
);
DeleteCollectionData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteCollection(
  id: id,
).ref();
ref.execute();
```


### SavePath
#### Required Arguments
```dart
String collectionId = ...;
String pathId = ...;
ExampleConnector.instance.savePath(
  collectionId: collectionId,
  pathId: pathId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<SavePathData, SavePathVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.savePath(
  collectionId: collectionId,
  pathId: pathId,
);
SavePathData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String collectionId = ...;
String pathId = ...;

final ref = ExampleConnector.instance.savePath(
  collectionId: collectionId,
  pathId: pathId,
).ref();
ref.execute();
```


### RemoveSavedPath
#### Required Arguments
```dart
String collectionId = ...;
String pathId = ...;
ExampleConnector.instance.removeSavedPath(
  collectionId: collectionId,
  pathId: pathId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<RemoveSavedPathData, RemoveSavedPathVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.removeSavedPath(
  collectionId: collectionId,
  pathId: pathId,
);
RemoveSavedPathData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String collectionId = ...;
String pathId = ...;

final ref = ExampleConnector.instance.removeSavedPath(
  collectionId: collectionId,
  pathId: pathId,
).ref();
ref.execute();
```


### FollowUser
#### Required Arguments
```dart
String followingId = ...;
ExampleConnector.instance.followUser(
  followingId: followingId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<FollowUserData, FollowUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.followUser(
  followingId: followingId,
);
FollowUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String followingId = ...;

final ref = ExampleConnector.instance.followUser(
  followingId: followingId,
).ref();
ref.execute();
```


### UnfollowUser
#### Required Arguments
```dart
String followingId = ...;
ExampleConnector.instance.unfollowUser(
  followingId: followingId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UnfollowUserData, UnfollowUserVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.unfollowUser(
  followingId: followingId,
);
UnfollowUserData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String followingId = ...;

final ref = ExampleConnector.instance.unfollowUser(
  followingId: followingId,
).ref();
ref.execute();
```

