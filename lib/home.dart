import 'package:common_utils/common_utils.dart';
import 'package:daily_report/common/const.dart';
import 'package:daily_report/common/vbutton.dart';
import 'package:daily_report/unfocus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends HookWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textController = useTextEditingController();
    final _apiKeyController = useTextEditingController();
    final _resultController = useTextEditingController();
    final _apiKeyInput = useState<bool>(false);
    final _textInput = useState<bool>(false);
    final _resultInput = useState<bool>(false);
    final _loading = useState<bool>(false);
    final dio = Dio();
    GetStorage box = GetStorage();
    final screenWidth = MediaQuery.of(context).size.width;
    double realScreenWidth = screenWidth <= 800 ? screenWidth : 800;

    useEffect(() {
      _apiKeyController.text = box.read(kAPIKey) ?? '';
      _apiKeyController.addListener(() {
        _apiKeyInput.value = ObjectUtil.isNotEmpty(_apiKeyController.text);
      });
      _textController.addListener(() {
        _textInput.value = ObjectUtil.isNotEmpty(_textController.text);
      });
      return () {
        // your dispose code
      };
    }, []);

    void _submit() async {
      if (_apiKeyInput.value == false) {
        Get.snackbar(
          'error'.tr,
          'input_key'.tr,
        );
        return;
      }
      Map params = {
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": "帮我用英文润色成一条条工作报告，用- 隔开，不要用过去式：${_textController.text}"},
        ],
        "temperature": 0.7,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0,
        "max_tokens": 1536,
        "stream": false,
        "n": 1,
      };
      _loading.value = true;
      final rs = await dio.post(
        "https://api.openai.com/v1/chat/completions",
        data: params,
        options: Options(
          responseType: ResponseType.json,
          headers: {
            "Content-Type": "application/json",
            "Authorization": 'Bearer ${_apiKeyController.text}',
          },
        ),
      );
      _resultInput.value = true;
      _loading.value = false;
      try {
        String result = rs.data['choices'][0]['message']['content'];
        _resultController.text = result;
      } catch (e) {
        _resultController.text = e.toString();
        print(e);
      }
    }

    void _saveKeyClicked() {
      final key = _apiKeyController.text;
      box.write(kAPIKey, key);
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: UnFocusWidget(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: realScreenWidth - 20 - 100 - 40 - 20,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all()),
                        child: TextField(
                          controller: _apiKeyController,
                          maxLines: 1,
                          // obscureText: true,
                          autofocus: true,
                          decoration: InputDecoration.collapsed(
                            hintText: 'input_key'.tr,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      VButton(
                        width: 100,
                        onPressed: !_apiKeyInput.value ? null : _saveKeyClicked,
                        text: 'ok'.tr,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Center(
                    child: Text(
                      'title'.tr,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all()),
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      autofocus: true,
                      decoration: InputDecoration.collapsed(
                        hintText: 'input_placeholder'.tr,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  VButton(
                    onPressed: _loading.value == true
                        ? null
                        : !_textInput.value
                            ? null
                            : _submit,
                    text: _loading.value == false ? 'submit'.tr : 'loading'.tr,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (_resultInput.value)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all()),
                      child: TextField(
                        controller: _resultController,
                        readOnly: true,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration.collapsed(
                          hintText: '',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
