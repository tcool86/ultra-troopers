

// Import the interfaces
#import "LevelClearScene.h"
#import "SimpleAudioEngine.h"
#import "MainGame.h"
#import "TitleScene.h"

// HelloWorld implementation
@implementation LevelClearScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelClearScene *layer = [LevelClearScene node];
	
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
    
    CCSprite *title = [CCSprite spriteWithFile:@"level_cleared.png"];
	
    id fadeIntoView = [CCFadeIn actionWithDuration:0.6];
    id moveIntoView = [CCMoveTo actionWithDuration:1.0 position:ccp(320,480-128)];
    
	//Animate the title
	id zoomIn = [CCScaleTo actionWithDuration:.3 scale:1.5];
	id zoomOut = [CCScaleTo actionWithDuration:.5 scale:1];
	id zoomSeq = [CCSequence actions:zoomIn,zoomOut,nil];
	
	[title runAction:zoomSeq];
    [title runAction:fadeIntoView];
    [title runAction:moveIntoView];

	//attach the menu and title sprite to the layer
    [self addChild:title];
	//position the title
	[title setPosition:ccp(size.width/2,-120)];
	

	timeLapsed = 0;
	[self schedule:@selector(clearScreenLoop:) interval:0.2];
	
}


- (void) nextLevel{
    
	[[SimpleAudioEngine sharedEngine] playEffect:@"start.wav"];
	/*
     Do a save data check here
     Continue to the pregame screen if the player chooses start
     fresh. Otherwise load the most recent level the user is on
     */
	if ([[GameGlobal sharedGlobals] nextLevel]) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT
                                               transitionWithDuration:1
                                               scene:[MainGame scene]]];
    }else{
        //Game is won!
        CCSprite *congrats = [CCSprite spriteWithFile:@"congratulations.png"];
        [congrats setPosition:ccp(320,280)];
        [self addChild:congrats];
        
        CCSprite *youwin = [CCSprite spriteWithFile:@"win.png"];
        [youwin setPosition:ccp(320,180)];
        [self addChild:youwin];
        [[SimpleAudioEngine sharedEngine] playEffect:@"beacon.wav"];
        
    }
	
}


- (void) clearScreenLoop:(ccTime)dt {
	
	timeLapsed += dt;
	
    if (timeLapsed >= 4.5) {
        [self nextLevel];
        timeLapsed = -1000;
    }
    if(timeLapsed == -995){
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT
                                                   transitionWithDuration:1
                                                   scene:[TitleScene scene]]];
    }
	
}

-(void)loadSounds {
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"start.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"beacon.wav"];
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
