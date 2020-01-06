
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// TitleScene Layer
@interface TitleScene : CCLayer
{
	float						timeLapsed;
}

// returns a Scene that contains the title scene as the only child
+(id) scene;

-(void) setupMenu;
-(void) loadSounds;

@end
