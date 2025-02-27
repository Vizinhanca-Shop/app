import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vizinhanca_shop/shared/custom_text_form_field.dart';
import 'package:vizinhanca_shop/theme/app_colors.dart';

class ItemModel {
  final String label;
  final String value;

  ItemModel({required this.label, required this.value});
}

class CustomSelect extends StatefulWidget {
  const CustomSelect({
    super.key,
    required this.controller,
    this.labelText,
    required this.items,
    this.validator,
    required this.onChanged,
    this.hintText,
    this.disabled,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
  });

  final TextEditingController controller;
  final String? labelText;
  final List<ItemModel> items;
  final String? Function(String?)? validator;
  final void Function(String) onChanged;
  final String? hintText;
  final bool? disabled;
  final FloatingLabelBehavior floatingLabelBehavior;

  @override
  State<CustomSelect> createState() => _CustomSelectState();
}

class _CustomSelectState extends State<CustomSelect> {
  late TextEditingController _displayController;

  @override
  void initState() {
    super.initState();
    _displayController = TextEditingController();
    _updateDisplayValue();

    widget.controller.addListener(_updateDisplayValue);
  }

  @override
  void didUpdateWidget(CustomSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_updateDisplayValue);
      widget.controller.addListener(_updateDisplayValue);
    }
  }

  void _updateDisplayValue() {
    final selectedItem = widget.items.firstWhere(
      (item) => item.value == widget.controller.text,
      orElse: () => ItemModel(label: '', value: ''),
    );
    _displayController.text = selectedItem.label;
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateDisplayValue);
    _displayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: _displayController,
      labelText: widget.labelText,
      validator: widget.validator,
      hintText: widget.hintText,
      readOnly: true,
      enabled: widget.disabled != true,
      floatingLabelBehavior: widget.floatingLabelBehavior,
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      onTap:
          () => showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            builder: (context) {
              return BottomSheetContent(
                items: widget.items,
                onChanged: (String value) {
                  widget.onChanged(value);
                  widget.controller.text = value;
                  _updateDisplayValue();
                },
                selectedValue: widget.controller.text,
              );
            },
          ),
    );
  }
}

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedValue,
  });

  final List<ItemModel> items;
  final void Function(String) onChanged;
  final String? selectedValue;

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  final TextEditingController _searchController = TextEditingController();
  List<ItemModel> _filteredItems = [];

  void filterSearchResults(String query) {
    List<ItemModel> dummySearchList = [];
    dummySearchList.addAll(widget.items);
    if (query.isNotEmpty) {
      List<ItemModel> dummyListData = [];
      for (var item in dummySearchList) {
        if (item.label.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        _filteredItems = [];
        _filteredItems.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _filteredItems = [];
        _filteredItems.addAll(widget.items);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(() {
      filterSearchResults(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          CustomTextFormField(
            controller: _searchController,
            labelText: 'Pesquisar',
          ),
          const SizedBox(height: 16),
          _filteredItems.isEmpty
              ? Center(
                child: Text(
                  'Nenhum resultado encontrado',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
              )
              : Expanded(
                child: ListView.builder(
                  itemCount: _filteredItems.length,
                  itemBuilder: (context, index) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          widget.onChanged(_filteredItems[index].value);
                          Navigator.of(context).pop();
                        },
                        child: ListTile(
                          selected:
                              _filteredItems[index].value ==
                              widget.selectedValue,
                          selectedColor: Colors.white,
                          selectedTileColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          titleTextStyle: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[800],
                          ),
                          title: Text(_filteredItems[index].label),
                        ),
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
