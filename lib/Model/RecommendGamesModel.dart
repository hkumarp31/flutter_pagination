class RecommendGames{

  String cursorPosition;
  List<RecommendGamesModel> recommendGamesList;

  RecommendGames({
    this.cursorPosition,
    this.recommendGamesList
  });

  factory RecommendGames.fromJson(Map<String, dynamic> jsonString){
    List<dynamic> responseList = jsonString["data"]["tournaments"] as List;
    return RecommendGames(
      cursorPosition: jsonString["data"]["cursor"],
      recommendGamesList: responseList.map((e) => RecommendGamesModel.fromJson(e)).toList()
    );
  }

  @override
  String toString() {
    return 'RecommendGames{cursorPosition: $cursorPosition,'
        ' recommendGamesList: $recommendGamesList}';
  }
}

class RecommendGamesModel {

  String tournamentName;
  String gameCoverUrl;
  String gameName;

  RecommendGamesModel({
    this.tournamentName,
    this.gameCoverUrl,
    this.gameName
  });

  factory RecommendGamesModel.fromJson(Map<String, dynamic> jsonString){
    return RecommendGamesModel(
      tournamentName: jsonString["name"],
      gameCoverUrl: jsonString["cover_url"],
      gameName: jsonString["game_name"]
    );
  }

  @override
  String toString() {
    return 'RecommendGamesModel{'
        'tournamentName: $tournamentName,'
        ' gameCoverUrl: $gameCoverUrl,'
        ' gameName: $gameName}';
  }
}