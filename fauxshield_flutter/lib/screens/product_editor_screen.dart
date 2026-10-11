import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';

import '../client.dart';
import '../utils/product_images.dart';
import '../widgets/common.dart';

/// Full page for creating a product — the reference app renders product
/// setup as a page section rather than a cramped modal.
///
/// Pops with `true` when a product was created.
class ProductEditorScreen extends StatefulWidget {
  const ProductEditorScreen({super.key});

  @override
  State<ProductEditorScreen> createState() => _ProductEditorScreenState();
}

const List<String> _categories = <String>[
  'drug',
  'cosmetic',
  'beverage',
  'food',
  'electronics',
  'luxury',
  'other',
];

class _ProductEditorScreenState extends State<ProductEditorScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _sku = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _packaging = TextEditingController();
  final TextEditingController _shelfLife = TextEditingController();
  final TextEditingController _countries = TextEditingController();
  final TextEditingController _safety = TextEditingController();

  String? _category;
  final List<PickedImage> _pendingImages = <PickedImage>[];
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _sku.dispose();
    _description.dispose();
    _packaging.dispose();
    _shelfLife.dispose();
    _countries.dispose();
    _safety.dispose();
    super.dispose();
  }

  Future<void> _addImages() async {
    try {
      final picked = await pickProductImages(
        existingCount: _pendingImages.length,
      );
      if (picked.isEmpty) return;
      setState(() {
        _pendingImages.addAll(picked);
        _error = null;
      });
    } catch (error) {
      setState(() => _error = error.toString());
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final imageUrls = await uploadProductImages(_pendingImages);
      final countries = _countries.text
          .split(',')
          .map((part) => part.trim().toUpperCase())
          .where((part) => part.isNotEmpty)
          .toList();
      await client.product.create(
        name: _name.text.trim(),
        sku: _sku.text.trim().isEmpty ? null : _sku.text.trim(),
        category: _category,
        description: _description.text.trim().isEmpty
            ? null
            : _description.text.trim(),
        imageUrls: imageUrls.isEmpty ? null : imageUrls,
        packaging: _packaging.text.trim().isEmpty
            ? null
            : _packaging.text.trim(),
        shelfLife: _shelfLife.text.trim().isEmpty
            ? null
            : _shelfLife.text.trim(),
        countryRestrictions: countries.isEmpty ? null : countries,
        safetyInstructions: _safety.text.trim().isEmpty
            ? null
            : _safety.text.trim(),
      );
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (error) {
      setState(() {
        _saving = false;
        _error = error.message;
      });
    } catch (error) {
      setState(() {
        _saving = false;
        _error = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('New product'),
        actions: <Widget>[
          TextButton(
            onPressed: _saving ? null : () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Center(
            child: ConstrainedBox(
              // Comfortable measure on desktop, full width on phones.
              constraints: const BoxConstraints(maxWidth: 640),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Product setup',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Start with the details consumers and your operations '
                      'team need. You can add batches and identities after '
                      'this profile is created.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    LabeledField(
                      label: 'Product name *',
                      controller: _name,
                      validator: (value) =>
                          (value == null || value.trim().length < 2)
                          ? 'Enter at least 2 characters.'
                          : null,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(
                                    'Category',
                                    style: theme.textTheme.labelMedium,
                                  ),
                                ),
                                DropdownButtonFormField<String?>(
                                  initialValue: _category,
                                  hint: const Text('Select category'),
                                  isExpanded: true,
                                  items: <DropdownMenuItem<String?>>[
                                    const DropdownMenuItem<String?>(
                                      value: null,
                                      child: Text('None'),
                                    ),
                                    for (final category in _categories)
                                      DropdownMenuItem<String?>(
                                        value: category,
                                        child: Text(
                                          category[0].toUpperCase() +
                                              category.substring(1),
                                        ),
                                      ),
                                  ],
                                  onChanged: _saving
                                      ? null
                                      : (value) =>
                                            setState(() => _category = value),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: LabeledField(
                            label: 'SKU',
                            controller: _sku,
                            hint: 'Optional product identifier',
                          ),
                        ),
                      ],
                    ),
                    LabeledField(
                      label: 'Description',
                      controller: _description,
                      maxLines: 3,
                      hint:
                          'Describe what the product is, who it is for, and the details that make it distinct.',
                    ),
                    LabeledField(
                      label: 'Packaging',
                      controller: _packaging,
                      hint: 'Bottle, carton, blister pack…',
                    ),
                    LabeledField(
                      label: 'Shelf life',
                      controller: _shelfLife,
                      hint: 'e.g. 24 months',
                    ),
                    LabeledField(
                      label: 'Country restrictions',
                      controller: _countries,
                      hint: 'US, GB, NG',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        'Comma-separated ISO country codes where this product '
                        'may not be sold.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    LabeledField(
                      label: 'Safety instructions',
                      controller: _safety,
                      maxLines: 3,
                      hint: 'Consumer safety, storage, or handling information',
                    ),
                    const SizedBox(height: 12),
                    Text('Product imagery', style: theme.textTheme.labelMedium),
                    const SizedBox(height: 4),
                    Text(
                      'Up to $maxProductImages images, PNG/JPEG/WebP/SVG, '
                      '2 MB each.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        for (var i = 0; i < _pendingImages.length; i++)
                          Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  _pendingImages[i].bytes,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    width: 72,
                                    height: 72,
                                    color:
                                        theme.colorScheme.surfaceContainerLow,
                                    child: const Icon(
                                      Icons.broken_image_outlined,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: InkWell(
                                  onTap: _saving
                                      ? null
                                      : () => setState(
                                          () => _pendingImages.removeAt(i),
                                        ),
                                  child: Icon(
                                    Icons.cancel_rounded,
                                    size: 18,
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        OutlinedButton.icon(
                          onPressed: _saving ? null : _addImages,
                          icon: const Icon(Icons.add_photo_alternate_outlined),
                          label: Text(
                            _pendingImages.isEmpty
                                ? 'Add image'
                                : 'Add another',
                          ),
                        ),
                      ],
                    ),
                    if (_error != null) ...<Widget>[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer.withValues(
                            alpha: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: theme.colorScheme.onErrorContainer,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: _saving
                              ? null
                              : () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: _saving ? null : _submit,
                          child: _saving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Create product'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
