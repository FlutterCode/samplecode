import 'dart:convert';

import 'package:http/http.dart' as http;

List searchedList = [];
int currentIndex = 0;
String kUrl = "",
    checker,
    image =
        'https://reactnativecode.com/wp-content/uploads/2018/02/Default_Image_Thumbnail.png',
    title = "",
    artist = "";

Future<List> fetchSongsList(String id) async {
  String searchUrl = "http://pushtiras.co.in/api/audios?category_id=" + id;
  var res = await http.get(searchUrl);
  var resEdited = (res.body);
  print("data88888$resEdited");
  var getMain = json.decode(resEdited);

  searchedList = getMain;
  for (int i = 0; i < searchedList.length; i++) {
    searchedList[i]['title'] = searchedList[i]['title'].toString();
  }
  kUrl = searchedList[currentIndex]['audio'];
  image = searchedList[currentIndex]['image'];
  artist = searchedList[currentIndex]['title'];
  title = searchedList[currentIndex]['title'];
  return searchedList;
}

void getSongDetails(int index) {
  currentIndex = index;
  kUrl = searchedList[index]['audio'];
  image = searchedList[index]['image'];
  artist = searchedList[index]['title'];
  title = searchedList[index]['title'];

  print('$index - $kUrl $title');
}
