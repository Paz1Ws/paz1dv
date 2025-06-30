import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:paz1dv/screens/hero_detail_page.dart';

class AnimationsTestScreen extends StatefulWidget {
  const AnimationsTestScreen({super.key});

  @override
  State<AnimationsTestScreen> createState() => _AnimationsTestScreenState();
}

class _AnimationsTestScreenState extends State<AnimationsTestScreen>
    with TickerProviderStateMixin {
  // Animation controllers and state variables
  bool _isExpanded = false;
  bool _isVisible = true;
  bool _isAligned = false;
  bool _isPositioned = false;
  bool _hasPadding = false;
  bool _showFirst = true;
  bool _isLargeText = false;
  bool _isElevated = false;
  bool _showWidget = true;
  bool _isPlayingIcon = false;
  bool _isDarkTheme = false;
  bool _isLargeSize = false;
  bool _showBarrier = false;

  late AnimationController _iconController;
  Key _switcherKey = UniqueKey();

  // New animation controllers for explicit animations
  late AnimationController _explicitController;
  late AnimationController _transitionsController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _sizeAnimation;
  late Animation<AlignmentGeometry> _alignAnimation;
  late Animation<RelativeRect> _positionedAnimation;
  late Animation<Decoration> _decorationAnimation;
  late Animation<TextStyle> _textStyleAnimation;
  late Animation<Color?> _colorTween;
  late Animation<double> _curvedAnimation;
  late Animation<double> _intervalAnimation;

  // New state variables
  bool _explicitAnimationRunning = false;
  bool _transitionsRunning = false;

  // New controllers for physics and staggered animations
  late AnimationController _physicsController;
  late AnimationController _staggeredController;
  late AnimationController _heroController;

  // Physics animations
  late Animation<double> _springAnimation;
  late Animation<double> _frictionAnimation;
  late Animation<double> _gravityAnimation;

  // Staggered animations
  late Animation<double> _staggered1;
  late Animation<double> _staggered2;
  late Animation<double> _staggered3;
  late Animation<Color?> _sequenceColor;

  // Special animations state
  final bool _physicsRunning = false;
  bool _staggeredRunning = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<int> _listItems = [0, 1, 2];
  int _nextItem = 3;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Initialize explicit animation controllers
    _explicitController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _transitionsController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Initialize new controllers
    _physicsController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _staggeredController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _heroController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Setup explicit animations
    _setupExplicitAnimations();
    _setupTransitionAnimations();
    _setupPhysicsAnimations();
    _setupStaggeredAnimations();
  }

  void _setupExplicitAnimations() {
    _colorTween = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(_explicitController);

    _curvedAnimation = CurvedAnimation(
      parent: _explicitController,
      curve: Curves.elasticOut,
    );

    _intervalAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _explicitController,
        curve: const Interval(0.5, 1.0, curve: Curves.bounceOut),
      ),
    );
  }

  void _setupTransitionAnimations() {
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _transitionsController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _transitionsController,
            curve: Curves.elasticOut,
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _transitionsController, curve: Curves.bounceOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: _transitionsController, curve: Curves.linear),
    );

    _sizeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _transitionsController, curve: Curves.easeInOut),
    );

    _alignAnimation =
        Tween<AlignmentGeometry>(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).animate(
          CurvedAnimation(
            parent: _transitionsController,
            curve: Curves.easeInOut,
          ),
        );

    _positionedAnimation =
        RelativeRectTween(
          begin: const RelativeRect.fromLTRB(20, 20, 200, 100),
          end: const RelativeRect.fromLTRB(200, 100, 20, 20),
        ).animate(
          CurvedAnimation(
            parent: _transitionsController,
            curve: Curves.easeInOut,
          ),
        );

    _decorationAnimation =
        DecorationTween(
          begin: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          end: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(5, 5),
              ),
            ],
          ),
        ).animate(
          CurvedAnimation(
            parent: _transitionsController,
            curve: Curves.easeInOut,
          ),
        );

    _textStyleAnimation =
        TextStyleTween(
          begin: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
          end: const TextStyle(
            fontSize: 32,
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ).animate(
          CurvedAnimation(
            parent: _transitionsController,
            curve: Curves.easeInOut,
          ),
        );
  }

  void _setupPhysicsAnimations() {
    _springAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_physicsController);

    _frictionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_physicsController);

    _gravityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_physicsController);
  }

  void _setupStaggeredAnimations() {
    _staggered1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggeredController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _staggered2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggeredController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );

    _staggered3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggeredController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _sequenceColor = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.green),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.green, end: Colors.blue),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.blue, end: Colors.purple),
        weight: 1.0,
      ),
    ]).animate(_staggeredController);
  }

  @override
  void dispose() {
    _iconController.dispose();
    _explicitController.dispose();
    _transitionsController.dispose();
    _physicsController.dispose();
    _staggeredController.dispose();
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Animations Test'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.headphones),
            onPressed: () => _navigateToHeroPage(),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Implicit Animations Section
                _buildSectionHeader('🎯 Implicit Animations'),
                _buildAnimationSection(
                  'AnimatedContainer',
                  _buildAnimatedContainer(),
                  () => setState(() => _isExpanded = !_isExpanded),
                ),
                _buildAnimationSection(
                  'AnimatedOpacity',
                  _buildAnimatedOpacity(),
                  () => setState(() => _isVisible = !_isVisible),
                ),
                _buildAnimationSection(
                  'AnimatedAlign',
                  _buildAnimatedAlign(),
                  () => setState(() => _isAligned = !_isAligned),
                ),
                _buildAnimationSection(
                  'AnimatedPositioned',
                  _buildAnimatedPositioned(),
                  () => setState(() => _isPositioned = !_isPositioned),
                ),
                _buildAnimationSection(
                  'AnimatedPadding',
                  _buildAnimatedPadding(),
                  () => setState(() => _hasPadding = !_hasPadding),
                ),
                _buildAnimationSection(
                  'AnimatedCrossFade',
                  _buildAnimatedCrossFade(),
                  () => setState(() => _showFirst = !_showFirst),
                ),
                _buildAnimationSection(
                  'AnimatedDefaultTextStyle',
                  _buildAnimatedDefaultTextStyle(),
                  () => setState(() => _isLargeText = !_isLargeText),
                ),
                _buildAnimationSection(
                  'AnimatedPhysicalModel',
                  _buildAnimatedPhysicalModel(),
                  () => setState(() => _isElevated = !_isElevated),
                ),
                _buildAnimationSection(
                  'AnimatedSwitcher',
                  _buildAnimatedSwitcher(),
                  () => setState(() {
                    _showWidget = !_showWidget;
                    _switcherKey = UniqueKey();
                  }),
                ),
                _buildAnimationSection(
                  'AnimatedIcon',
                  _buildAnimatedIcon(),
                  () {
                    setState(() => _isPlayingIcon = !_isPlayingIcon);
                    if (_isPlayingIcon) {
                      _iconController.forward();
                    } else {
                      _iconController.reverse();
                    }
                  },
                ),
                _buildAnimationSection(
                  'AnimatedTheme',
                  _buildAnimatedTheme(),
                  () => setState(() => _isDarkTheme = !_isDarkTheme),
                ),
                _buildAnimationSection(
                  'AnimatedSize',
                  _buildAnimatedSize(),
                  () => setState(() => _isLargeSize = !_isLargeSize),
                ),
                _buildAnimationSection(
                  'AnimatedModalBarrier',
                  _buildAnimatedModalBarrierButton(),
                  () => setState(() => _showBarrier = !_showBarrier),
                ),

                // Explicit Animations Section
                _buildSectionHeader('⚡ Explicit Animations'),
                _buildAnimationSection(
                  'AnimationController + Tween + CurvedAnimation',
                  _buildExplicitAnimations(),
                  () {
                    setState(
                      () => _explicitAnimationRunning =
                          !_explicitAnimationRunning,
                    );
                    if (_explicitAnimationRunning) {
                      _explicitController.repeat(reverse: true);
                    } else {
                      _explicitController.stop();
                      _explicitController.reset();
                    }
                  },
                ),
                _buildAnimationSection(
                  'AnimatedBuilder',
                  _buildAnimatedBuilder(),
                  () {
                    if (_explicitController.isAnimating) {
                      _explicitController.stop();
                      _explicitController.reset();
                    } else {
                      _explicitController.forward();
                    }
                  },
                ),

                // Predefined Transitions Section
                _buildSectionHeader('🔄 Predefined Transitions'),
                _buildAnimationSection(
                  'All Transitions Showcase',
                  _buildAllTransitions(),
                  () {
                    setState(() => _transitionsRunning = !_transitionsRunning);
                    if (_transitionsRunning) {
                      _transitionsController.repeat(reverse: true);
                    } else {
                      _transitionsController.stop();
                      _transitionsController.reset();
                    }
                  },
                ),

                // Physics-based Animations Section
                _buildSectionHeader('🏃 Physics-based Animations'),
                _buildAnimationSection(
                  'SpringSimulation',
                  _buildSpringAnimation(),
                  () => _runSpringSimulation(),
                ),
                _buildAnimationSection(
                  'FrictionSimulation',
                  _buildFrictionAnimation(),
                  () => _runFrictionSimulation(),
                ),
                _buildAnimationSection(
                  'GravitySimulation',
                  _buildGravityAnimation(),
                  () => _runGravitySimulation(),
                ),

                // Staggered Animations Section
                _buildSectionHeader('🔗 Staggered Animations'),
                _buildAnimationSection(
                  'TweenSequence + Intervals',
                  _buildStaggeredAnimations(),
                  () {
                    setState(() => _staggeredRunning = !_staggeredRunning);
                    if (_staggeredRunning) {
                      _staggeredController.repeat(reverse: true);
                    } else {
                      _staggeredController.stop();
                      _staggeredController.reset();
                    }
                  },
                ),

                // Special Animations Section
                _buildSectionHeader('🌟 Special Animations'),
                _buildAnimationSection(
                  'Hero Animation (Tap app bar icon)',
                  _buildHeroDemo(),
                  () => _navigateToHeroPage(),
                ),
                _buildAnimationSection(
                  'AnimatedList',
                  _buildAnimatedList(),
                  () => _addListItem(),
                ),
                _buildAnimationSection(
                  'ReorderableListView',
                  _buildReorderableList(),
                  () => {}, // No action needed, reordering is built-in
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
          if (_showBarrier) _buildAnimatedModalBarrier(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildAnimationSection(
    String title,
    Widget child,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 12),
            child,
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: Text(
                'Toggle Animation',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedContainer() {
    return Column(
      spacing: 8,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
            width: _isExpanded ? 150 : 120,
            height: 20,
            decoration: BoxDecoration(
              color: _isExpanded ? Colors.red : Colors.blue,
              borderRadius: BorderRadius.circular(_isExpanded ? 30 : 10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: _isExpanded ? 20 : 5,
                  offset: Offset(0, _isExpanded ? 10 : 2),
                ),
              ],
            ),
            child: const Icon(Icons.expand, color: Colors.white, size: 30),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
            width: _isExpanded ? 75 : 150,
            height: 20,
            decoration: BoxDecoration(
              color: _isExpanded ? Colors.red : Colors.blue,
              borderRadius: BorderRadius.circular(_isExpanded ? 30 : 10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: _isExpanded ? 20 : 5,
                  offset: Offset(0, _isExpanded ? 10 : 2),
                ),
              ],
            ),
            child: const Icon(Icons.expand, color: Colors.white, size: 30),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
            width: _isExpanded ? 120 : 100,
            height: 20,
            decoration: BoxDecoration(
              color: _isExpanded ? Colors.red : Colors.blue,
              borderRadius: BorderRadius.circular(_isExpanded ? 30 : 10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: _isExpanded ? 20 : 5,
                  offset: Offset(0, _isExpanded ? 10 : 2),
                ),
              ],
            ),
            child: const Icon(Icons.expand, color: Colors.white, size: 30),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedOpacity() {
    return Center(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 600),
        opacity: _isVisible ? 1.0 : 0.0,
        child: Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.favorite, color: Colors.white, size: 60),
        ),
      ),
    );
  }

  Widget _buildAnimatedAlign() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 700),
        curve: Curves.bounceOut,
        alignment: _isAligned ? Alignment.topRight : Alignment.bottomLeft,
        child: Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.rectangle,
          ),
          child: const Icon(Icons.rocket_launch, color: Colors.white, size: 40),
        ),
      ),
    );
  }

  Widget _buildAnimatedPositioned() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            left: _isPositioned ? 250 : 20,
            top: _isPositioned ? 20 : 120,
            child: Container(
              width: 100,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.flight, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedPadding() {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 600),
      padding: EdgeInsets.all(_hasPadding ? 40.0 : 8.0),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.padding, color: Colors.white, size: 40),
      ),
    );
  }

  Widget _buildAnimatedCrossFade() {
    return Center(
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 800),
        crossFadeState: _showFirst
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstChild: Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            color: Colors.indigo,
            shape: BoxShape.rectangle,
          ),
          child: const Icon(Icons.square, color: Colors.white, size: 80),
        ),
        secondChild: Container(
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            color: Colors.pink,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.circle, color: Colors.white, size: 80),
        ),
      ),
    );
  }

  Widget _buildAnimatedDefaultTextStyle() {
    return Center(
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 500),
        style: TextStyle(
          fontSize: _isLargeText ? 32 : 16,
          color: _isLargeText ? Colors.red : Colors.black,
          fontWeight: _isLargeText ? FontWeight.bold : FontWeight.normal,
        ),
        child: const Text('Animated Text Style!'),
      ),
    );
  }

  Widget _buildAnimatedPhysicalModel() {
    return Center(
      child: AnimatedPhysicalModel(
        duration: const Duration(milliseconds: 5000),
        curve: Curves.easeInOutCubicEmphasized,
        shape: BoxShape.rectangle,
        elevation: _isElevated ? 20.0 : 2.0,
        color: _isElevated ? Colors.deepOrange : Colors.amber,
        shadowColor: Colors.black,
        borderRadius: BorderRadius.circular(_isElevated ? 20 : 8),
        child: SizedBox(
          width: _isElevated ? 80 : 120,
          height: _isElevated ? 20 : 120,
          child: Icon(
            Icons.layers,
            color: Colors.white,
            size: _isElevated ? 60 : 40,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSwitcher() {
    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: _showWidget
            ? Container(
                key: ValueKey(1),
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.cyan,
                  shape: BoxShape.rectangle,
                ),
                child: const Icon(Icons.widgets, color: Colors.white, size: 50),
              )
            : Container(
                key: ValueKey(2),
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.lime,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.toggle_on,
                  color: Colors.white,
                  size: 50,
                ),
              ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(50),
        ),
        child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: _iconController,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }

  Widget _buildAnimatedTheme() {
    return AnimatedTheme(
      duration: const Duration(milliseconds: 800),
      data: _isDarkTheme
          ? ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
            )
          : ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
            ),
      child: Builder(
        builder: (context) => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(
            children: [
              Icon(
                Icons.palette,
                color: Theme.of(context).iconTheme.color,
                size: 40,
              ),
              const SizedBox(height: 8),
              Text(
                'Theme Animation',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSize() {
    return Center(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        child: Container(
          width: _isLargeSize ? 200 : 100,
          height: _isLargeSize ? 200 : 100,
          decoration: BoxDecoration(
            color: Colors.brown,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.aspect_ratio,
            color: Colors.white,
            size: _isLargeSize ? 80 : 40,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedModalBarrierButton() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Tap "Toggle Animation" to show/hide modal barrier',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildAnimatedModalBarrier() {
    return AnimatedModalBarrier(
      color: ColorTween(begin: Colors.transparent, end: Colors.black54).animate(
        AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        )..forward(),
      ),
      dismissible: true,
      onDismiss: () => setState(() => _showBarrier = false),
    );
  }

  Widget _buildExplicitAnimations() {
    return Column(
      children: [
        // ColorTween Demo
        AnimatedBuilder(
          animation: _colorTween,
          builder: (context, child) {
            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _colorTween.value,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.palette, color: Colors.white, size: 40),
            );
          },
        ),
        const SizedBox(height: 20),
        // CurvedAnimation Demo
        AnimatedBuilder(
          animation: _curvedAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: 0.5 + (_curvedAnimation.value * 0.5),
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.rectangle,
                ),
                child: const Icon(
                  Icons.auto_graph,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        // Interval Demo
        AnimatedBuilder(
          animation: _intervalAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _intervalAnimation.value,
              child: Container(
                width: 120,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(Icons.timer, color: Colors.white, size: 30),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAnimatedBuilder() {
    return AnimatedBuilder(
      animation: _explicitController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _explicitController.value * 2 * 3.14159,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple,
                  Colors.pink.withOpacity(_explicitController.value),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.refresh, color: Colors.white, size: 40),
          ),
        );
      },
    );
  }

  Widget _buildAllTransitions() {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          // First row of transitions
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'FadeTransition',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.visibility,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'SlideTransition',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.rectangle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'ScaleTransition',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.zoom_in,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Second row of transitions
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'RotationTransition',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: RotationTransition(
                          turns: _rotationAnimation,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.rectangle,
                            ),
                            child: const Icon(
                              Icons.rotate_right,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'SizeTransition',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: SizeTransition(
                          sizeFactor: _sizeAnimation,
                          child: Container(
                            width: 60,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Colors.purple,
                            ),
                            child: const Icon(
                              Icons.height,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'AlignTransition',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: AlignTransition(
                            alignment: _alignAnimation,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.teal,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Third row of transitions
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'PositionedTransition',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Stack(
                            children: [
                              PositionedTransition(
                                rect: _positionedAnimation,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Colors.cyan,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'DecoratedBoxTransition',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: DecoratedBoxTransition(
                          decoration: _decorationAnimation,
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'DefaultTextStyleTransition',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: DefaultTextStyleTransition(
                          style: _textStyleAnimation,
                          child: const Text('Text!'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Physics Animation Methods
  Widget _buildSpringAnimation() {
    return AnimatedBuilder(
      animation: _springAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_springAnimation.value * 200, 0),
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.spa, color: Colors.white, size: 40),
          ),
        );
      },
    );
  }

  Widget _buildFrictionAnimation() {
    return AnimatedBuilder(
      animation: _frictionAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_frictionAnimation.value * 200, 0),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.flash_on, color: Colors.white, size: 40),
          ),
        );
      },
    );
  }

  Widget _buildGravityAnimation() {
    return AnimatedBuilder(
      animation: _gravityAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _gravityAnimation.value * 150),
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sports_basketball,
              color: Colors.white,
              size: 40,
            ),
          ),
        );
      },
    );
  }

  void _runSpringSimulation() {
    final simulation = SpringSimulation(
      const SpringDescription(mass: 1, stiffness: 100, damping: 10),
      0,
      1,
      0,
    );
    _physicsController.animateWith(simulation);
  }

  void _runFrictionSimulation() {
    _physicsController.fling(velocity: 2.0);
  }

  void _runGravitySimulation() {
    final simulation = GravitySimulation(
      9.8, // acceleration
      0, // starting position
      1, // ending position
      0, // starting velocity
    );
    _physicsController.animateWith(simulation);
  }

  // Staggered Animation Methods
  Widget _buildStaggeredAnimations() {
    return Column(
      children: [
        // Sequential circles
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStaggeredCircle(_staggered1, Colors.red, Icons.looks_one),
            _buildStaggeredCircle(_staggered2, Colors.green, Icons.looks_two),
            _buildStaggeredCircle(_staggered3, Colors.blue, Icons.looks_3),
          ],
        ),
        const SizedBox(height: 20),
        // TweenSequence color animation
        AnimatedBuilder(
          animation: _sequenceColor,
          builder: (context, child) {
            return Container(
              width: 150,
              height: 60,
              decoration: BoxDecoration(
                color: _sequenceColor.value,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.gradient, color: Colors.white, size: 30),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStaggeredCircle(
    Animation<double> animation,
    Color color,
    IconData icon,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
          ),
        );
      },
    );
  }

  // Special Animation Methods
  Widget _buildHeroDemo() {
    return Center(
      child: Hero(
        tag: 'hero-demo',
        child: Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.purple,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.star, color: Colors.white, size: 50),
        ),
      ),
    );
  }

  Widget _buildAnimatedList() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _addListItem,
                  child: const Text('Add'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _removeListItem,
                  child: const Text('Remove'),
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _listItems.length,
              itemBuilder: (context, index, animation) {
                return _buildListItem(_listItems[index], animation);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(int item, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween(begin: const Offset(1, 0), end: Offset.zero),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.primaries[item % Colors.primaries.length],
            child: Text('$item'),
          ),
          title: Text('Item $item'),
          trailing: Icon(Icons.drag_handle),
        ),
      ),
    );
  }

  Widget _buildReorderableList() {
    final items = ['Square', 'Circle', 'Triangle', 'Diamond', 'Star'];
    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ReorderableListView.builder(
        itemCount: items.length,
        onReorder: (oldIndex, newIndex) {
          // Handle reordering logic here
        },
        itemBuilder: (context, index) {
          return Card(
            key: ValueKey(items[index]),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: _getShapeIcon(index),
              title: Text(items[index]),
              trailing: const Icon(Icons.drag_handle),
            ),
          );
        },
      ),
    );
  }

  Widget _getShapeIcon(int index) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];
    final icons = [
      Icons.crop_square,
      Icons.circle,
      Icons.change_history,
      Icons.diamond,
      Icons.star,
    ];

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: colors[index], shape: BoxShape.circle),
      child: Icon(icons[index], color: Colors.white, size: 20),
    );
  }

  void _addListItem() {
    final index = _listItems.length;
    _listItems.insert(index, _nextItem);
    _listKey.currentState?.insertItem(index);
    _nextItem++;
  }

  void _removeListItem() {
    if (_listItems.isNotEmpty) {
      final index = _listItems.length - 1;
      final item = _listItems.removeAt(index);
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => _buildListItem(item, animation),
      );
    }
  }

  void _navigateToHeroPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const HeroDetailPage()));
  }
}
