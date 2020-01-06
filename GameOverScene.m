

// Import the interfaces
#import "GameOverScene.h"
#import "SimpleAudioEngine.h"
#import "TitleScene.h"

// HelloWorld implementation
@implementation GameOverScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOverScene *layer = [GameOverScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		//setup the menu
        [self loadSounds];
		[self setupMenu];
	}
	return self;
}

-(void)setupMenu {

	// ask director the the window size
	CGSize size = [[CCDirector sharedDirector] winSize];
	
	//Creates the Title screen menu sprites
    
    CCSprite *title = [CCSprite spriteWithFile:@"gameover.png"];
	
    id fadeIntoView = [CCFadeIn actionWithDuration:0.6];
    id moveIntoView = [CCMoveTo actionWithDuration:1.0 position:ccp(320,480-128)];
    
    [title runAction:fadeIntoView];
    [title runAction:moveIntoView];

	//attach the menu and title sprite to the layer
    [self addChild:title];
	//position the title
	[title setPosition:ccp(size.width/2,-120)];
	

	timeLapsed = 0;
	[self schedule:@selector(GameOverScreenLoop:) interval:0.2];
	
}


- (void) backToTitle{
    
	[[SimpleAudioEngine sharedEngine] playEffect:@"explode.wav"];
	/*
     Do a save data check here
     Continue to the pregame screen if the player chooses start
     fresh. Otherwise load the most recent level the user is on
     */

    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInB
                                               transitionWithDuration:1
                                               scene:[TitleScene scene]]];

	
}


- (void) GameOverScreenLoop:(ccTime)dt {
	
	timeLapsed += dt;
	
    if (timeLapsed >= 5.5) {
        [self backToTitle];
        timeLapsed = -1000;
    }
	
}

-(void)loadSounds {
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"start.wav"];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
