import 'package:faker/faker.dart';

import 'package:flutter_design_patterns/design_patterns/proxy/customer/customer_details.dart';
import 'package:flutter_design_patterns/design_patterns/proxy/icustomer_details_service.dart';

class CustomerDetailsService implements ICustomerDetailsService {
  @override
  Future<CustomerDetails> getCustomerDetails(String id) async {
    return Future.delayed(
      const Duration(seconds: 2),
      () {
        var email = faker.internet.email();
        var hobby = faker.sport.name();
        var position = faker.job.title();

        return CustomerDetails(id, email, hobby, position);
      },
    );
  }
}
