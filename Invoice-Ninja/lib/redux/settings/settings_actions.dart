import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:invoiceninja_flutter/data/models/client_model.dart';
import 'package:invoiceninja_flutter/data/models/company_model.dart';
import 'package:invoiceninja_flutter/data/models/entities.dart';
import 'package:invoiceninja_flutter/data/models/group_model.dart';
import 'package:invoiceninja_flutter/data/models/user_model.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';

class ViewSettings extends AbstractNavigatorAction implements PersistUI {
  ViewSettings({
    @required NavigatorState navigator,
    this.company,
    this.group,
    this.client,
    this.user,
    this.force = false,
    this.section,
    this.tabIndex,
  }) : super(navigator: navigator);

  final CompanyEntity company;
  final GroupEntity group;
  final ClientEntity client;
  final UserEntity user;
  final bool force;
  final String section;
  final int tabIndex;
}

class ClearSettingsFilter implements PersistUI {}

class ResetSettings {}

class UpdateSettings implements PersistUI {
  UpdateSettings({@required this.settings});

  final SettingsEntity settings;
}

class UpdateSettingsTab implements PersistUI {
  UpdateSettingsTab({@required this.tabIndex});

  final int tabIndex;
}

class UpdateUserSettings implements PersistUI {
  UpdateUserSettings({@required this.user});

  final UserEntity user;
}

class UploadLogoRequest implements StartSaving {
  UploadLogoRequest({this.completer, this.multipartFile, this.type});

  final Completer completer;
  final MultipartFile multipartFile;
  final EntityType type;
}

class UploadLogoFailure implements StopSaving {
  UploadLogoFailure(this.error);

  final Object error;
}

class SaveUserSettingsRequest implements StartSaving {
  SaveUserSettingsRequest({
    @required this.completer,
    @required this.user,
  });

  final Completer completer;
  final UserEntity user;
}

class SaveUserSettingsSuccess implements StopSaving, PersistData, PersistUI {
  SaveUserSettingsSuccess(this.userCompany);

  final UserCompanyEntity userCompany;
}

class SaveUserSettingsFailure implements StopSaving {
  SaveUserSettingsFailure(this.error);

  final Object error;
}

class SaveAuthUserRequest implements StartSaving {
  SaveAuthUserRequest({
    @required this.user,
    this.completer,
    this.password,
    this.idToken,
  });

  final Completer completer;
  final UserEntity user;
  final String password;
  final String idToken;
}

class SaveAuthUserSuccess implements StopSaving, PersistData, PersistUI {
  SaveAuthUserSuccess(this.user);

  final UserEntity user;
}

class SaveAuthUserFailure implements StopSaving {
  SaveAuthUserFailure(this.error);

  final Object error;
}

class ConnecOAuthUserRequest implements StartSaving {
  ConnecOAuthUserRequest({
    @required this.provider,
    @required this.idToken,
    @required this.serverAuthCode,
    this.completer,
    this.password,
  });

  final Completer completer;
  final String provider;
  final String password;
  final String idToken;
  final String serverAuthCode;
}

class ConnecOAuthUserSuccess implements StopSaving, PersistData, PersistUI {
  ConnecOAuthUserSuccess(this.user);

  final UserEntity user;
}

class ConnecOAuthUserFailure implements StopSaving {
  ConnecOAuthUserFailure(this.error);

  final Object error;
}

class FilterSettings implements PersistUI {
  FilterSettings(this.filter);

  final String filter;
}
