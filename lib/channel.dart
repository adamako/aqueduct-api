import 'package:heroes/controllers/heroes_controller.dart';

import 'heroes.dart';

class HeroesChannel extends ApplicationChannel {

  ManagedContext context;

  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final config= HeroConfig(options.configurationFilePath);
    final dataModel=ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore= PostgreSQLPersistentStore.fromConnectionInfo(
      config.database.username,
      config.database.password,
      config.database.host,
      config.database.port,
      config.database.databaseName
    );


    context= ManagedContext(dataModel,persistentStore);
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route('/heroes/[:id]')
    .link(()=>HeroesController(context)
    );

    router
      .route("/")
      .linkFunction((request) async {
        return Response.ok('Hello Adamaa');
      });

    return router;
  }
}

class HeroConfig extends Configuration{
  HeroConfig(String path): super.fromFile(File(path));

  DatabaseConfiguration database;
}