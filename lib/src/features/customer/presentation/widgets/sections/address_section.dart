
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address_type.dart';
import 'package:sales_app/src/widgets/badges/text_badge.dart';
import 'package:sales_app/src/widgets/draggable/address_draggable.dart';


class AddressSection extends ConsumerStatefulWidget {
  final List<Address> addresses;
  final VoidCallback? onAddPressed;
  final ValueChanged<Address>? onDelete;
  final ValueChanged<Address>? onEdit;
  final bool required;
  final String? errorMessage;

  const AddressSection({
    super.key,
    this.addresses = const [],
    this.onAddPressed,
    this.onDelete,
    this.onEdit,
    this.required = false,
    this.errorMessage
  });

  @override
  ConsumerState<AddressSection> createState() => AddressSectionState();
}

class AddressSectionState extends ConsumerState<AddressSection>{

  @override
  Widget build(BuildContext context) {
    final addresses = widget.addresses;
    final errorMessage = widget.errorMessage;

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.location_on,
                  color: scheme.primary,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Endereços",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                        ),
                        children: widget.required
                          ? const [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ]
                          : [],
                      ),
                    ),
                    Text(
                      addresses.isEmpty
                        ? "Nenhum endereço informado"
                        : "Configure os endereços do cliente"
                      ,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 12
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: widget.onAddPressed,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar'),
                style: OutlinedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: scheme.outline, width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top: addresses.isNotEmpty ? 12 : 0,
            ),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scheme.outline),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        address.type.icon,
                        size: 18,
                        color: scheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.formatted,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (address.type != AddressType.others || address.isPrimary)
                            const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (address.type != AddressType.others)
                                TextBadge(text: address.type.label),

                              if (address.type != AddressType.others && address.isPrimary)
                                const SizedBox(width: 6),

                              if (address.isPrimary)
                                TextBadge(text: "Principal")
                            ],
                          ),
                        ],
                      ),
                    ),
                    widget.onEdit != null
                      ? IconButton(
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                        ),
                          color: scheme.primary,
                          onPressed: () => widget.onEdit!(address),
                        )
                      : SizedBox.shrink()
                    ,
                    SizedBox(width: 8),
                    widget.onDelete != null
                      ? IconButton(
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 20,
                        ),
                        color: scheme.primary,
                        onPressed: () => widget.onDelete!(address),
                      )
                      : SizedBox.shrink(),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 4);
            }
          ),
          if (errorMessage != null)
              Column(
                children: [
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: scheme.errorContainer.withValues(alpha: .6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: scheme.error.withValues(alpha: .4),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: scheme.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            errorMessage,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onErrorContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
        ],
      ),
    );
  }
}