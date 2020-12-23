class UserData {
  String firstname;
  String lastname;
  String username;
  String password;

  String companyName;
  String companyWebsite;
  String companyAddress;
  String companyEmail;
  List<String> companyPhone;
  String ghanaPostAddress;
  String createdAt;
  String updatedAt;
  String id;


  UserData(
      this.firstname,
      this.lastname,
      this.username,
      this.password,
      this.companyName,
      this.companyWebsite,
      this.companyAddress,
      this.companyEmail,
      this.companyPhone,
      this.ghanaPostAddress,
      {
        this.createdAt,
        this.updatedAt,
        this.id,
      }
  );
}
