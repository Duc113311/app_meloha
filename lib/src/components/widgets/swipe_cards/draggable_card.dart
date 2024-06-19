import 'dart:async';
import 'dart:math';

import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

enum SlideDirection { left, right, up }

enum SlideRegion { inNopeRegion, inLikeRegion, inSuperLikeRegion }

class DraggableCard extends StatefulWidget {
  final Widget? card;
  final Widget? likeTag;
  final Widget? nopeTag;
  final Widget? superLikeTag;
  final bool isDraggable;
  final bool isRestore;
  final bool isReLike;
  final SlideDirection? slideTo;
  final Function(double distance)? onSlideUpdate;
  final Function(Offset offset)? onSlidePositionUpdate;
  final Function(SlideRegion? slideRegion)? onSlideRegionUpdate;
  final Function(SlideDirection? direction)? onSlideOutComplete;
  final Function(SlideDirection? direction)? onSlideDirectionChange;
  final Function(double rotation)? onRotationChange;
  final bool upSwipeAllowed;
  final bool leftSwipeAllowed;
  final bool rightSwipeAllowed;
  final EdgeInsets padding;
  final bool isBackCard;
  final VoidCallback onPanStart;

  const DraggableCard(
      {super.key,
      this.card,
      this.likeTag,
      this.nopeTag,
      this.superLikeTag,
      this.isDraggable = true,
      this.isRestore = false,
      this.onSlideUpdate,
      this.onSlidePositionUpdate,
      this.onSlideOutComplete,
      this.onSlideDirectionChange,
      this.slideTo,
      this.onSlideRegionUpdate,
      this.upSwipeAllowed = false,
      this.leftSwipeAllowed = true,
      this.rightSwipeAllowed = true,
      this.isBackCard = false,
      this.padding = EdgeInsets.zero,
      this.onRotationChange,
      required this.onPanStart,
      required this.isReLike});

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with TickerProviderStateMixin {
  GlobalKey profileCardKey = GlobalKey(debugLabel: 'profile_card_key');
  Offset? cardOffset = const Offset(0.0, 0.0);
  Offset? dragStart;
  Offset? dragPosition;
  Offset? slideBackStart;
  SlideDirection? slideOutDirection;
  SlideRegion? slideRegion;
  late AnimationController slideBackAnimation;
  Tween<Offset>? slideOutTween;
  late AnimationController slideOutAnimation;

  RenderBox? box;
  var topLeft, bottomRight;
  Rect? anchorBounds;

  bool isAnchorInitialized = false;

  bool isRestore = false;
  bool isRestoreAnimationRunning = false;

  @override
  void initState() {
    super.initState();
    slideBackAnimation = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )
      ..addListener(() => setState(() {
            cardOffset = Offset.lerp(
              slideBackStart,
              const Offset(0.0, 0.0),
              Curves.elasticOut.transform(slideBackAnimation.value),
            );

            if (null != widget.onSlideUpdate) {
              widget.onSlideUpdate!(cardOffset!.distance);
            }
            if (null != widget.onSlidePositionUpdate) {
              widget.onSlidePositionUpdate!(cardOffset!);
            }

            if (null != widget.onSlideRegionUpdate) {
              widget.onSlideRegionUpdate!(slideRegion);
            }
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            slideBackStart = null;
            dragPosition = null;
          });
        }
      });

    slideOutAnimation = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          cardOffset = slideOutTween!.evaluate(slideOutAnimation);

          if (null != widget.onSlideUpdate) {
            widget.onSlideUpdate!(cardOffset!.distance);
          }
          if (null != widget.onSlidePositionUpdate) {
            widget.onSlidePositionUpdate!(cardOffset!);
          }

          if (null != widget.onSlideRegionUpdate) {
            widget.onSlideRegionUpdate!(slideRegion);
          }
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            dragPosition = null;
            slideOutTween = null;

            if (widget.onSlideOutComplete != null) {
              widget.onSlideOutComplete!(slideOutDirection);
              slideOutDirection = null;
            }

            if (isRestore) {
              isRestoreAnimationRunning = false;
              isRestore = false;
            }
          });
        }
      });
  }

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.card!.key != oldWidget.card!.key) {
      cardOffset = const Offset(0.0, 0.0);
    }

    if (oldWidget.slideTo == null && widget.slideTo != null) {
      switch (widget.slideTo!) {
        case SlideDirection.left:
          _slideLeft();
          break;
        case SlideDirection.right:
          _slideRight();
          break;
        case SlideDirection.up:
          _slideUp();
          break;
      }
    }

    if (widget.isRestore) {
      isRestoreAnimationRunning = true;
      isRestore = true;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        // Future.delayed(Duration(milliseconds: 1)).then((_) {
        final screenWidth = context.size!.width;
        dragStart = _chooseRandomDragStart();
        slideOutTween = Tween(
          begin: Offset(-2 * screenWidth, 0.0),
          end: const Offset(0.0, 0.0),
        );
        slideOutAnimation.forward(from: 0.0);
      });
    }
    if (widget.isReLike) {
      _slideBackLeft();
    }
  }

  @override
  void dispose() {
    slideOutAnimation.dispose();
    slideBackAnimation.dispose();
    super.dispose();
  }

  Offset _chooseRandomDragStart() {
    final cardContext = profileCardKey.currentContext!;
    final cardTopLeft = (cardContext.findRenderObject() as RenderBox)
        .localToGlobal(const Offset(0.0, 0.0));
    final dragStartY =
        cardContext.size!.height * (Random().nextDouble() < 0.5 ? 0.25 : 0.75) +
            cardTopLeft.dy;
    return Offset(cardContext.size!.width / 2 + cardTopLeft.dx, dragStartY);
  }

  void _slideBackLeft() async {
    await Future.delayed(const Duration(milliseconds: 1)).then((_) {
      final screenWidth = context.size!.width;
      dragStart = _chooseRandomDragStart();
      slideOutTween = Tween(
          begin: Offset(2 * screenWidth, 0.0), end: const Offset(0.0, 0.0));
      slideOutAnimation.forward(from: 0.0);
    });
  }

  void _slideLeft() async {
    await Future.delayed(const Duration(milliseconds: 1)).then((_) {
      final screenWidth = context.size!.width;
      dragStart = _chooseRandomDragStart();
      slideOutTween = Tween(
          begin: const Offset(0.0, 0.0), end: Offset(-2 * screenWidth, 0.0));
      slideOutAnimation.forward(from: 0.0);
    });
  }

  void _slideRight() async {
    await Future.delayed(const Duration(milliseconds: 1)).then((_) {
      final screenWidth = context.size!.width;
      dragStart = _chooseRandomDragStart();
      slideOutTween = Tween(
          begin: const Offset(0.0, 0.0), end: Offset(2 * screenWidth, 0.0));
      slideOutAnimation.forward(from: 0.0);
    });
  }

  void _slideUp() async {
    await Future.delayed(const Duration(milliseconds: 1)).then((_) {
      final screenHeight = context.size!.height;
      dragStart = _chooseRandomDragStart();
      slideOutTween = Tween(
          begin: const Offset(0.0, 0.0), end: Offset(0.0, -2 * screenHeight));
      slideOutAnimation.forward(from: 0.0);
    });
  }

  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;

    if (slideBackAnimation.isAnimating) {
      slideBackAnimation.stop(canceled: true);
    }

    widget.onPanStart();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final isInLeftRegion = (cardOffset!.dx / context.size!.width) < -0.45;
    final isInRightRegion = (cardOffset!.dx / context.size!.width) > 0.45;
    final isInTopRegion = (cardOffset!.dy / context.size!.height) < -0.40;

    setState(() {
      if (isInLeftRegion || isInRightRegion) {
        slideRegion = isInLeftRegion
            ? SlideRegion.inNopeRegion
            : SlideRegion.inLikeRegion;
      } else if (isInTopRegion) {
        slideRegion = SlideRegion.inSuperLikeRegion;
      } else {
        slideRegion = null;
      }

      dragPosition = details.globalPosition;
      cardOffset = dragPosition! - dragStart!;

      if (null != widget.onSlideUpdate) {
        widget.onSlideUpdate!(cardOffset!.distance);
      }
      if (null != widget.onSlidePositionUpdate) {
        widget.onSlidePositionUpdate!(cardOffset!);
      }

      if (null != widget.onSlideRegionUpdate) {
        widget.onSlideRegionUpdate!(slideRegion);
      }
      widget.onRotationChange?.call(_rotation(anchorBounds));
      widget.onSlideDirectionChange?.call(isInTopRegion
          ? SlideDirection.up
          : isInLeftRegion
              ? SlideDirection.left
              : isInRightRegion
                  ? SlideDirection.right
                  : null);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final dragVector = cardOffset! / cardOffset!.distance;

    final isInLeftRegion = (cardOffset!.dx / context.size!.width) < -0.15;
    final isInRightRegion = (cardOffset!.dx / context.size!.width) > 0.15;
    final isInTopRegion = (cardOffset!.dy / context.size!.height) < -0.15;

    setState(() {
      if (isInLeftRegion) {
        if (widget.leftSwipeAllowed) {
          slideOutTween = Tween(
              begin: cardOffset, end: dragVector * (2 * context.size!.width));
          slideOutAnimation.forward(from: 0.0);

          slideOutDirection = SlideDirection.left;
        } else {
          slideBackStart = cardOffset;
          slideBackAnimation.forward(from: 0.0);
        }
      } else if (isInRightRegion) {
        if (widget.rightSwipeAllowed) {
          slideOutTween = Tween(
              begin: cardOffset, end: dragVector * (2 * context.size!.width));
          slideOutAnimation.forward(from: 0.0);

          slideOutDirection = SlideDirection.right;
        } else {
          slideBackStart = cardOffset;
          slideBackAnimation.forward(from: 0.0);
        }
      } else if (isInTopRegion) {
        if (widget.upSwipeAllowed) {
          slideOutTween = Tween(
              begin: cardOffset, end: dragVector * (2 * context.size!.height));
          slideOutAnimation.forward(from: 0.0);

          slideOutDirection = SlideDirection.up;
        } else {
          slideBackStart = cardOffset;
          slideBackAnimation.forward(from: 0.0);
        }
      } else {
        slideBackStart = cardOffset;
        slideBackAnimation.forward(from: 0.0);
      }

      slideRegion = null;
      if (null != widget.onSlideRegionUpdate) {
        widget.onSlideRegionUpdate!(slideRegion);
      }
    });
  }

  double _rotation(Rect? dragBounds) {
    if (dragStart != null) {
      final rotationCornerMultiplier =
          dragStart!.dy >= dragBounds!.top + (dragBounds.height / 2) ? -1 : 1;
      return (pi / 8) *
          (cardOffset!.dx / dragBounds.width) *
          rotationCornerMultiplier;
    } else {
      return 0.0;
    }
  }

  Offset _rotationOrigin(Rect? dragBounds) {
    if (dragStart != null) {
      return dragStart! - dragBounds!.topLeft;
    } else {
      return const Offset(0.0, 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isAnchorInitialized) {
      _initAnchor();
    }

    //Disables dragging card while slide out animation is in progress. Solves
    // issue that fast swipes cause the back card not loading
    if (widget.isBackCard &&
        anchorBounds != null &&
        cardOffset!.dx < anchorBounds!.height) {
      cardOffset = Offset.zero;
    }
    final isRestore = this.isRestore;
    this.isRestore = false;
    return anchorBounds == null
        ? Container(
            color: ThemeUtils.getChatBackgroundColor(),
          )
        : Transform(
            transform:
                Matrix4.translationValues(cardOffset!.dx, cardOffset!.dy, 0.0)
                  ..rotateZ(_rotation(anchorBounds)),
            origin: _rotationOrigin(anchorBounds),
            child: Container(
              key: profileCardKey,
              width: anchorBounds?.width,
              height: anchorBounds?.height,
              padding: widget.padding,
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: widget.card != null && isRestore == false
                    ? Stack(
                        children: [
                          widget.card!,
                          if (widget.likeTag != null &&
                              slideRegion == SlideRegion.inLikeRegion)
                            Positioned(
                              top: 40,
                              left: 20,
                              child: Transform.rotate(
                                angle: 12,
                                child: widget.likeTag,
                              ),
                            ),
                          if (widget.nopeTag != null &&
                              slideRegion == SlideRegion.inNopeRegion)
                            Positioned(
                              top: 40,
                              right: 20,
                              child: Transform.rotate(
                                angle: -12,
                                child: widget.nopeTag,
                              ),
                            ),
                          if (widget.superLikeTag != null &&
                              slideRegion == SlideRegion.inSuperLikeRegion)
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: widget.superLikeTag,
                            ),
                        ],
                      )
                    : Container(),
              ),
            ),
          );
  }

  _initAnchor() async {
    await Future.delayed(const Duration(milliseconds: 3));
    box = context.findRenderObject() as RenderBox?;
    final local = box!.localToGlobal(const Offset(0.0, 0.0));
    topLeft = box!.size.topLeft(local);
    bottomRight = box!.size.bottomRight(box!.localToGlobal(local));
    final tempRect = Rect.fromLTRB(
      topLeft.dx,
      topLeft.dy,
      bottomRight.dx,
      bottomRight.dy,
    );

    if (tempRect.hasNaN) {
      anchorBounds = Rect.fromLTWH(0, 0, box!.size.width, box!.size.height);
    } else {
      anchorBounds = tempRect;
    }

    setState(() {
      isAnchorInitialized = true;
    });
  }
}
