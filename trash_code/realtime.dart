// void realTime() async {
//   MongoDBProvider mongoDBProvider = MongoDBProvider(localConnLink);
//   MemoryDBProvider memoryDBProvider = MemoryDBProvider({});

//   DBSettings dbSettings = DBSettings(
//     mongoDBProvider: mongoDBProvider,
//     memoryDBProvider: memoryDBProvider,
//   );
//   UserDataSettings userDataSettings = UserDataSettings();
//   AuthSettings authSettings = AuthSettings(jwtSecretKey: 'jwtSecretKey');
//   App app = App(
//     dbSettings: dbSettings,
//     authSettings: authSettings,
//     userDataSettings: userDataSettings,
//   );

//   DbService dbService = DbService(app);
//   await dbService.connectToDb();
//   AuthService authService = AuthService(MongoDbAuthProvider(app, dbService));
//   UserDataService userDataService = UserDataService(authService);

//   var pipeline = [
//     {
//       '\$match': {'operationType': 'insert'}
//     },
//     {
//       '\$project': {'fullDocument': 1}
//     }
//   ];

//   dbService.mongoDbController
//       .collection(authSettings.collectionName)
//       .watch(pipeline)
//       .listen((event) {
//     Map<String, dynamic> document = event.fullDocument;
//     bool isDelete = event.isDelete;
//     bool isDrop = event.isDrop;
//     bool isDropDatabase = event.isDropDatabase;
//     bool isInsert = event.isInsert;
//     bool isInvalidate = event.isInvalidate;
//     bool isRename = event.isRename;
//     bool isReplace = event.isReplace;
//     bool isUpdate = event.isUpdate;
//     Map<String, dynamic> id = event.id;

//     print(event);
//   });

//   await authService.registerUser(
//     email: Uuid().v4(),
//     password: 'password',
//     userData: {
//       'name': 'Osama Mohammed',
//       'age': 16,
//       'skills': 'Null',
//     },
//   );
// }
