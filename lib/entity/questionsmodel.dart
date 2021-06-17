class QuestionsModel {
  int id;
  String name;
  String categoryId;
  String question;
  String option1;
  String option2;
  String option3;
  String option4;
  String answer;
  String status;

  QuestionsModel(
      {this.id,
      this.name,
      this.categoryId,
      this.question,
      this.option1,
      this.option2,
      this.option3,
      this.option4,
      this.answer,
      this.status});

  QuestionsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    question = json['question'];
    option1 = json['option1'];
    option2 = json['option2'];
    option3 = json['option3'];
    option4 = json['option4'];
    answer = json['answer'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['question'] = this.question;
    data['option1'] = this.option1;
    data['option2'] = this.option2;
    data['option3'] = this.option3;
    data['option4'] = this.option4;
    data['answer'] = this.answer;
    data['status'] = this.status;
    return data;
  }
}
