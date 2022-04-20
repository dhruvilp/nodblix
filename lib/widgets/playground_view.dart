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
  bool _hasError = false;
  bool _isFetchingToken = false;
  bool _isLoading = false;
  bool _isLoadingWikiData = false;
  bool _customTileExpanded = false;
  var fetchReqTokenErrorMsg = '';
  var wikiDataErrMsg = '';
  var edgesPerConditionOrCompound = List.empty(growable: true);
  late Map<String, dynamic> wikiRespData = {};

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
      } else {
        setState(() {
          _hasError = true;
        });
      }
    } catch (e) {
      debugPrint('==== echo error from ui: $e');
      setState(() {
        _hasError = true;
        fetchReqTokenErrorMsg = e.toString();
      });
    }
  }

  //==== fetch edges by a condition
  Future<void> _fetchEdgesByCondition(String condition) async {
    try {
      edgesPerConditionOrCompound.clear();
      var token = await getRequestToken();
      if (token!.isNotEmpty) {
        List<dynamic> reqResp = await NodblixService.fetchVerticesByCondition(
            condition.toLowerCase(), token);
        if (reqResp.isNotEmpty) {
          setState(() {
            edgesPerConditionOrCompound.addAll(reqResp);
            _isLoading = false;
          });
          // debugPrint('==== resp: ${reqResp['results'][8]['to_id']}');
        } else {
          setState(() {
            _isLoading = false;
            fetchReqTokenErrorMsg = 'Sorry, no data found';
          });
        }
      }
    } catch (e) {
      debugPrint('==== echo error from ui - get edges conditions - : $e');
      setState(() {
        _isLoading = false;
        fetchReqTokenErrorMsg = 'Sorry, no data found!';
      });
    }
  }

  //==== fetch edges by a compound
  Future<void> _fetchEdgesByCompound(String compound) async {
    try {
      edgesPerConditionOrCompound.clear();
      var token = await getRequestToken();
      if (token!.isNotEmpty) {
        List<dynamic> reqResp = await NodblixService.fetchVerticesByCompound(
            compound.toLowerCase(), token);
        if (reqResp.isNotEmpty) {
          setState(() {
            edgesPerConditionOrCompound.addAll(reqResp);
          });
          _isLoading = false;
        } else {
          setState(() {
            _isLoading = false;
            fetchReqTokenErrorMsg = 'Sorry, no data found';
          });
        }
      }
    } catch (e) {
      debugPrint('==== echo error from ui - get edges compounds - : $e');
      setState(() {
        _isLoading = false;
        fetchReqTokenErrorMsg = 'Sorry, no data found!';
      });
    }
  }

  //==== fetch wiki data
  Future<void> _fetchWikiData(String searchWord) async {
    try {
      if (searchWord.isNotEmpty) {
        Map<String, dynamic>? reqResp =
            await NodblixService.fetchWikiData(searchWord);
        if (reqResp!['missing'] == null) {
          print('==== !! $reqResp');
          setState(() {
            wikiRespData = reqResp;
            _isLoadingWikiData = false;
          });
        } else {
          setState(() {
            _isLoadingWikiData = false;
            wikiDataErrMsg = 'Sorry, no data found';
          });
        }
      }
    } catch (e) {
      debugPrint('==== echo error from ui - get wiki data - : $e');
      setState(() {
        _isLoadingWikiData = false;
        wikiDataErrMsg = 'Sorry, no data found!';
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
      child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: edgesPerConditionOrCompound.length,
          itemBuilder: (BuildContext context, int index) {
            return ExpansionTile(
              key: Key(index.toString()),
              title: Text(
                edgesPerConditionOrCompound[index]['to_id'],
                style: const TextStyle(color: NodblixStyles.primaryColor),
              ),
              backgroundColor: Colors.grey[850],
              subtitle: Text(
                _selectedIndex == 0 ? 'Compound' : 'Condition',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              children: <Widget>[
                _isLoadingWikiData
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              NodblixStyles.primaryColor),
                        ),
                      )
                    : (_customTileExpanded)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: (wikiRespData.isNotEmpty &&
                                    wikiRespData.entries.length < 7)
                                ? null
                                : ListTile(
                                    leading: wikiRespData.isNotEmpty
                                        ? CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: wikiRespData.entries
                                                        .firstWhere((element) =>
                                                            element.key ==
                                                            'thumbnail')
                                                        .value['source'] !=
                                                    null
                                                ? Image.network(
                                                    wikiRespData.entries
                                                        .firstWhere((element) =>
                                                            element.key ==
                                                            'thumbnail')
                                                        .value['source'],
                                                    fit: BoxFit.fill,
                                                    // loadingBuilder: (BuildContext context,
                                                    //     Widget child,
                                                    //     ImageChunkEvent? loadingProgress) {
                                                    //   if (loadingProgress == null) {
                                                    //     return child;
                                                    //   }
                                                    //   return Center(
                                                    //     child: CircularProgressIndicator(
                                                    //       value: loadingProgress
                                                    //                   .expectedTotalBytes !=
                                                    //               null
                                                    //           ? loadingProgress
                                                    //                   .cumulativeBytesLoaded /
                                                    //               loadingProgress
                                                    //                   .expectedTotalBytes!
                                                    //           : null,
                                                    //     ),
                                                    //   );
                                                    // },
                                                  )
                                                : const Icon(
                                                    Icons.image_rounded),
                                          )
                                        : null,
                                    title: SelectableText(
                                      wikiRespData.isNotEmpty
                                          ? wikiRespData.entries
                                                  .firstWhere((element) =>
                                                      element.key == 'terms')
                                                  .value['description'][0] ??
                                              ''
                                          : 'No description found!',
                                    ),
                                    subtitle: SelectableText(
                                      wikiRespData.isNotEmpty
                                          ? wikiRespData.entries
                                                  .firstWhere((element) =>
                                                      element.key == 'extract')
                                                  .value ??
                                              ''
                                          : 'No extract found!',
                                    ),
                                    tileColor: Colors.grey[850],
                                  ),
                          )
                        : Container(),
              ],
              onExpansionChanged: (bool expanded) {
                setState(() => _customTileExpanded = expanded);
                setState(() {
                  _isLoadingWikiData = true;
                  wikiRespData = {};
                  wikiDataErrMsg = '';
                });
                _fetchWikiData(edgesPerConditionOrCompound[index]['to_id']);
              },
            );
          }),
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
                      edgesPerConditionOrCompound.clear();
                      _textController.clear();
                      _selectedIndex = index;
                      fetchReqTokenErrorMsg = '';
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
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: TextField(
                                controller: _textController,
                                autofocus: true,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    color: Colors.grey[700],
                                  ),
                                  suffixIcon: _textController.text.isEmpty
                                      ? null
                                      : IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _textController.clear();
                                              fetchReqTokenErrorMsg = '';
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.grey,
                                          ),
                                        ),
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
                                  if (_textController.text.isNotEmpty) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    _selectedIndex == 0
                                        ? await _fetchEdgesByCompound(value)
                                        : await _fetchEdgesByCondition(value);
                                  } else {
                                    null;
                                  }
                                },
                                // onSubmitted: (String value) async {
                                //   await showDialog<void>(
                                //     context: context,
                                //     builder: (BuildContext context) {
                                //       return AlertDialog(
                                //         title: const Text('Thanks!'),
                                //         content: Text(
                                //             'You typed "$value", which has length ${value.characters.length}.'),
                                //         actions: <Widget>[
                                //           TextButton(
                                //             onPressed: () {
                                //               Navigator.pop(context);
                                //             },
                                //             child: const Text('OK'),
                                //           ),
                                //         ],
                                //       );
                                //     },
                                //   );
                                // },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_textController.text.isNotEmpty) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    _selectedIndex == 0
                                        ? await _fetchEdgesByCompound(
                                            _textController.text)
                                        : await _fetchEdgesByCondition(
                                            _textController.text);
                                  } else {
                                    null;
                                  }
                                },
                                style: NodblixStyles.buttonStyle,
                                child: Text(
                                  'Search',
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
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: SelectableText(
                            _selectedIndex == 0
                                ? 'Associated health conditions: '
                                : 'Associated drug compounds: ',
                            textAlign: TextAlign.left,
                            style:
                                Theme.of(context).primaryTextTheme.titleMedium,
                          ),
                        ),
                        Flexible(
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        NodblixStyles.primaryColor),
                                  ),
                                )
                              : fetchReqTokenErrorMsg.isNotEmpty
                                  ? Center(
                                      child: SelectableText(
                                        fetchReqTokenErrorMsg,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : _expansionListBuilder(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: _isFetchingToken
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          NodblixStyles.primaryColor),
                    )
                  : _hasError
                      ? SelectableText(
                          'Error: Failed to get request token! $fetchReqTokenErrorMsg')
                      : SelectableText(
                          'Welcome to the Nodblix Playground!',
                          style: Theme.of(context).primaryTextTheme.headline4,
                        ),
            ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
