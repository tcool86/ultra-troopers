

// Import the interfaces
#import "TitleScene.h"
#import "SimpleAudioEngine.h"
#import "MainGame.h"

// HelloWorld implementation
@implementation TitleScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TitleScene *layer = [TitleScene node];
	
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
    CCSprite *title_ultra = [CCSprite spriteWithFile:@"title_ultra.png"];
	[title_ultra setPosition:ccp(320,480+64)];
    [self addChild:title_ultra];
    
    CCSprite *title = [CCSprite spriteWithFile:@"title_troopers.png"];
	
    id moveIntoView = [CCMoveTo actionWithDuration:1.0 position:ccp(320,480-42)];
    [title_ultra runAction:moveIntoView];
    
	//Animate the title
	id zoomIn = [CCScaleTo actionWithDuration:.3 scale:1.5];
	id zoomOut = [CCScaleTo actionWithDuration:.5 scale:1];
	id zoomSeq = [CCSequence actions:zoomIn,zoomOut,nil];
	
	[title runAction:zoomSeq];
	
	//attaches them to menu item objects
	CCMenuItemImage *p1Game = [CCMenuItemImage itemFromNormalImage:@"single_player.png" selectedImage:@"single_player_selected.png" target:self selector:@selector(startGame:)];
	CCMenuItemImage *coop = [CCMenuItemImage itemFromNormalImage:@"coop_game.png" selectedImage:@"coop_game_selected.png" target:self selector:@selector(coopGame:)];
    CCMenuItemImage *multi = [CCMenuItemImage itemFromNormalImage:@"multiplayer.png" selectedImage:@"multiplayer_selected.png" target:self selector:@selector(multiplayerGame:)];
	
	p1Game.position = ccp(0, -20);
	coop.position = ccp(0, -60);
	multi.position = ccp(0, -100);
	
	//Create the menu
	CCMenu *titleMenu = [CCMenu menuWithItems:p1Game,coop,multi, nil];
	[titleMenu setOpacity:0];
	
	//fade menu in
	id fade_start = [CCFadeIn actionWithDuration:2.4];
	id fade_vs = [CCFadeIn actionWithDuration:2.8];
	id fade_setting = [CCFadeIn actionWithDuration:3.2];
	
	[p1Game runAction:fade_start];
	[coop runAction:fade_vs];
	[multi runAction:fade_setting];

	
	//attach the menu and title sprite to the layer
	[self addChild:title];
	[self addChild:titleMenu];
	
	//position the title
	[title setPosition:ccp(size.width/2,size.height - 120)];
	

	timeLapsed = 0;
	[self schedule:@selector(titleScreenLoop:) interval:0.2];
	
}

- (void) titleScreenLoop:(ccTime)dt {
	
	timeLapsed += dt;
	
	
}

- (void) startGame:(id)sender {

	NSLog(@"Clicked Start");
	[[SimpleAudioEngine sharedEngine] playEffect:@"start.wav"];
	/*
	Do a save data check here
	Continue to the pregame screen if the player chooses start
	fresh. Otherwise load the most recent level the user is on
	*/
	[[GameGlobal sharedGlobals] setGameType:SINGLE_PLAYER];
    [[GameGlobal sharedGlobals] setCurrent_level:1];
    [[GameGlobal sharedGlobals] setP1_score:0];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT
														transitionWithDuration:1
														scene:[MainGame scene]]];
	
}

- (void) coopGame:(id)sender {

	NSLog(@"Clicked Vs");
    [[SimpleAudioEngine sharedEngine] playEffect:@"start.wav"];
    [[GameGlobal sharedGlobals] setGameType:COOP];
    [[GameGlobal sharedGlobals] setCurrent_level:1];
    [[GameGlobal sharedGlobals] setP1_score:0];
    [[GameGlobal sharedGlobals] setP2_score:0];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT
                                               transitionWithDuration:1
                                               scene:[MainGame scene]]];
	
}


- (void) multiplayerGame:(id)sender {
	
	NSLog(@"Clicked Settings");
    [[SimpleAudioEngine sharedEngine] playEffect:@"start.wav"];
	
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
