import 'dart:convert';
import 'dart:developer';

import 'package:senpai/Prefrence/prefrence.dart';
import 'package:senpai/model/UserModel.dart';

/// Get your own App ID at https://dashboard.agora.io/
String get appId {
  // Allow pass an `appId` as an environment variable with name `TEST_APP_ID` by using --dart-define
  return String.fromEnvironment(
      Preference().getString(Preference.AGORA_APP_ID)!,
      defaultValue: Preference().getString(Preference.AGORA_APP_ID)!);
}

/// Please refer to https://docs.agora.io/en/Agora%20Platform/token
String get token {
  log("Token,,,${Preference().getString(Preference.AGORA_TOKEN_ID)!}");
  // Allow pass a `token` as an environment variable with name `TEST_TOKEN` by using --dart-define
log("Token.........${Preference().getString(Preference.AGORA_TOKEN_ID)}");

  return String.fromEnvironment(
  //  "0062862fba7a36e4e7da35fdd30de395d38IACRXoxExsfn6C1ocbNBhA7A4FW1SRQ16EZtfU8jyppoN7dIfRBXoFHlIgDIywAAGOwBYwQAAQAY7AFjAwAY7AFjAgAY7AFjBAAY7AFj",
      Preference().getString(Preference.AGORA_TOKEN_ID)!,
      // "0062862fba7a36e4e7da35fdd30de395d38IACRXoxExsfn6C1ocbNBhA7A4FW1SRQ16EZtfU8jyppoN7dIfRBXoFHlIgDIywAAGOwBYwQAAQAY7AFjAwAY7AFjAgAY7AFjBAAY7AFj",
      defaultValue: Preference().getString(Preference.AGORA_TOKEN_ID)!
      //  "0062862fba7a36e4e7da35fdd30de395d38IACRXoxExsfn6C1ocbNBhA7A4FW1SRQ16EZtfU8jyppoN7dIfRBXoFHlIgDIywAAGOwBYwQAAQAY7AFjAwAY7AFjAgAY7AFjBAAY7AFj"
      );
}

/// Your channel ID
String get channelId {
  // Allow pass a `channelId` as an environment variable with name `TEST_CHANNEL_ID` by using --dart-define
  return String.fromEnvironment(
    Preference().getString(Preference.AGORA_CHANNET_ID)!,
    defaultValue: Preference().getString(Preference.AGORA_CHANNET_ID)!,
  );
}

int get uid {
  Map<String, dynamic> jsondatais =
      jsonDecode(Preference().getString(Preference.USER_MODEL)!);
  UserModel user = UserModel.fromJson(jsondatais);
  if (jsondatais.isNotEmpty) {
    return int.parse(user.user_id);
  } else {
    return 0;
  }
}

/// Your user ID for the screen sharing
const int screenSharingUid = 10;

/// Your string user ID
const String stringUid = '0';
