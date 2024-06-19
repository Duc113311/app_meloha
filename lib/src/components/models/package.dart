class Package {
  String? name; // name of the subscription
  bool isNameRequired = true; // whether the name is required
  bool isNameUnique = true; // whether the name should be unique
  bool isNameIndexed = true; // whether the name should be indexed

  String? type; // type of subscription
  bool isTypeRequired = true; // whether the type is required
  bool isTypeIndexed = true; // whether the type should be indexed

  String? description; // description of subscription
  bool isDescriptionIndexed = true; // whether the description should be indexed

  bool turnOffAds = false; // Hide ads
  bool ctrlProfile = false; // Control your profile
  bool ctrlWhoSeeYou = false; // Control who sees you
  bool ctrlWhoYouSee = false; // Control who you see
  bool passportAnyWhere = false; // Passport: Compatible with members anywhere
  bool priorityTop = false; // Top selection: View daily selected profile list
  bool unlimitedLikes = false; // Like without limits
  bool ctrlWhoLikeYou = false; // See who likes you
  bool priorityLike = false; // Priority like: First profile to be seen by people you like
  bool unlimitedReturns = false; // Unlimited returns
  bool freeBoosterPerMonth = false; // 1 free boost per month
  bool superLikesPerWeek = false; // 5 free super likes per week
  bool chatBeforeMatching = false; // Chat before matching

  String usagePeriod = '30D'; // Usage time (30D -> 30 days, 1M -> 1 month)
}
