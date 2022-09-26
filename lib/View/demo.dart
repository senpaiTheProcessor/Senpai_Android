import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

   List passions = [{"name": "swimming"}, {"name": "Politics"}, {"name": "Gamer"} ];

  List sortListPrfile(List profiles) {
    //profiles is a list of result server
    List _items = []; // It will be returned eventually
    List _noItemCommon = []; //Items that are not common
    for (var profile in profiles) {
      for (var passion in passions) {
        if (profile["passions"][0]["name"] == passion['name']) {
          _items.add(profile);
        } else {
          _noItemCommon.add(profile);
        }
      }
    }
    _items.addAll(_noItemCommon);
    print("dd$_items");
    return _items;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  
  }
}