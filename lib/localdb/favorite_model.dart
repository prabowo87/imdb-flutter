class FavoriteModel{
   int? id;
   String? imdbID;
   String? Title;
   String? Year;
   String? Poster;
   String? Type;
  FavoriteModel(this.id,this.imdbID,this.Title,this.Year,this.Poster,this.Type);


  FavoriteModel.fromMap(Map<String, dynamic> json) {
    this.id = json["id"];
    this.imdbID = json["imdbID"];
    this.Title = json["Title"];
    this.Year = json["Year"];
    this.Poster = json["Poster"];
    this.Type = json["Type"];


  }
  //getter dan setter (mengambil dan mengisi data kedalam object)
  // getter
  int? get getId => id;
  String? get getImdbID => imdbID;
  String? get getTitle => Title;
  String? get getYear => Year;
  String? get getPoster => Poster;
  String? get getType => Type;


  // setter
  set setId(int value) {
    id = value;
  }
  set setImdbID(String value) {
    imdbID = value;
  }
  set setTitle(String value) {
    Title = value;
  }
   set setYear(String value) {
     Year = value;
   }
   set setPoster(String value) {
     Poster = value;
   }
   set setType(String value) {
     Type = value;
   }

  // konversi dari Contact ke Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this.id;
    map['imdbID'] = this.imdbID;
    map['Title'] = this.Title;
    map['Year'] = this.Year;
    map['Poster'] = this.Poster;
    map['Type'] = this.Type;


    return map;
  }
}