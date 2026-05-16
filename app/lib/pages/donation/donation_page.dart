import 'package:flutter/material.dart';
import 'package:localsend_app/config/app_info.dart';
import 'package:localsend_app/gen/strings.g.dart';
import 'package:localsend_app/widget/custom_basic_appbar.dart';
import 'package:localsend_app/widget/responsive_list_view.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: basicLocalSendAppbar(t.donationPage.title),
      body: ResponsiveListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 50),
          Center(
            child: Text(
              t.donationPage.info,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 50),
          const _SupportLinks(),
        ],
      ),
    );
  }
}

class _SupportLinks extends StatelessWidget {
  const _SupportLinks();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        FilledButton.icon(
          onPressed: () async {
            await launchUrl(Uri.parse(appSupportUrl), mode: LaunchMode.externalApplication);
          },
          icon: const Icon(Icons.open_in_new),
          label: const Text('SHNWAZX'),
        ),
        FilledButton.icon(
          onPressed: () async {
            await launchUrl(Uri.parse(appRepositoryUrl), mode: LaunchMode.externalApplication);
          },
          icon: const Icon(Icons.code),
          label: const Text('Source Code'),
        ),
      ],
    );
  }
}
