class UserDetails{
  final String providerDetails;
  final String userName;
  final String photoUrl;
  final String userEmail;
  UserDetails(this.providerDetails, this.userName, this.photoUrl, this.userEmail);
}

class ProviderDetails{
  ProviderDetails(this.providerDetails);
  final String providerDetails;
}