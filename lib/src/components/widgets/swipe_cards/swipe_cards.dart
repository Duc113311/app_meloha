library swipe_cards;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'draggable_card.dart';
import 'profile_card.dart';

class SwipeCards extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final Widget? likeTag;
  final Widget? nopeTag;
  final Widget? superLikeTag;
  final MatchEngine matchEngine;
  final Function? onCardsMove;
  final Function onStackFinished;
  final Function()? onEndList;
  final Function(SwipeItem, int)? itemChanged;
  final Function(SlideDirection? direction)? onSlideDirectionChange;
  final Function(double rotation)? onRotationChange;
  final VoidCallback onPanStart;
  final bool fillSpace;
  final bool isReLike;
  final bool upSwipeAllowed;
  final bool leftSwipeAllowed;
  final bool rightSwipeAllowed;

  const SwipeCards({
    Key? key,
    required this.matchEngine,
    this.onCardsMove,
    required this.onStackFinished,
    required this.itemBuilder,
    this.likeTag,
    this.nopeTag,
    this.superLikeTag,
    this.onSlideDirectionChange,
    this.onRotationChange,
    this.fillSpace = true,
    this.upSwipeAllowed = false,
    this.leftSwipeAllowed = true,
    this.rightSwipeAllowed = true,
    this.onEndList,
    this.itemChanged,
    required this.onPanStart,
    required this.isReLike,
  }) : super(key: key);

  @override
  _SwipeCardsState createState() => _SwipeCardsState();
}

class _SwipeCardsState extends State<SwipeCards> {
  Key? _frontCard;
  SwipeItem? _currentItem;
  double _nextCardScale = 0.9;
  SlideRegion? slideRegion;

  bool isRunningRestore = false;
  bool isRunningReLike = false;

  @override
  void initState() {
    widget.matchEngine.addListener(_onMatchEngineChange);
    _currentItem = widget.matchEngine.currentItem;
    if (_currentItem != null) {
      _currentItem!.addListener(_onMatchChange);
    }
    int? currentItemIndex = widget.matchEngine._currentItemIndex;
    if (currentItemIndex != null) {
      _frontCard = Key(currentItemIndex.toString());
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_currentItem != null) {
      _currentItem!.removeListener(_onMatchChange);
    }
    widget.matchEngine.removeListener(_onMatchEngineChange);
    super.dispose();
  }

  @override
  void didUpdateWidget(SwipeCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.matchEngine != oldWidget.matchEngine) {
      oldWidget.matchEngine.removeListener(_onMatchEngineChange);
      widget.matchEngine.addListener(_onMatchEngineChange);
    }
    if (_currentItem != null) {
      _currentItem!.removeListener(_onMatchChange);
    }
    _currentItem = widget.matchEngine.currentItem;
    if (_currentItem != null) {
      _currentItem!.addListener(_onMatchChange);
    }
  }

  void _onMatchEngineChange() {
    setState(() {
      if (_currentItem != null) {
        _currentItem!.removeListener(_onMatchChange);
      }
      _currentItem = widget.matchEngine.currentItem;
      if (_currentItem != null) {
        _currentItem!.addListener(_onMatchChange);
      }
      _frontCard = Key(widget.matchEngine._currentItemIndex.toString());
    });
  }

  void _onMatchChange() {
    setState(() {
      //match has been changed
    });
  }

  Widget _buildFrontCard() {
    return ProfileCard(
      key: _frontCard,
      child: widget.itemBuilder(context, widget.matchEngine._currentItemIndex!),
    );
  }

  Widget _buildBackCard() {
    return Transform(
      transform: Matrix4.identity()..scale(_nextCardScale, _nextCardScale),
      alignment: Alignment.center,
      child: ProfileCard(
        child: widget.itemBuilder(context, widget.matchEngine._nextItemIndex!),
      ),
    );
  }

  void _onSlideUpdate(double distance) {
    setState(() {
      _nextCardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
    });
  }

  void _onSlidePositionUpdate(Offset offset) {
    widget.onCardsMove!(offset);
  }

  void _onSlideRegion(SlideRegion? region) {
    setState(() {
      slideRegion = region;
      SwipeItem? currentMatch = widget.matchEngine.currentItem;
      if (currentMatch != null && currentMatch.onSlideUpdate != null) {
        currentMatch.onSlideUpdate!(region);
      }
    });
  }

  void _onSlideOutComplete(SlideDirection? direction) {
    SwipeItem? currentMatch = widget.matchEngine.currentItem;
    switch (direction) {
      case SlideDirection.left:
        currentMatch?.nope();
        break;
      case SlideDirection.right:
        currentMatch?.like();
        break;
      case SlideDirection.up:
        currentMatch?.superLike();
        break;
      case null:
        break;
    }

    if (widget.matchEngine._nextItemIndex! <
        widget.matchEngine._swipeItems!.length) {
      if (isRunningRestore) {
        isRunningRestore = false;
      } else if (isRunningReLike) {
        isRunningReLike = false;
      } else {
        widget.itemChanged?.call(
            widget.matchEngine.nextItem!, widget.matchEngine._nextItemIndex!);
      }
    } else {
      widget.onEndList?.call();
    }

    widget.matchEngine.cycleMatch();
    if (widget.matchEngine.currentItem == null) {
      widget.onStackFinished();
    }
  }

  SlideDirection? _desiredSlideOutDirection() {
    switch (widget.matchEngine.currentItem!.decision) {
      case Decision.nope:
        return SlideDirection.left;
      case Decision.like:
        return SlideDirection.right;
      case Decision.superLike:
        return SlideDirection.up;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRestore = widget.matchEngine.wasRewind;
    final isReLike = widget.isReLike;
    widget.matchEngine.wasRewind = false;
    if (isRestore) {
      isRunningRestore = true;
      widget.itemChanged?.call(widget.matchEngine.currentItem!,
          widget.matchEngine._currentItemIndex!);
    }
    if (isReLike) {
      isRunningReLike = true;
      widget.itemChanged?.call(widget.matchEngine.currentItem!,
          widget.matchEngine._currentItemIndex!);
    }

    return Stack(
      fit: widget.fillSpace == true ? StackFit.expand : StackFit.loose,
      children: <Widget>[
        if (widget.matchEngine.nextItem != null)
          DraggableCard(
            onPanStart: widget.onPanStart,
            isDraggable: true,
            card: _buildBackCard(),
            upSwipeAllowed: widget.upSwipeAllowed,
            leftSwipeAllowed: widget.leftSwipeAllowed,
            rightSwipeAllowed: widget.rightSwipeAllowed,
            isBackCard: true,
            isRestore: false,
            isReLike: false,
          ),
        if (widget.matchEngine.currentItem != null)
          DraggableCard(
            onPanStart: widget.onPanStart,
            card: _buildFrontCard(),
            likeTag: widget.likeTag,
            nopeTag: widget.nopeTag,
            superLikeTag: widget.superLikeTag,
            slideTo: _desiredSlideOutDirection(),
            onSlideUpdate: _onSlideUpdate,
            onSlidePositionUpdate: _onSlidePositionUpdate,
            onSlideRegionUpdate: _onSlideRegion,
            onSlideOutComplete: _onSlideOutComplete,
            upSwipeAllowed: widget.upSwipeAllowed,
            leftSwipeAllowed: widget.leftSwipeAllowed,
            rightSwipeAllowed: widget.rightSwipeAllowed,
            onSlideDirectionChange: widget.onSlideDirectionChange,
            onRotationChange: widget.onRotationChange,
            isBackCard: false,
            isRestore: isRestore,
            isReLike: isReLike,
          )
      ],
    );
  }
}

class MatchEngine extends ChangeNotifier {
  List<SwipeItem>? _swipeItems;
  int? _currentItemIndex;
  int? _nextItemIndex;

  MatchEngine({
    List<SwipeItem>? swipeItems,
  }) : _swipeItems = swipeItems {
    _currentItemIndex = 0;
    _nextItemIndex = 1;
  }

  void update(List<SwipeItem>? swipeItems) {
    _swipeItems = swipeItems;
  }

  SwipeItem? get currentItem => _currentItemIndex! < _swipeItems!.length
      ? _swipeItems![_currentItemIndex!]
      : null;

  SwipeItem? get nextItem => _nextItemIndex! < _swipeItems!.length
      ? _swipeItems![_nextItemIndex!]
      : null;

  SwipeItem? get lastItem =>
      _currentItemIndex! > 0 ? _swipeItems![_currentItemIndex! - 1] : null;

  void cycleMatch() {
    if (currentItem!.decision != Decision.undecided) {
      currentItem!.resetMatch();
      _currentItemIndex = _nextItemIndex;
      _nextItemIndex = _nextItemIndex! + 1;
      wasRewind = false;
      // wasNope = false;
      notifyListeners();
    }
  }

  bool wasRewind = false;
  bool wasNope = false;

  void rewindMatch() {
    if (canRewind) {
      currentItem!.resetMatch();
      _nextItemIndex = _currentItemIndex;
      _currentItemIndex = _currentItemIndex! - 1;
      currentItem!.resetMatch();
      wasRewind = true;
      wasNope = false;

      notifyListeners();
    }
  }

  bool get canRewind {
    return _currentItemIndex != 0 && wasNope;
  }
}

class SwipeItem extends ChangeNotifier {
  final dynamic content;
  final Function? likeAction;
  final Function? superlikeAction;
  final Function? nopeAction;
  final Future Function(SlideRegion? slideRegion)? onSlideUpdate;
  Decision decision = Decision.undecided;

  SwipeItem({
    this.content,
    this.likeAction,
    this.superlikeAction,
    this.nopeAction,
    this.onSlideUpdate,
  });

  void slideUpdateAction(SlideRegion? slideRegion) async {
    try {
      await onSlideUpdate!(slideRegion);
    } catch (e) {}
    notifyListeners();
  }

  void like() {
    if (decision == Decision.undecided) {
      decision = Decision.like;
      try {
        likeAction?.call();
      } catch (e) {
        debugPrint("like action: $e");
      }
      notifyListeners();
    }
  }

  void nope() {
    if (decision == Decision.undecided) {
      decision = Decision.nope;
      try {
        nopeAction?.call();
      } catch (e) {}
      notifyListeners();
    }
  }

  void superLike() {
    if (decision == Decision.undecided) {
      decision = Decision.superLike;
      try {
        superlikeAction?.call();
      } catch (e) {}
      notifyListeners();
    }
  }

  void resetMatch() {
    if (decision != Decision.undecided) {
      decision = Decision.undecided;
      notifyListeners();
    }
  }
}

enum Decision { undecided, nope, like, superLike }
