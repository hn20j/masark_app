# Basic Usage

```dart
ExampleConnector.instance.CreateUser(createUserVariables).execute();
ExampleConnector.instance.UpdateUser(updateUserVariables).execute();
ExampleConnector.instance.DeleteUser().execute();
ExampleConnector.instance.GetCurrentUser().execute();
ExampleConnector.instance.ListUsers().execute();
ExampleConnector.instance.CreatePath(createPathVariables).execute();
ExampleConnector.instance.UpdatePath(updatePathVariables).execute();
ExampleConnector.instance.DeletePath(deletePathVariables).execute();
ExampleConnector.instance.GetPath(getPathVariables).execute();
ExampleConnector.instance.ListMyPaths().execute();

```

## Optional Fields

Some operations may have optional fields. In these cases, the Flutter SDK exposes a builder method, and will have to be set separately.

Optional fields can be discovered based on classes that have `Optional` object types.

This is an example of a mutation with an optional field:

```dart
await ExampleConnector.instance.UpdateCollection({ ... })
.name(...)
.execute();
```

Note: the above example is a mutation, but the same logic applies to query operations as well. Additionally, `createMovie` is an example, and may not be available to the user.

