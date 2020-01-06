
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// LevelClearScene Layer
@interface GameOverScene : CCLayer
{
	float						timeLapsed;
}

// returns a Scene that contains the title scene as the only child
+(id) scene;

-(void) setupMenu;
-(void) loadSounds;

@end
