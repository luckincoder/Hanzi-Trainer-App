import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hanzi_trainer/databases/database_manager.dart';
import 'package:hanzi_trainer/notifiers/cards_notifier.dart';
import 'package:hanzi_trainer/pages/card_page.dart';
import 'package:hanzi_trainer/pages/home_page.dart';
import 'package:hanzi_trainer/utils/methods.dart';
import 'package:provider/provider.dart';

class ResultBox extends StatefulWidget {
  const ResultBox({super.key});

  @override
  State<ResultBox> createState() => _ResultBoxState();
}

class _ResultBoxState extends State<ResultBox> {
  bool _savedCards = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<CardsNotifier>(
      builder: (_, notifier, __) => AlertDialog(
        title: Text(
          notifier.isSessionCompleted
              ? 'Session Completed!'
              : 'Round Completed!',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              columnWidths: {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(1),
              },
              children: [
                buildTableRow(
                    title: 'Total Rounds',
                    stats: notifier.roundTally.toString()),
                buildTableRow(
                    title: 'No. Cards', stats: notifier.cardTally.toString()),
                buildTableRow(
                    title: 'No. Correct',
                    stats: notifier.correctTally.toString()),
                buildTableRow(
                    title: 'No. Incorrect',
                    stats: notifier.incorrectTally.toString()),
                buildTableRow(
                    title: 'Correct Percentage',
                    stats: '${notifier.correctPercentage}%'),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  notifier.isSessionCompleted
                      ? SizedBox()
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CardPage()));
                          },
                          child: Text('Retest Incorrect Cards'),
                        ),
                  notifier.isSessionCompleted
                      ? SizedBox()
                      : ElevatedButton(
                          onPressed: _savedCards
                              ? null
                              : () async {
                                  for (int i = 0;
                                      i < notifier.incorrectCards.length;
                                      i++) {
                                    await DatabaseManager().insertWord(
                                        word: notifier.incorrectCards[i]);
                                  }
                                  runQuickBox(
                                      context: context,
                                      text: 'Incorrect Cards Saved!');
                                  setState(() {
                                    _savedCards = true;
                                  });
                                },
                          child: Text('Save Incorrect Cards'),
                        ),
                  ElevatedButton(
                    onPressed: () {
                      notifier.reset();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false);
                    },
                    child: Text('Home'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow buildTableRow({required String title, required String stats}) {
    return TableRow(children: [
      TableCell(child: Text(title)),
      TableCell(child: Text(stats, textAlign: TextAlign.right)),
    ]);
  }
}
