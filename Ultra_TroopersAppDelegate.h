#import "cocos2d.h"

@class CCSprite;

//CLASS INTERFACE
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
@interface AppController : NSObject <UIApplicationDelegate>
{
	UIWindow *window;
}
@end

#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
@interface Ultra_TroopersAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window_;
	MacGLView *glView_;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet MacGLView *glView;

@end
#endif // Mac
