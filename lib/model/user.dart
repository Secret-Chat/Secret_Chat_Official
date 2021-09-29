import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  String userEmail;
  String password;
  String userName;
  String name;
  String photoUrl;
  String about;
  String userId;
  String phoneNumber;
  List<String> contactDetails; //list of contacts in the phone

  UserModel({
    this.userEmail,
    this.password,
    this.userName,
    this.name,
    this.photoUrl,
    this.about,
    this.userId,
    this.phoneNumber,
    this.contactDetails,
  });
}

/*
Userdata:
useremail
password
Name
Photo
Status
Contact Details
UserID
Phone Number
*/

// TODO: We will add it in future
