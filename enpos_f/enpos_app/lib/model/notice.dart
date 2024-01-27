class Notice {
	
	String? title;
  String? content;
  int updateDate;
  String? updateUserId;
	
	Notice({this.title, this.content, required this.updateDate, this.updateUserId});

	factory Notice.fromJson(Map<String, dynamic> json) {
		return Notice(title: json['title'], content: json['content'], updateDate: json['update_date'],updateUserId: json['update_user_id']);
	}        
}
