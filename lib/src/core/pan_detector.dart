import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:quiver/core.dart';

/// A class representing the current state of a [PanAwareBuilder].
///
/// See also:
///  * [PanPhysics], a base class for implementing pan behavior
@immutable
class PanState {
  /// Is set to true if a user is currently panning on the screen.
  final bool isPanning;

  /// The distance traveled in pixels since panning started.
  final double distance;

  /// Is set to true if panning resulted in a fling gesture.
  final bool wasFlung;

  const PanState({
    this.distance = 0.0,
    this.isPanning = false,
    this.wasFlung = false,
  });

  /// Returns a copy of this [PanState] instance updated with the given values.
  PanState copyWith({
    bool? isPanning,
    double? distance,
    bool? wasFlung,
  }) =>
      PanState(
        distance: distance ?? this.distance,
        isPanning: isPanning ?? this.isPanning,
        wasFlung: wasFlung ?? this.wasFlung,
      );

  @override
  int get hashCode => hash3(distance, isPanning, wasFlung);

  @override
  bool operator ==(Object other) {
    return other is PanState &&
        distance == other.distance &&
        isPanning == other.isPanning &&
        wasFlung == other.wasFlung;
  }

  @override
  String toString() {
    return "PanState ${{
      "distance": distance,
      "isPanning": isPanning,
      "wasFlung": wasFlung,
    }}";
  }
}

/// Base class for handling pan events and translating them to distances.
///
/// Implementations should react to pan events by implementing [handlePanStart],
/// [handlePanUpdate] and [handlePanEnd] and update the [value] with a
/// corresponding [PanState].
///
/// Since this is a subclass of [ValueNotifier], listeners will be notified,
/// when a new [value] is set.
abstract class PanPhysics extends ValueNotifier<PanState> {
  /// The default duration for pan distances to return to zero.
  static const Duration kDefaultDuration = Duration(milliseconds: 300);

  /// The default curve for pan distances to return to zero.
  static const Curve kDefaultCurve = Curves.linear;

  /// The size of the area to be panned.
  ///
  /// This value is only required by some implementations, e.g.
  /// [CircularPanPhysics].It is set by [PanAwareBuilder]. Therefore users must
  /// not update it manually.
  Size size = const Size(0.0, 0.0);

  /// {@template flutter_fortune_wheel.PanPhysics.duration}
  /// The animation duration used for returning a [PanState.distance] to zero.
  ///
  /// Defaults to [PanPhysics.kDefaultDuration].
  /// {@endtemplate}
  Duration get duration;

  /// {@template flutter_fortune_wheel.PanPhysics.curve}
  /// The type of curve to use for easing the animation when returning
  /// [PanState.distance] to zero.
  ///
  /// Defaults to [PanPhysics.kDefaultCurve].
  /// {@endtemplate}
  Curve get curve;

  PanPhysics() : super(const PanState());

  /// {@template flutter_fortune_wheel.PanPhysics.handlePanStart}
  /// Is called when the start of a pan gesture is detected.
  ///
  /// See also:
  ///  * [GestureDetector.onPanStart], which this method is passed to
  /// {@endtemplate}
  void handlePanStart(DragStartDetails details);

  /// {@template flutter_fortune_wheel.PanPhysics.handlePanUpdate}
  /// Is called when a pan gesture is updated.
  ///
  /// See also:
  ///  * [GestureDetector.onPanUpdate], which this method is passed to
  /// {@endtemplate}
  void handlePanUpdate(DragUpdateDetails details);

  /// {@template flutter_fortune_wheel.PanPhysics.handlePanEnd}
  /// Is called when the end of a pan gesture is detected.
  ///
  /// See also:
  ///  * [GestureDetector.onPanEnd], which this method is passed to
  /// {@endtemplate}
  void handlePanEnd(DragEndDetails details);
}

class NoPanPhysics extends PanPhysics {
  /// {@macro flutter_fortune_wheel.PanPhysics.duration}
  @override
  final Duration duration = Duration.zero;

  /// {@macro flutter_fortune_wheel.PanPhysics.curve}
  @override
  final Curve curve = PanPhysics.kDefaultCurve;

  /// {@macro flutter_fortune_wheel.PanPhysics.handlePanStart}
  @override
  void handlePanEnd(DragEndDetails details) {}

  /// {@macro flutter_fortune_wheel.PanPhysics.handlePanUpdate}
  @override
  void handlePanStart(DragStartDetails details) {}

  /// {@macro flutter_fortune_wheel.PanPhysics.handlePanEnd}
  @override
  void handlePanUpdate(DragUpdateDetails details) {}
}

/// Calculates panned distances by assuming a circular shape.
///
/// This requires [size] to be set to the available area for detecting on which
/// side of the circle a pan event occurs.
///
/// For more details on the actual implementation, you can refer to this
/// [article](https://fireship.io/snippets/circular-drag-flutter/).
///
/// See also:
///  * [DirectionalPanPhysics], which is an alternative implementation
class CircularPanPhysics extends PanPhysics {
  /// {@macro flutter_fortune_wheel.PanPhysics.duration}
  @override
  final Duration duration;

  /// {@macro flutter_fortune_wheel.PanPhysics.curve}
  @override
  final Curve curve;

  CircularPanPhysics({
    this.duration = PanPhysics.kDefaultDuration,
    this.curve = PanPhysics.kDefaultCurve,
  });

  /// {@macro flutter_fortune_wheel.PanPhysics.handlePanStart}
  @override
  void handlePanStart(DragStartDetails details) {
    value = const PanState(isPanning: true);
  }

  /// {@macro flutter_fortune_wheel.PanPhysics.handlePanUpdate}
  @override
  void handlePanUpdate(DragUpdateDetails details) {
    final Offset center = Offset(
      size.width / 2,
      math.min(size.width, size.height) / 2,
    );
    final bool onTop = details.localPosition.dy <= center.dy;
    final bool onLeftSide = details.localPosition.dx <= center.dx;
    final bool onRightSide = !onLeftSide;
    final bool onBottom = !onTop;

    final bool panUp = details.delta.dy <= 0.0;
    final bool panLeft = details.delta.dx <= 0.0;
    final bool panRight = !panLeft;
    final bool panDown = !panUp;

    final double yChange = details.delta.dy.abs();
    final double xChange = details.delta.dx.abs();

    final double verticalRotation =
        (onRightSide && panDown) || (onLeftSide && panUp)
            ? yChange
            : yChange * -1;

    final double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    final double rotationalChange = verticalRotation + horizontalRotation;

    value = value.copyWith(distance: value.distance + rotationalChange);
  }

  /// {@macro flutter_fortune_wheel.PanPhysics.handlePanEnd}
  @override
  void handlePanEnd(DragEndDetails details) {
    if (value.distance.abs() > 100 &&
        details.velocity.pixelsPerSecond.distance.abs() > 300) {
      value = value.copyWith(isPanning: false, wasFlung: true);
    } else {
      value = value.copyWith(isPanning: false);
    }
  }
}

/// A widget builder, which is aware of pan gestures and handles them.
///
/// Pan events are handled by the underlying [physics]. Whenever a new
/// [PanState] is available, the given [builder] is called wit the new
/// information.
///
/// If a new state signals that a fling/swipe gesture occurred by setting
/// [PanState.wasFlung] to true, the [onFling] callback is called.
///
/// See also:
///  * [PanPhysics], which implements pan behavior
class PanAwareBuilder extends StatefulWidget {
  const PanAwareBuilder({
    Key? key,
    required this.builder,
    required this.physics,
    this.behavior,
    this.onFling,
  }) : super(key: key);

  /// The builder, which is called with the current [PanState] whenever it
  /// changes.
  final Widget Function(BuildContext, PanState) builder;

  /// The [PanPhysics] to be used for calculating pan states.
  final PanPhysics physics;

  /// The [HitTestBehavior] to be used by the underlying [GestureDetector].
  final HitTestBehavior? behavior;

  /// The callback to be called whenever a fling/swipe gesture is detected.
  final VoidCallback? onFling;

  @override
  _PanAwareBuilderState createState() => _PanAwareBuilderState();
}

class _PanAwareBuilderState extends State<PanAwareBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  late PanState _panState;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: widget.physics.duration);
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: widget.physics.curve,
    );
    _panState = widget.physics.value;
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  Future<void> _onPanStateUpdate(PanState value) async {
    bool oldValue = _panState.isPanning;
    bool isPanningValueChange = _panState.isPanning != value.isPanning;
    _panState = value;
    unawaited(_useValueIsPanningChanged(oldValue, isPanningValueChange));
    unawaited(_useValueWasFlungChanged(_panState.wasFlung));
  }

  Future<void> _useValueIsPanningChanged(
      bool oldValue, bool isValueChange) async {
    if (isValueChange) {
      if (!oldValue) {
        _animationController.reset();
      } else {
        await _animationController.forward(from: 0.0);
      }
    }
  }

  Future<void> _useValueWasFlungChanged(bool wasFlung) async {
    if (wasFlung) {
      await Future.microtask(() => widget.onFling?.call());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<PanState>(
      valueListenable: widget.physics,
      builder: (BuildContext context, PanState value, _) {
        _onPanStateUpdate(value);
        return LayoutBuilder(builder: (context, constraints) {
          widget.physics.size =
              Size(constraints.maxWidth, constraints.maxHeight);
          return GestureDetector(
            behavior: widget.behavior,
            onPanStart: widget.physics.handlePanStart,
            onPanUpdate: widget.physics.handlePanUpdate,
            onPanEnd: widget.physics.handlePanEnd,
            child: AnimatedBuilder(
                animation: _animation,
                builder: (context, _) {
                  final mustApplyEasing = _animationController.isAnimating ||
                      _animationController.status == AnimationStatus.completed;

                  if (mustApplyEasing) {
                    _panState = _panState.copyWith(
                      distance: _panState.distance * (1 - _animation.value),
                    );
                  }

                  return Builder(
                    builder: (context) => widget.builder(context, _panState),
                  );
                }),
          );
        });
      },
    );
  }
}
