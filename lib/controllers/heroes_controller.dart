import 'dart:developer';

import 'package:aqueduct/aqueduct.dart';
import 'package:heroes/heroes.dart';
import 'package:heroes/models/hero.dart';

class HeroesController extends ResourceController{

  final ManagedContext context;
  HeroesController(this.context);


  @Operation.get()
  Future<Response> getAllHeros({@Bind.query('name') String name}) async{
    final heroQuery= Query<Hero>(context);

    if(name!=null){
      heroQuery.where((h)=>h.name).contains(name,caseSensitive: false);
    }
    final heroes= await heroQuery.fetch();
    print(heroes);
    return Response.ok(heroes);
  }

  @Operation.get('id')
  Future<Response> getHeroById(@Bind.path('id') int id) async{
   final heroQuery=Query<Hero>(context)
                    ..where((h)=>h.id).equalTo(id);

   final hero= await heroQuery.fetchOne();

   if(hero==null){
     return Response.notFound();
   }

    return Response.ok(hero);
  }

  @Operation.post()
  Future<Response> createHero(@Bind.body(ignore: ['id']) Hero inputHero) async {
//    final hero= Hero()..read(await request.body.decode(),ignore: ['id']);
    final query= Query<Hero>(context)..values=inputHero;
    final insertedHero= await query.insert();

    return Response.ok(insertedHero);
  }

  @Operation.put('id')
  Future<Response> editHero(@Bind.path('id') int id) async{
    final hero= Hero()..read(await request.body.decode());
    final query= Query<Hero>(context)..where((h)=>h.id).equalTo(id)..values.name=hero.name;

    final result= await query.updateOne();

    return Response.ok(result);
  }

}