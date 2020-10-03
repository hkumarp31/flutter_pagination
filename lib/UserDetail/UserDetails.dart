class UserDetails {

  String username;
  String userProfileImageUrl;
  int rating;
  int tournamentsPlayed;
  int tournamentsWon;
  int winPercentage;

  UserDetails({
    this.username,
    this.userProfileImageUrl,
    this.rating,
    this.tournamentsPlayed,
    this.tournamentsWon,
    this.winPercentage
  });

  factory UserDetails.fromJson(Map<String, dynamic> jsonString){
    return UserDetails(
      username: jsonString["userName"],
      userProfileImageUrl: jsonString["user_profil_image_url"],
      rating: jsonString["rating"],
      tournamentsPlayed: jsonString["tournaments_played"],
      tournamentsWon: jsonString["tournaments_won"],
      winPercentage: jsonString["win_percentage"]
    );
  }

  @override
  String toString() {
    return 'UserDetails{username: $username,'
        ' userProfileImageUrl: $userProfileImageUrl,'
        ' rating: $rating,'
        ' tournamentsPlayed: $tournamentsPlayed,'
        ' tournamentsWon: $tournamentsWon,'
        ' winPercentage: $winPercentage}';
  }
}