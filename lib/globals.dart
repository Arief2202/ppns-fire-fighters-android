// ignore_for_file: non_constant_identifier_names
library globals;
import 'dart:async';

bool loadingAutologin = false;
bool isLoggedIn = false;
String endpoint = "0.0.0.0";

const int httpTimeout = 1;
String user_id = "";
String user_name = "";
String user_email = "";
String user_password = "";
String user_card_id = "";
String user_role = "";
Timer? timerNotif;
