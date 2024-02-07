import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// 버전정보 페이지
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  /// github 버튼 클릭 핸들러
  void _githubBtnClickHandler() {
    final Uri url = Uri.parse('https://google.com');
    launchUrl(url);
  }

  /// 이메일 버튼 클릭 핸들러
  void _sendEmailHandler() {
    Uri url = Uri(
      scheme: 'mailto',
      path: 'devzoou@gmail.com',
      query: Uri.encodeQueryComponent({'subject': 'Consider'}
          .entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&')),
    );
    launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '레인알럿 - 비알리미',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(width: 0, height: 10),
        const Text('v0.0.1'),
        const SizedBox(width: 0, height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton.tonal(
                onPressed: _sendEmailHandler, child: const Text('의견보내기')),
            const SizedBox(width: 15, height: 0),
            FilledButton.tonal(
                onPressed: _githubBtnClickHandler, child: const Text('Github')),
          ],
        ),
      ],
    );
  }
}
