import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final TextEditingController _nameEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 640,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: IntrinsicHeight(
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(MdiIcons.bookOpenVariant, size: 64,),
                  ),

                  Text(
                    '歡迎!',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  const Card(
                      child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                        '這是一個關於任何問題都可以透過他人來思辨的活動: \n\n在這個活動中，您可以提出任何的問題，包含: 哲學問題、技術問題、生活問題、或者任何觀點，我們將會有一位大師來反饋意見給您。'),
                  )),
                  const SizedBox(
                    height: 64,
                  ),
                  Text(
                    '該怎麼稱呼您?',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: 240,
                    child: TextField(
                      controller: _nameEditingController,
                      textInputAction: TextInputAction.done,
                      enableSuggestions: false,
                      enableIMEPersonalizedLearning: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: '您的名稱將在活動中被使用',
                      ),
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        //Todo
                      },
                      child: const Text('確認')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
