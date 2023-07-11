import 'package:built_collection/built_collection.dart';
import 'package:invoiceninja_flutter/data/models/entities.dart';
import 'package:invoiceninja_flutter/redux/settings/settings_actions.dart';
import 'package:redux/redux.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/redux/company/company_actions.dart';
import 'package:invoiceninja_flutter/redux/ui/entity_ui_state.dart';
import 'package:invoiceninja_flutter/redux/ui/list_ui_state.dart';
import 'package:invoiceninja_flutter/redux/user/user_actions.dart';
import 'package:invoiceninja_flutter/redux/user/user_state.dart';

EntityUIState userUIReducer(UserUIState state, dynamic action) {
  return state.rebuild((b) => b
    ..listUIState.replace(userListReducer(state.listUIState, action))
    ..editing.replace(editingReducer(state.editing, action))
    ..selectedId = selectedIdReducer(state.selectedId, action));
}

Reducer<String> selectedIdReducer = combineReducers([
  TypedReducer<String, PreviewEntity>((selectedId, action) =>
      action.entityType == EntityType.user ? action.entityId : selectedId),
  TypedReducer<String, ViewUser>((String selectedId, action) => action.userId),
  TypedReducer<String, AddUserSuccess>(
      (String selectedId, action) => action.user.id),
  TypedReducer<String, SelectCompany>(
      (selectedId, action) => action.clearSelection ? '' : selectedId),
  TypedReducer<String, ClearEntityFilter>((selectedId, action) => ''),
  TypedReducer<String, ClearEntitySelection>((selectedId, action) =>
      action.entityType == EntityType.user ? '' : selectedId),
  TypedReducer<String, FilterByEntity>(
      (selectedId, action) => action.clearSelection
          ? ''
          : action.entityType == EntityType.user
              ? action.entityId
              : selectedId),
]);

final editingReducer = combineReducers<UserEntity>([
  TypedReducer<UserEntity, SaveUserSuccess>(_updateEditing),
  TypedReducer<UserEntity, AddUserSuccess>(_updateEditing),
  TypedReducer<UserEntity, RestoreUserSuccess>((users, action) {
    return action.users[0];
  }),
  TypedReducer<UserEntity, ArchiveUserSuccess>((users, action) {
    return action.users[0];
  }),
  TypedReducer<UserEntity, DeleteUserSuccess>((users, action) {
    return action.users[0];
  }),
  TypedReducer<UserEntity, EditUser>(_updateEditing),
  TypedReducer<UserEntity, UpdateUser>((user, action) {
    return action.user.rebuild((b) => b..isChanged = true);
  }),
  TypedReducer<UserEntity, DiscardChanges>(_clearEditing),
]);

UserEntity _clearEditing(UserEntity user, dynamic action) {
  return UserEntity();
}

UserEntity _updateEditing(UserEntity user, dynamic action) {
  return action.user;
}

final userListReducer = combineReducers<ListUIState>([
  TypedReducer<ListUIState, SortUsers>(_sortUsers),
  TypedReducer<ListUIState, FilterUsersByState>(_filterUsersByState),
  TypedReducer<ListUIState, FilterUsers>(_filterUsers),
  TypedReducer<ListUIState, FilterUsersByCustom1>(_filterUsersByCustom1),
  TypedReducer<ListUIState, FilterUsersByCustom2>(_filterUsersByCustom2),
  TypedReducer<ListUIState, StartUserMultiselect>(_startListMultiselect),
  TypedReducer<ListUIState, AddToUserMultiselect>(_addToListMultiselect),
  TypedReducer<ListUIState, RemoveFromUserMultiselect>(
      _removeFromListMultiselect),
  TypedReducer<ListUIState, ClearUserMultiselect>(_clearListMultiselect),
]);

ListUIState _filterUsersByCustom1(
    ListUIState userListState, FilterUsersByCustom1 action) {
  if (userListState.custom1Filters.contains(action.value)) {
    return userListState.rebuild((b) => b..custom1Filters.remove(action.value));
  } else {
    return userListState.rebuild((b) => b..custom1Filters.add(action.value));
  }
}

ListUIState _filterUsersByCustom2(
    ListUIState userListState, FilterUsersByCustom2 action) {
  if (userListState.custom2Filters.contains(action.value)) {
    return userListState.rebuild((b) => b..custom2Filters.remove(action.value));
  } else {
    return userListState.rebuild((b) => b..custom2Filters.add(action.value));
  }
}

ListUIState _filterUsersByState(
    ListUIState userListState, FilterUsersByState action) {
  if (userListState.stateFilters.contains(action.state)) {
    return userListState.rebuild((b) => b..stateFilters.remove(action.state));
  } else {
    return userListState.rebuild((b) => b..stateFilters.add(action.state));
  }
}

ListUIState _filterUsers(ListUIState userListState, FilterUsers action) {
  return userListState.rebuild((b) => b
    ..filter = action.filter
    ..filterClearedAt = action.filter == null
        ? DateTime.now().millisecondsSinceEpoch
        : userListState.filterClearedAt);
}

ListUIState _sortUsers(ListUIState userListState, SortUsers action) {
  return userListState.rebuild((b) => b
    ..sortAscending = b.sortField != action.field || !b.sortAscending
    ..sortField = action.field);
}

ListUIState _startListMultiselect(
    ListUIState userListState, StartUserMultiselect action) {
  return userListState.rebuild((b) => b..selectedIds = ListBuilder());
}

ListUIState _addToListMultiselect(
    ListUIState userListState, AddToUserMultiselect action) {
  return userListState.rebuild((b) => b..selectedIds.add(action.entity.id));
}

ListUIState _removeFromListMultiselect(
    ListUIState userListState, RemoveFromUserMultiselect action) {
  return userListState.rebuild((b) => b..selectedIds.remove(action.entity.id));
}

ListUIState _clearListMultiselect(
    ListUIState userListState, ClearUserMultiselect action) {
  return userListState.rebuild((b) => b..selectedIds = null);
}

final usersReducer = combineReducers<UserState>([
  TypedReducer<UserState, SaveUserSuccess>(_updateUser),
  TypedReducer<UserState, SaveAuthUserSuccess>(_updateAuthUser),
  TypedReducer<UserState, ConnecOAuthUserSuccess>(_connectOAuthUser),
  TypedReducer<UserState, AddUserSuccess>(_addUser),
  TypedReducer<UserState, LoadUsersSuccess>(_setLoadedUsers),
  TypedReducer<UserState, LoadUserSuccess>(_setLoadedUser),
  TypedReducer<UserState, LoadCompanySuccess>(_setLoadedCompany),
  TypedReducer<UserState, ArchiveUserSuccess>(_archiveUserSuccess),
  TypedReducer<UserState, DeleteUserSuccess>(_deleteUserSuccess),
  TypedReducer<UserState, RestoreUserSuccess>(_restoreUserSuccess),
  TypedReducer<UserState, RemoveUserSuccess>(_removeUserSuccess),
]);

UserState _archiveUserSuccess(UserState userState, ArchiveUserSuccess action) {
  return userState.rebuild((b) {
    for (final user in action.users) {
      b.map[user.id] = user;
    }
  });
}

UserState _deleteUserSuccess(UserState userState, DeleteUserSuccess action) {
  return userState.rebuild((b) {
    for (final user in action.users) {
      b.map[user.id] = user;
    }
  });
}

UserState _restoreUserSuccess(UserState userState, RestoreUserSuccess action) {
  return userState.rebuild((b) {
    for (final user in action.users) {
      b.map[user.id] = user;
    }
  });
}

UserState _removeUserSuccess(UserState userState, RemoveUserSuccess action) {
  return userState
      .rebuild((b) => b..map.remove(action.userId)..list.remove(action.userId));
}

UserState _addUser(UserState userState, AddUserSuccess action) {
  return userState.rebuild((b) => b
    ..map[action.user.id] = action.user
    ..list.add(action.user.id));
}

UserState _updateUser(UserState userState, SaveUserSuccess action) {
  return userState.rebuild((b) => b..map[action.user.id] = action.user);
}

UserState _updateAuthUser(UserState userState, SaveAuthUserSuccess action) {
  return userState.rebuild((b) => b..map[action.user.id] = action.user);
}

UserState _connectOAuthUser(
    UserState userState, ConnecOAuthUserSuccess action) {
  return userState.rebuild((b) => b..map[action.user.id] = action.user);
}

UserState _setLoadedUser(UserState userState, LoadUserSuccess action) {
  return userState.rebuild((b) => b..map[action.user.id] = action.user);
}

UserState _setLoadedUsers(UserState userState, LoadUsersSuccess action) {
  final state = userState.rebuild((b) => b
    ..map.addAll(Map.fromIterable(
      action.users,
      key: (dynamic item) => item.id,
      value: (dynamic item) => item,
    )));

  return state.rebuild((b) => b..list.replace(state.map.keys));
}

UserState _setLoadedCompany(UserState userState, LoadCompanySuccess action) {
  final state = userState.rebuild((b) => b
    ..map.addAll(Map.fromIterable(
      action.userCompany.company.users,
      key: (dynamic item) => item.id,
      value: (dynamic item) => item,
    )));

  return state.rebuild((b) => b..list.replace(state.map.keys));
}
