class Notice {
  String? title;
  String? content;
  String? name;
  String? registerDate;
  String? fileTag;


  /*
  private Long boardId;
	private Long boardNo;
	private Long moduleId;
	private Long logicalId;
	private Long parentId;
	private Long depth;
	private String title;
	private String content;
	private String pin;
	private Long hitCount;
	private String registerDate;
	private String modifyDate;
	private String startDate;
	private String endDate;
	private Long password;
	private String fileTag;
	private String memoTag;
	private String companyName;
	private String name;
	private String textType;
	private String noticeYn;
	private String companyId;

  * */

  Notice(
      { this.title,
        this.content,
        this.fileTag,
        this.name,
        this.registerDate
      });

      factory Notice.fromJson(Map<String, dynamic> json) {
        return Notice(
            title: json['title'],
            content: json['content'],
            fileTag: json['fileTag'],
            name: json['name'],
            registerDate: json['registerDate']);
      }
}
