JPVerticalSlideMenu
===================

Sliding Menu for iOS (Top and Bottom menus)

<img src="JPVerticalSlideMenu.gif" width=320>

With this library you can create 3 types of sliding menus: <br>
1. Slide menu with <b>top</b> menu only. <br>
2. Slide menu with <b>bottom</b> menu only. <br>
3. Slide menu with <b>both top and bottom</b> menus. <br>

## Usage
- Clone the repository:

```bash
$ git clone https://github.com/Juanpe/JPVerticalSlideMenu.git
```

- Drag the ```JPVerticalSlideVCProtocols.h```,```JPVerticalSlideViewController.h```,```JPVerticalSlideViewController.m``` files into your project.

## Customize

You can easily customize slide menu by overriding needed methods, such us: 
<pre>
- (CGFloat)topVCHeight;
- (CGFloat)bottomVCHeight;
- (CGFloat) panGestureWorkingAreaPercent;
</pre>

You can open or close top or bottom menus programmatically:
<pre>
- (void) openTopVC;
- (void) openTopVCAnimated:(BOOL)animated;
- (void) openBottomVC;
- (void) openBottomVCAnimated:(BOOL)animated;

- (void) closeTopVC;
- (void) closeTopVCAnimated:(BOOL)animated;
- (void) closeBottomVC;
- (void) closeBottomVCAnimated:(BOOL)animated;
</pre>

<br>
If you want to get menu's open/close callbacks, you must implement protocol named ```JPVerticalSlideVCDelegate```.
<pre>
@optional
- (void) topVCWillOpen;
- (void) topVCDidOpen;
- (void) bottomVCWillOpen;
- (void) bottomVCDidOpen;

- (void) topVCWillClose;
- (void) topVCDidClose;
- (void) bottomVCWillClose;
- (void) bottomVCDidClose;
</pre>

