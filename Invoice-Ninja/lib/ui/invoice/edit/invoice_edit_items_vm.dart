import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/ui/invoice/edit/invoice_edit_items.dart';
import 'package:invoiceninja_flutter/ui/invoice/edit/invoice_edit_items_desktop.dart';
import 'package:invoiceninja_flutter/ui/invoice/edit/invoice_edit_vm.dart';
import 'package:redux/redux.dart';
import 'package:invoiceninja_flutter/redux/invoice/invoice_actions.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';

class InvoiceEditItemsScreen extends StatelessWidget {
  const InvoiceEditItemsScreen({
    Key key,
    @required this.viewModel,
    this.isTasks = false,
  }) : super(key: key);

  final EntityEditVM viewModel;
  final bool isTasks;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InvoiceEditItemsVM>(
      converter: (Store<AppState> store) {
        return InvoiceEditItemsVM.fromStore(store, isTasks);
      },
      builder: (context, viewModel) {
        if (viewModel.state.prefState.isEditorFullScreen(EntityType.invoice)) {
          return InvoiceEditItemsDesktop(
            viewModel: viewModel,
            entityViewModel: this.viewModel,
            isTasks: isTasks,
          );
        } else {
          return InvoiceEditItems(
            viewModel: viewModel,
            entityViewModel: this.viewModel,
          );
        }
      },
    );
  }
}

class EntityEditItemsVM {
  EntityEditItemsVM({
    @required this.state,
    @required this.company,
    @required this.invoice,
    @required this.addLineItem,
    @required this.deleteLineItem,
    @required this.invoiceItemIndex,
    @required this.onRemoveInvoiceItemPressed,
    @required this.clearSelectedInvoiceItem,
    @required this.onChangedInvoiceItem,
  });

  final AppState state;
  final CompanyEntity company;
  final InvoiceEntity invoice;
  final int invoiceItemIndex;
  final Function addLineItem;
  final Function deleteLineItem;
  final Function(int) onRemoveInvoiceItemPressed;
  final Function clearSelectedInvoiceItem;
  final Function(InvoiceItemEntity, int) onChangedInvoiceItem;
}

class InvoiceEditItemsVM extends EntityEditItemsVM {
  InvoiceEditItemsVM({
    AppState state,
    CompanyEntity company,
    InvoiceEntity invoice,
    int invoiceItemIndex,
    Function addLineItem,
    Function(int) deleteLineItem,
    Function(int) onRemoveInvoiceItemPressed,
    Function clearSelectedInvoiceItem,
    Function(InvoiceItemEntity, int) onChangedInvoiceItem,
  }) : super(
          state: state,
          company: company,
          invoice: invoice,
          addLineItem: addLineItem,
          deleteLineItem: deleteLineItem,
          invoiceItemIndex: invoiceItemIndex,
          onRemoveInvoiceItemPressed: onRemoveInvoiceItemPressed,
          clearSelectedInvoiceItem: clearSelectedInvoiceItem,
          onChangedInvoiceItem: onChangedInvoiceItem,
        );

  factory InvoiceEditItemsVM.fromStore(Store<AppState> store, bool isTasks) {
    return InvoiceEditItemsVM(
        state: store.state,
        company: store.state.company,
        invoice: store.state.invoiceUIState.editing,
        invoiceItemIndex: store.state.invoiceUIState.editingItemIndex,
        addLineItem: () =>
            store.dispatch(AddInvoiceItem(invoiceItem: InvoiceItemEntity())),
        deleteLineItem: null,
        onRemoveInvoiceItemPressed: (index) =>
            store.dispatch(DeleteInvoiceItem(index)),
        clearSelectedInvoiceItem: () => store.dispatch(EditInvoiceItem()),
        onChangedInvoiceItem: (invoiceItem, index) {
          final invoice = store.state.invoiceUIState.editing;
          if (index == invoice.lineItems.length) {
            store.dispatch(AddInvoiceItem(
                invoiceItem: invoiceItem.rebuild((b) => b
                  ..typeId = isTasks
                      ? InvoiceItemEntity.TYPE_TASK
                      : InvoiceItemEntity.TYPE_STANDARD)));
          } else {
            store.dispatch(
                UpdateInvoiceItem(invoiceItem: invoiceItem, index: index));
          }
        });
  }
}
