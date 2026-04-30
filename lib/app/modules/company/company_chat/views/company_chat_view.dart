import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/company_chat_controller.dart';

class CompanyChatView extends GetView<CompanyChatController> {
  const CompanyChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CompanyChatView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CompanyChatView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
