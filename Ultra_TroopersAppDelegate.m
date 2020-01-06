//
// Actions Demo
// a cocos2d example
// http://www.cocos2d-iphone.org
//

// local import
#import "cocos2d.h"
#import "Ultra_TroopersAppDelegate.h"
#import "TitleScene.h"

// CLASS IMPLEMENTATIONS

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

#pragma mark AppController - iOS

@implementation AppController

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// CC_DIRECTOR_INIT()
	//
	// 1. Initializes an EAGLView with 0-bit depth format, and RGB565 render buffer
	// 2. EAGLView multiple touches: disabled
	// 3. creates a UIWindow, and assign it to the "window" var (it must already be declared)
	// 4. Parents EAGLView to the newly created window
	// 5. Creates Display Link Director
	// 5a. If it fails, it will use an NSTimer director
	// 6. It will try to run at 60 FPS
	// 7. Display FPS: NO
	// 8. Device orientation: Portrait
	// 9. Connects the director to the EAGLView
	//
	CC_DIRECTOR_INIT();
	
	// Obtain the shared director in order to...
	CCDirector *director = [CCDirector sharedDirector];
	
	// Sets landscape mode
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
	
	// Turn on display FPS
	[director setDisplayFPS:YES];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if ([UIScreen instancesRespondToSelector:@selector(scale)])
		[director setContentScaleFactor:[[UIScreen mainScreen] scale]];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
    EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
                                   pixelFormat:kEAGLColorFormatRGBA8888	// kEAGLColorFormatRGBA8
								   depthFormat:GL_DEPTH_COMPONENT16_OES];						// GL_DEPTH_COMPONENT16_OES
	[CCTexture2D setDefaultAlphaPixelFormat:kEAGLColorFormatRGBA8888];
	
	CCScene *scene = [CCScene node];
	[scene addChild: [nextAction() node]];
	
	[director runWithScene: scene];
	
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] resume];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{	
	CC_DIRECTOR_END();
}

// sent to background
-(void) applicationDidEnterBackground:(UIApplication*)application
{
	[[CCDirector sharedDirector] stopAnimation];
}

// sent to foreground
-(void) applicationWillEnterForeground:(UIApplication*)application
{
	[[CCDirector sharedDirector] startAnimation];
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

- (void) dealloc
{
	[window release];
	[super dealloc];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

@end

#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

#pragma mark AppController - Mac
@implementation Ultra_TroopersAppDelegate

@synthesize window=window_, glView=glView_;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
	CCDirector *director = [CCDirector sharedDirector];
	
	[director setDisplayFPS:NO];
	
	[director setOpenGLView:glView_];
	
	// Enable "moving" mouse event. Default no.
	[window_ setAcceptsMouseMovedEvents:NO];
	
	[[CCDirector sharedDirector] runWithScene: [TitleScene scene]];	
}

@end
#endif
