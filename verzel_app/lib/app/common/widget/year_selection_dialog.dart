import 'package:flutter/material.dart';

class YearSelectionDialog extends StatefulWidget {
  const YearSelectionDialog({super.key});

  @override
  YearSelectionDialogState createState() => YearSelectionDialogState();
}

class YearSelectionDialogState extends State<YearSelectionDialog> {
  late ScrollController _scrollController;
  int _selectedYear = DateTime.now().year;
  int _yearsToShow = 21;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 400); // Adjust the value as needed
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Scrolled to the bottom, load more years in the future
      setState(() {
        _yearsToShow += 10;
      });
    } else if (_scrollController.position.pixels == _scrollController.position.minScrollExtent) {
      // Scrolled to the top, load more years in the past
      setState(() {
        _yearsToShow += 10;
        _selectedYear -= 10;
      });
      // _scrollController.jumpTo(_scrollController.position.pixels + 10); // Prevent overscrolling
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selecione um ano'),
      content: SizedBox(
        height: 300, // Adjust the height as needed
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _yearsToShow,
          itemBuilder: (BuildContext context, int index) {
            final year = _selectedYear - 10 + index;
            return GestureDetector(
              onTap: () {
                Navigator.pop(context, year); // Close the modal and return the selected year
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(year.toString()),
                    if (index != _yearsToShow - 1)
                      const Divider(), // Don't add divider after the last item
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
