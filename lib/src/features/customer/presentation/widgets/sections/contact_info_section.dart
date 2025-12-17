import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';
import 'package:sales_app/src/widgets/badges/text_badge.dart';
import 'package:sales_app/src/widgets/draggable/contact_info_draggable.dart';

class ContactInfoSection extends ConsumerStatefulWidget {
  final List<ContactInfo> contacts;
  final VoidCallback? onAddPressed;
  final ValueChanged<ContactInfo>? onDelete;
  final ValueChanged<ContactInfo>? onEdit;
  final bool required;
  final String? errorMessage;

  const ContactInfoSection({
    super.key,
    this.contacts = const [],
    this.onAddPressed,
    this.onDelete,
    this.onEdit,
    this.required = false,
    this.errorMessage
  });

  @override
  ConsumerState<ContactInfoSection> createState() => ContactInfoSectionState();
}

class ContactInfoSectionState extends ConsumerState<ContactInfoSection> {
  @override
  Widget build(BuildContext context) {
    final contacts = widget.contacts;
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
                  Icons.phone,
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
                        text: "Contatos",
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
                      contacts.isEmpty
                        ? "Nenhum contato informado"
                        : "Configure os contatos do cliente"
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
                top: contacts.isNotEmpty ? 12 : 0,
              ),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                final phone = contact.phone;
                final email = contact.email;
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
                          Icons.contacts,
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
                              contact.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (phone != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 2, left: 8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      phone.type.icon,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      phone.formattedInternational,
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),

                            if (email != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 2, left: 8),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.email_outlined,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        email.value,
                                        style: Theme.of(context).textTheme.bodySmall,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if (contact.isPrimary)
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: TextBadge(text: "Principal"),
                              )
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
                        onPressed: () => widget.onEdit!(contact),
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
                        onPressed: () => widget.onDelete!(contact),
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