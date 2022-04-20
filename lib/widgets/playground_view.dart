import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nodblix/models/vertex_model.dart';
import 'package:nodblix/services/nodblix_service.dart';
import 'package:nodblix/styles.dart';

import '../services/storage_manager.dart';

class PlaygroundView extends StatefulWidget {
  const PlaygroundView({Key? key}) : super(key: key);

  @override
  State<PlaygroundView> createState() => _PlaygroundViewState();
}

class _PlaygroundViewState extends State<PlaygroundView> {
  int _selectedIndex = 0;
  late TextEditingController _textController;
  bool _hasToken = false;
  bool _isFetchingToken = false;
  var fetchReqTokenErrorMsg = '';
  var edgesPerCondition = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _hasRequestToken();
    _textController = TextEditingController(text: '');
  }

  //==== fetch a request token
  Future<void> _fetchRequestToken() async {
    try {
      Map<String, dynamic>? reqTokenResp =
          await NodblixService.fetchRequestToken();
      if (reqTokenResp!.isNotEmpty) {
        setState(() {
          _hasToken = true;
          _isFetchingToken = false;
        });
        await persistRequestToken(
            reqTokenResp['token'], reqTokenResp['expiration']);
      }
    } catch (e) {
      debugPrint('==== echo error from ui: $e');
      setState(() {
        fetchReqTokenErrorMsg = e.toString();
      });
    }
  }

  //==== fetch edges by a condition
  Future<void> _fetchEdgesByCondition(String condition) async {
    try {
      var token = await getRequestToken();
      if (token!.isNotEmpty) {
        Map<String, dynamic>? reqResp =
            await NodblixService.fetchVerticesByCondition(
                condition.toLowerCase(), token);
        if (reqResp!.isNotEmpty) {
          setState(() {
            edgesPerCondition.addAll(reqResp['results']);
          });
          debugPrint('==== resp: ${reqResp['results'][8]['to_id']}');
        }
      }
    } catch (e) {
      debugPrint('==== echo error from ui: $e');
      setState(() {
        fetchReqTokenErrorMsg = e.toString();
      });
    }
  }

  //==== validate if token exists ? otherwise, get one
  void _hasRequestToken() async {
    var hasToken = await hasRequestToken();

    if (!hasToken) {
      setState(() {
        _isFetchingToken = true;
      });
      await _fetchRequestToken();
    } else {
      debugPrint('=== token found!!');
      setState(() {
        _hasToken = true;
      });
    }
  }

  Widget _expansionListBuilder() {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            edgesPerCondition[index]['directed'] = !isExpanded;
          });
        },
        children: edgesPerCondition.map<ExpansionPanel>((vertex) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: SelectableText(vertex['to_id']),
                selectedColor: Colors.pink,
              );
            },
            body: ListTile(
                title: SelectableText(vertex['to_id']),
                subtitle: const SelectableText(
                    'To delete this panel, tap the trash can icon'),
                trailing: const Icon(Icons.delete),
                onTap: () {
                  setState(() {
                    edgesPerCondition
                        .removeWhere((currentItem) => vertex == currentItem);
                  });
                }),
            isExpanded: vertex['directed'],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_hasToken && !_isFetchingToken)
          ? Row(
              children: <Widget>[
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  backgroundColor: Colors.grey[900],
                  selectedIconTheme:
                      IconThemeData(color: Theme.of(context).primaryColor),
                  selectedLabelTextStyle:
                      Theme.of(context).primaryTextTheme.bodyMedium!.copyWith(
                            color: NodblixStyles.primaryColor,
                          ),
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.selected,
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(FontAwesomeIcons.pills),
                      selectedIcon: Icon(FontAwesomeIcons.pills),
                      label: Text('Compound'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(FontAwesomeIcons.virus),
                      selectedIcon: Icon(FontAwesomeIcons.viruses),
                      label: Text('Condition'),
                    ),
                  ],
                ),
                VerticalDivider(
                  thickness: 1,
                  width: 1,
                  color: Colors.grey[850],
                ),
                // This is the main content.
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  controller: _textController,
                                  decoration: InputDecoration(
                                    hintText: _selectedIndex == 0
                                        ? 'Enter drug name (ex: Placebo)'
                                        : 'Enter medical condition (ex: Asthma)',
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    labelText: _selectedIndex == 0
                                        ? 'Compound'
                                        : 'Condition',
                                  ),
                                  onSubmitted: (String value) async {
                                    await showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Thanks!'),
                                          content: Text(
                                              'You typed "$value", which has length ${value.characters.length}.'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    if (_textController.text.isNotEmpty) {
                                      await _fetchEdgesByCondition(
                                          _textController.text);
                                    } else {
                                      null;
                                    }
                                  },
                                  style: NodblixStyles.buttonStyle,
                                  icon: Icon(
                                    FontAwesomeIcons.magnifyingGlass,
                                    color: Colors.grey[800],
                                  ),
                                  label: Text(
                                    ' Search',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Text('selectedIndex: $_selectedIndex'),
                          ),
                          Flexible(
                            child: _expansionListBuilder(),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: _isFetchingToken
                  ? const CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          NodblixStyles.primaryColor),
                    )
                  : SelectableText(
                      'Error: Failed to get request token! $fetchReqTokenErrorMsg'),
            ),
    );
  }
}
