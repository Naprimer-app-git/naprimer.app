enum ProfileTabType { Videos, Likes }

extension ProfileTabTypeData on ProfileTabType {
  String get label {
    switch (this) {
      case ProfileTabType.Videos:
        return 'Videos';
        case ProfileTabType.Likes:
        return 'Likes';
    }
  }

  String get forNoVideosPlugText {
    switch (this) {
      case ProfileTabType.Videos:
        return 'Your published videos will appear here';
     case ProfileTabType.Likes:
        return 'Your liked videos will appear here';
    }
  }
}
