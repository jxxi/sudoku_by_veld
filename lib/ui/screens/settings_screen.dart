import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/store_constants.dart';
import '../../services/tip_jar_service.dart';
import '../../storage/stats_store.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.statsStore,
    this.openTipJar = false,
    this.onOpenTutorial,
  });

  final StatsStore statsStore;
  final bool openTipJar;
  final VoidCallback? onOpenTutorial;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TipJarService _tipJar = TipJarService();
  ProductDetails? _product;
  TipJarFetchResult? _fetchResult;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initTipJar();
  }

  Future<void> _initTipJar() async {
    _tipJar.purchaseStream.listen(_onPurchaseUpdate);
    if (await _tipJar.isAvailable) {
      _fetchResult = await _tipJar.fetchProduct();
      _product = _fetchResult!.product;
    }
    if (mounted) setState(() => _loading = false);
    if (widget.openTipJar && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showTipJarSheet());
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _productUnavailableMessage() {
    final result = _fetchResult;
    if (result == null) {
      return 'Tip jar product not configured yet. Add veld_tip_jar in the stores.';
    }

    final parts = <String>['Tip jar product not available.'];
    if (result.notFoundIds.isNotEmpty) {
      parts.add('Not found: ${result.notFoundIds.join(', ')}');
    }
    if (result.queryError != null) {
      parts.add(result.queryError!.message);
    }
    return parts.join(' ');
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID == tipJarProductId) {
        switch (purchase.status) {
          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            await widget.statsStore.setTipJarPurchased(true);
            if (mounted) setState(() {});
            if (purchase.status == PurchaseStatus.purchased) {
              _showSnackBar('Thank you for your support!');
            }
          case PurchaseStatus.error:
            _showSnackBar(
              purchase.error?.message ?? 'Purchase failed. Please try again.',
            );
          case PurchaseStatus.canceled:
            _showSnackBar('Purchase canceled.');
          case PurchaseStatus.pending:
            _showSnackBar('Purchase pending approval.');
        }
      }
      if (purchase.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchase);
      }
    }
  }

  Future<void> _showTipJarSheet() async {
    if (widget.statsStore.tipJarPurchased) return;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Support the Veld',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Optional one-time tip — thanks for playing!',
                ),
                const SizedBox(height: 16),
                if (_loading)
                  const Center(child: CircularProgressIndicator())
                else if (_product == null)
                  Text(_productUnavailableMessage())
                else
                  FilledButton(
                    onPressed: () => _tipJar.purchase(_product!),
                    child: Text('Tip ${_product!.price}'),
                  ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _tipJar.restore,
                  child: const Text('Restore purchases'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openPrivacyPolicy() async {
    final uri = Uri.parse(privacyPolicyUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showSnackBar('Could not open privacy policy.');
    }
  }

  Future<void> _openFeedbackEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: privacyContactEmail,
      query: 'subject=${Uri.encodeComponent('Sudoku by Veld feedback')}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showSnackBar('Could not open email app.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Show timer during game'),
            subtitle: const Text('Best times are still recorded.'),
            value: widget.statsStore.showTimerDuringGame,
            onChanged: (value) async {
              await widget.statsStore.setShowTimerDuringGame(value);
              if (mounted) setState(() {});
            },
          ),
          SwitchListTile(
            title: const Text('Red mistake feedback'),
            subtitle: const Text(
              'Wrong digits turn red and buzz. Turn off for a quieter grid.',
            ),
            value: widget.statsStore.showMistakeFeedback,
            onChanged: (value) async {
              await widget.statsStore.setShowMistakeFeedback(value);
              if (mounted) setState(() {});
            },
          ),
          ListTile(
            title: const Text('Replay tutorial'),
            trailing: const Icon(Icons.replay_outlined),
            onTap: () async {
              await widget.statsStore.setTutorialCompleted(false);
              if (!context.mounted) return;
              widget.onOpenTutorial?.call();
            },
          ),
          ListTile(
            title: const Text('Support the Veld'),
            subtitle: Text(
              widget.statsStore.tipJarPurchased
                  ? 'Thank you for your support.'
                  : 'Optional tip jar',
            ),
            trailing: const Icon(Icons.favorite_outline),
            onTap: _showTipJarSheet,
          ),
          ListTile(
            title: const Text('Got feedback?'),
            subtitle: const Text('Send us an email'),
            trailing: const Icon(Icons.mail_outline),
            onTap: _openFeedbackEmail,
          ),
          ListTile(
            title: const Text('Restore purchases'),
            onTap: _tipJar.restore,
          ),
          ListTile(
            title: const Text('Privacy policy'),
            trailing: const Icon(Icons.open_in_new),
            onTap: _openPrivacyPolicy,
          ),
        ],
      ),
    );
  }
}
