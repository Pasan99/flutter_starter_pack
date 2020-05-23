import 'package:food_deliver/src/base/api_base_model.dart';
import 'package:food_deliver/src/ext/list_extension.dart';

import 'contacts_request_api.dart';

class ContactPaginationRequestAPI
    extends ApiBaseModel<ContactPaginationRequestAPI> {
  List<ContactPaginationRequestAPI> itemList;

  List<dynamic> metadata;
  int total;
  int page;
  List<ContactsRequestAPI> data;

  @override
  toClass(Map<String, dynamic> map) {
    if (map.containsKey('metadata')) this.metadata = map['metadata'];

    if (this.metadata != null && this.metadata.isNotEmpty) {
      if (this.metadata[0].containsKey('total'))
        this.total = this.metadata[0]['total'];
      if (this.metadata[0].containsKey('page'))
        this.page = this.metadata[0]['page'];
    }

    if (map.containsKey('data')) {
      this.data = List();
      List<dynamic> jsonArr = map['data'];
      if (!jsonArr.isInvalid()) {
        jsonArr.forEach((contact) {
          this.data.add(ContactsRequestAPI().toClass(contact));
        });
      }
    }
    return this;
  }

  @override
  Map<String, dynamic> toMap({bool withoutUniqueIDs = false}) {
    return null;
  }

  @override
  ContactPaginationRequestAPI listToClass(List<dynamic> array) {
    if (array.isInvalid()) return null;
    ContactPaginationRequestAPI api = ContactPaginationRequestAPI();
    api.itemList = List();

    array.forEach((item) {
      if (item != null && item is Map && item.isNotEmpty)
        api.itemList.add(ContactPaginationRequestAPI().toClass(item));
    });

    return api;
  }
}
