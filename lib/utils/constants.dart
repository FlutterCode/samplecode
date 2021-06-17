import 'package:milanproject/entity/category.dart';

List<Category> getCategoryList() {
  List<Category> _catList = List();
  _catList.add(new Category("Videos", "assets/images/ic_video.png"));
  _catList.add(new Category("Granth", "assets/images/ic_granth.png"));
  _catList.add(new Category("Audio", "assets/images/ic_audio.png"));
  _catList.add(new Category("Kirtan", "assets/images/ic_kirtan.png"));
  _catList.add(new Category("Utsav", "assets/images/ic_utsav.png"));
  _catList.add(new Category("Photos", "assets/images/ic_photos.png"));
  _catList.add(new Category("Varta Prasang", "assets/images/ic_story.png"));
  _catList.add(new Category("Bethakji", "assets/images/ic_bethakji.png"));
  _catList.add(new Category("Haveli", "assets/images/ic_haveli.png"));
  _catList.add(new Category("Recipes", "assets/images/ic_receipe.png"));
  _catList.add(new Category("Tippani", "assets/images/ic_tipani.png"));
  _catList.add(new Category("Shringar Vastra", "assets/images/vastra.png"));
  _catList.add(new Category("Quiz", "assets/images/ic_quiz.png"));
  _catList.add(new Category("Satsang News", "assets/images/ic_news.png"));
  _catList.add(new Category("Dictionary", "assets/images/ic_dictionary.png"));
  _catList.add(new Category("General Info", "assets/images/ic_aboutus.png"));
  _catList.add(new Category("Seva Pranali", "assets/images/seva.png"));
  _catList.add(new Category("About Us", "assets/images/ic_aboutus.png"));

  return _catList;
}

String getAnswer(int answer) {
  String answerText = '';
  switch (answer) {
    case 1:
      {
        answerText = 'option1';
      }
      break;
    case 2:
      {
        answerText = 'option2';
      }
      break;
    case 3:
      {
        answerText = 'option3';
      }
      break;
    case 4:
      {
        answerText = 'option4';
      }
      break;
  }
  return answerText;
}
