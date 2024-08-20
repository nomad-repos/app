
import 'package:shared_preferences/shared_preferences.dart';

import 'key_value_storage_services.dart';

class KeyValueStorageImpl extends KeyValueStorageServices{
  
  @override
  Future<T?> getValue<T>(String key) async {
    //Crep la instancia de sharedPreferences (ver documentacion)
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    //Segun el tipo de dato lo que devuelvo, si el tipo de dato no esta lanza error
    switch(T){
      case String:
        return prefs.getString(key) as T?;
      
      default: 
        throw UnimplementedError('GET no esta implementado para el tipo de dato ${ T.runtimeType }');
    }
  }

  //Misma idea que el getValue
  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    switch(T){
      case String:
        prefs.setString(key,value as String);
        break;
      
      default: 
        throw UnimplementedError('SET no esta implementado para el tipo de dato ${ T.runtimeType }');
    }
  }

  //Este es mas sencillo porque la key siempre es string.
  @override
  Future<bool> deleteKeyValue(String key) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}

//Centralizo el sharedPreferences por si algun dia lo tenemos que cambiar