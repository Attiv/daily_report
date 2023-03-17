import 'package:get/get.dart';

class Transaction extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          'title': '日报润色',
          'input_placeholder': '请输入你的工作日报',
          'submit': '提交',
          'error': '错误',
          'input_key': '请输入API Key',
          'ok': '确认',
        },
        'en_US': {
          'title': 'Daily Report',
          'input_placeholder': 'Please enter your daily work report.',
          'submit': 'submit',
          'error': 'Error',
          'input_key': 'Please enter the API Key',
          'ok': 'OK',
        }
      };
}
