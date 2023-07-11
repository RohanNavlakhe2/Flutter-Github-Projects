import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/redux/static/static_state.dart';
import 'package:memoize/memoize.dart';
import 'package:built_collection/built_collection.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/redux/ui/list_ui_state.dart';

var memoizedDropdownInvoiceList = memo7(
    (BuiltMap<String, InvoiceEntity> invoiceMap,
            BuiltMap<String, ClientEntity> clientMap,
            BuiltList<String> invoiceList,
            String clientId,
            StaticState staticState,
            BuiltMap<String, UserEntity> userMap,
            List<String> excludedIds) =>
        dropdownInvoiceSelector(invoiceMap, clientMap, invoiceList, clientId,
            staticState, userMap, excludedIds));

List<String> dropdownInvoiceSelector(
    BuiltMap<String, InvoiceEntity> invoiceMap,
    BuiltMap<String, ClientEntity> clientMap,
    BuiltList<String> invoiceList,
    String clientId,
    StaticState staticState,
    BuiltMap<String, UserEntity> userMap,
    List<String> excludedIds) {
  final list = invoiceList.where((invoiceId) {
    final invoice = invoiceMap[invoiceId];
    if (excludedIds.contains(invoiceId)) {
      return false;
    }
    if (clientId != null &&
        clientId.isNotEmpty &&
        invoice.clientId != clientId) {
      return false;
    }
    if (!clientMap.containsKey(invoice.clientId) ||
        !clientMap[invoice.clientId].isActive) {
      return false;
    }
    return invoice.isActive &&
        invoice.isUnpaid &&
        !invoice.isCancelledOrReversed;
  }).toList();

  list.sort((invoiceAId, invoiceBId) {
    final invoiceA = invoiceMap[invoiceAId];
    final invoiceB = invoiceMap[invoiceBId];
    return invoiceA.compareTo(
        invoice: invoiceB,
        clientMap: clientMap,
        sortAscending: false,
        sortField: InvoiceFields.number,
        staticState: staticState,
        userMap: userMap);
  });

  return list;
}

var memoizedFilteredInvoiceList = memo8((SelectionState selectionState,
        BuiltMap<String, InvoiceEntity> invoiceMap,
        BuiltList<String> invoiceList,
        BuiltMap<String, ClientEntity> clientMap,
        BuiltMap<String, PaymentEntity> paymentMap,
        ListUIState invoiceListState,
        StaticState staticState,
        BuiltMap<String, UserEntity> userMap) =>
    filteredInvoicesSelector(selectionState, invoiceMap, invoiceList, clientMap,
        paymentMap, invoiceListState, staticState, userMap));

List<String> filteredInvoicesSelector(
    SelectionState selectionState,
    BuiltMap<String, InvoiceEntity> invoiceMap,
    BuiltList<String> invoiceList,
    BuiltMap<String, ClientEntity> clientMap,
    BuiltMap<String, PaymentEntity> paymentMap,
    ListUIState invoiceListState,
    StaticState staticState,
    BuiltMap<String, UserEntity> userMap) {
  final filterEntityId = selectionState.filterEntityId;
  final filterEntityType = selectionState.filterEntityType;

  final Map<String, List<String>> invoicePaymentMap = {};
  if (filterEntityType == EntityType.payment) {
    paymentMap.forEach((paymentId, payment) {
      payment.invoicePaymentables.forEach((invoicePaymentable) {
        final List<String> paymentIds =
            invoicePaymentMap[invoicePaymentable.invoiceId] ?? [];
        paymentIds.add(payment.id);
        invoicePaymentMap[invoicePaymentable.invoiceId] = paymentIds;
      });
    });
  }

  final list = invoiceList.where((invoiceId) {
    final invoice = invoiceMap[invoiceId];
    final client =
        clientMap[invoice.clientId] ?? ClientEntity(id: invoice.clientId);

    if (invoice.id == selectionState.selectedId) {
      return true;
    }

    if (!client.isActive &&
        !client.matchesEntityFilter(filterEntityType, filterEntityId)) {
      return false;
    }

    if (filterEntityType == EntityType.client && client.id != filterEntityId) {
      return false;
    } else if (filterEntityType == EntityType.user &&
        invoice.assignedUserId != filterEntityId) {
      return false;
    } else if (filterEntityType == EntityType.recurringInvoice &&
        invoice.recurringId != filterEntityId) {
      return false;
    } else if (filterEntityType == EntityType.payment) {
      bool isMatch = false;
      (invoicePaymentMap[invoiceId] ?? []).forEach((paymentId) {
        if (filterEntityId == paymentId) {
          isMatch = true;
        }
      });

      if (!isMatch) {
        return false;
      }
    }

    if (!invoice.matchesStates(invoiceListState.stateFilters)) {
      return false;
    }
    if (!invoice.matchesStatuses(invoiceListState.statusFilters)) {
      return false;
    }
    if (!invoice.matchesFilter(invoiceListState.filter) &&
        !client.matchesFilter(invoiceListState.filter)) {
      return false;
    }
    if (invoiceListState.custom1Filters.isNotEmpty &&
        !invoiceListState.custom1Filters.contains(invoice.customValue1)) {
      return false;
    }
    if (invoiceListState.custom2Filters.isNotEmpty &&
        !invoiceListState.custom2Filters.contains(invoice.customValue2)) {
      return false;
    }
    if (invoiceListState.custom3Filters.isNotEmpty &&
        !invoiceListState.custom3Filters.contains(invoice.customValue3)) {
      return false;
    }
    if (invoiceListState.custom4Filters.isNotEmpty &&
        !invoiceListState.custom4Filters.contains(invoice.customValue4)) {
      return false;
    }
    return true;
  }).toList();

  list.sort((invoiceAId, invoiceBId) {
    return invoiceMap[invoiceAId].compareTo(
      invoice: invoiceMap[invoiceBId],
      sortField: invoiceListState.sortField,
      sortAscending: invoiceListState.sortAscending,
      clientMap: clientMap,
      staticState: staticState,
      userMap: userMap,
    );
  });

  return list;
}

var memoizedInvoiceStatsForClient = memo2(
    (String clientId, BuiltMap<String, InvoiceEntity> invoiceMap) =>
        invoiceStatsForClient(clientId, invoiceMap));

EntityStats invoiceStatsForClient(
    String clientId, BuiltMap<String, InvoiceEntity> invoiceMap) {
  int countActive = 0;
  int countArchived = 0;
  invoiceMap.forEach((invoiceId, invoice) {
    if (invoice.clientId == clientId) {
      if (invoice.isActive) {
        countActive++;
      } else if (invoice.isArchived) {
        countArchived++;
      }
    }
  });

  return EntityStats(countActive: countActive, countArchived: countArchived);
}

var memoizedInvoiceStatsForUser = memo2(
    (String userId, BuiltMap<String, InvoiceEntity> invoiceMap) =>
        invoiceStatsForUser(userId, invoiceMap));

EntityStats invoiceStatsForUser(
    String userId, BuiltMap<String, InvoiceEntity> invoiceMap) {
  int countActive = 0;
  int countArchived = 0;
  invoiceMap.forEach((invoiceId, invoice) {
    if (invoice.assignedUserId == userId) {
      if (invoice.isActive) {
        countActive++;
      } else if (invoice.isDeleted) {
        countArchived++;
      }
    }
  });

  return EntityStats(countActive: countActive, countArchived: countArchived);
}

int precisionForInvoice(AppState state, InvoiceEntity invoice) {
  final client = state.clientState.get(invoice.clientId);
  final currency = state.staticState.currencyMap[client.currencyId];
  return currency?.precision ?? 2;
}

bool hasInvoiceChanges(
        InvoiceEntity invoice, BuiltMap<String, InvoiceEntity> invoiceMap) =>
    invoice.isNew ? invoice.isChanged : invoice != invoiceMap[invoice.id];
