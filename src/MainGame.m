//
//  MainGame.m
//  Ultra Troopers
//
//  Created by Timothy Cool on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainGame.h"


@implementation MainGame
@synthesize layer = _layer;
@synthesize p1_HUD,p2_HUD;

+ (id)scene {
	
	MainGame *scene = [MainGame node];
	MainGameLayer *layer = [MainGameLayer node];
	[scene addChild:layer];
    [scene setupHUD];
	return scene;

}

-(void)setupHUD {
    int game = [[GameGlobal sharedGlobals] gameType];
    p1_HUD = [[GameHUD alloc] initWithPlayer:1];
    [self addChild:p1_HUD];
    [self reorderChild:p1_HUD z:1000];
    [p1_HUD updateHUD];
    if (game == COOP) {
        p2_HUD = [[GameHUD alloc] initWithPlayer:2];  
        [self addChild:p2_HUD];
        [self reorderChild:p2_HUD z:1000];
        [p2_HUD updateHUD];
    }
}

- (id) init {
	if ((self = [super init])) {
       
	}
	return self;
}

@end


static void
eachShape(cpShape *ptr, void* unused){
	cpShape *shape = ptr;
	CCSprite *sprite = shape->data;
	if( sprite ) {
		cpBody *body = shape->body;
		[sprite setPosition: body->p];
		[sprite setRotation: (float) CC_RADIANS_TO_DEGREES( -body->a )];
        
	}
}

@implementation MainGameLayer

@synthesize players;
@synthesize level_map;

- (id)init {
	
	if ((self = [super init])) {
		
        self.isKeyboardEnabled = YES;

        [[CCDirector sharedDirector] setProjection:CCDirectorProjection2D];
        [self setupPlayers];
        [[players objectAtIndex:0] setPosition:ccp(-1000,-1000)];
        if ([self multiplayerCheck]){ [[players objectAtIndex:1] setPosition:ccp(-1100,-1000)];}
        [self setupPhysics];
        [self setupWeapons];
        [self setupEnemies];
        [self schedule:@selector(mainLoop:) interval:0.002];
        [self detectControllers];
        [self loadSounds];
        [self loadLevel:[NSString stringWithFormat:@"level%i.tmx",[[GameGlobal sharedGlobals] current_level]]];
		
	}
	return self;
}

-(void)detectControllers {
    for (Player *p in players) {
        
    }
    
}

-(void)bulletCollisionWall {
    //NSLog(@"Bullet Hit The Wall!");
    [self playSound:@"hit_wall.wav"];
}

cpBool bulletCollisionWall(cpArbiter *arb, struct cpSpace *space, void *data) {
    MainGameLayer *layer = (MainGameLayer *)data;
    cpShape *bullet, *wall; 
    cpArbiterGetShapes(arb, &bullet, &wall);
    
    Bullet *b = (Bullet*)bullet->data;
    [b contactWithObject];
    
    [layer bulletCollisionWall];
    return cpTrue;
}

cpBool enemyCollisionWall(cpArbiter *arb, struct cpSpace *space, void *data) {
    //MainGameLayer *layer = (MainGameLayer *)data;
    cpShape *enemy, *wall; 
    cpArbiterGetShapes(arb, &enemy, &wall);
    
    Target *t = (Target*)enemy->data;
    [t setAttack_mode:NO];
    
    return cpTrue;
}

-(void)bulletCollisionPlayer {
    //NSLog(@"Bullet Hit The Player!");
}

cpBool bulletCollisionPlayer(cpArbiter *arb, struct cpSpace *space, void *data) {
    MainGameLayer *layer = (MainGameLayer *)data;
    [layer bulletCollisionPlayer];
    return cpFalse;
}

-(void)createPointSpriteAt:(CGPoint)pos forPlayer:(int)player_num withValue:(int)value {
    CCLabelBMFont *points = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i",value]
                                                   fntFile:@"ultra_troper_score.fnt"];
    [self.parent addChild:points z:kPOINTS_SPRITE];
    [points setScale:0.75];
    
    [points setPosition:pos];
    CGPoint point_dist = ccp(0,0);
    if (player_num == 1) {
        //hit by player 1
        point_dist = ccp(74,456);
        [points setAnchorPoint:ccp(1,0.5)];
        [GameGlobal sharedGlobals].p1_score+=value;            
    }else if (player_num == 2){
        //hit by player 2
        point_dist = ccp(640-74,456);
        [points setAnchorPoint:ccp(0,0.5)];
        [GameGlobal sharedGlobals].p2_score+=value;
    }
    id  move_points = [CCMoveTo actionWithDuration:1.2 position:point_dist];
    id  fade_out    = [CCFadeOut actionWithDuration:0.3];
    id  sequence    = [CCSequence actions:move_points,fade_out, nil];
    id  flash_r     = [CCTintTo actionWithDuration:0.3 red:255 green:0 blue:0];
    id  flash_g     = [CCTintTo actionWithDuration:0.3 red:0 green:255 blue:0];
    id  flash_b     = [CCTintTo actionWithDuration:0.3 red:0 green:0 blue:255];
    id  flash_o     = [CCTintTo actionWithDuration:0.3 red:255 green:255 blue:0];
    id  flash_y     = [CCTintTo actionWithDuration:0.3 red:0 green:255 blue:255];
    id  flash_seq   = [CCSequence actions:flash_r,flash_g,flash_b,flash_o,flash_y,nil];
    [sequence setTag:kPOINTS_SPRITE];
    [points runAction:sequence];
    [points runAction:flash_seq];
    [points setTag:kPOINTS_SPRITE];
}

-(void)updateHUDs {
    GameHUD *hud1 = [(MainGame*)self.parent p1_HUD];
    GameHUD *hud2 = [(MainGame*)self.parent p2_HUD];
    [hud1 updateHUD];
    [hud2 updateHUD];
}

-(void)bulletCollisionTarget:(int)bulletType:(CGPoint)enemyPos:(bool)enemydead:(int)value {
    if (enemydead == YES) {
        [self createPointSpriteAt:enemyPos forPlayer:bulletType withValue:value];
    }
}

cpBool bulletCollisionTarget(cpArbiter *arb, struct cpSpace *space, void *data) {
    MainGameLayer *layer = (MainGameLayer *)data;
    cpShape *bullet, *target; 
    cpArbiterGetShapes(arb, &bullet, &target);
    
    Bullet *b = (Bullet*)bullet->data;
    [b contactWithObject];
    
    Target *t = (Target*)target->data;
    [t gotHit];
    
    CGPoint relativeToScreen = [layer convertToWorldSpace:t.position];
    
    [layer playSound:@"hit.wav"];
    [layer bulletCollisionTarget:b.type :relativeToScreen :t.dead :(t.strength * 10)];
    return cpTrue;
}

-(void)enemyCollisionPlayer:(int)player_num{
    //NSLog(@"Enemy Hit Player!"); 
    GameHUD *hud;
    if (player_num == 1) {
        hud = [(MainGame*)self.parent p1_HUD];
    }else{
        hud = [(MainGame*)self.parent p2_HUD];
    }
    [hud updateHUD];
}

cpBool enemyCollisionPlayer(cpArbiter *arb, struct cpSpace *space, void *data) {
    MainGameLayer *layer = (MainGameLayer*)data;
    cpShape *player, *enemy;
    cpArbiterGetShapes(arb, &player, &enemy);
    Target *e = (Target*)enemy->data;
    
    Player *p = (Player*)player->data;
    
    if(p.dead) {
        return cpFalse;
    }
    
    [p getHit:[e strength]];
    
    cpVect force = cpv(0,0);
    if(e.direction == kUP) {
        force = cpvadd(force,cpv(0,200));
    }else if(e.direction == kDOWN) {
        force = cpvadd(force,cpv(0,-200));
    }
    if(e.direction == kRIGHT) {
        force = cpvadd(force,cpv(200,0));
    }else if(e.direction == kLEFT) {
        force = cpvadd(force,cpv(-200,0));
    }
    p.playerBody->v = force;
    
    [layer enemyCollisionPlayer:p.player_number];
    [layer playSound:@"hit.wav"];
    return cpTrue;
}

-(void)playSound:(NSString *)sound{
    [[SimpleAudioEngine sharedEngine] playEffect:sound];
}


-(void)setupPhysics {
    cpInitChipmunk();
    gameSpace = cpSpaceNew();
    gameSpace->gravity = cpv(0,0);
    for (Player *p in players) {
        [p addToSpace:gameSpace];
    }

    //Collision Handler (Bullet to Wall)
    cpSpaceAddCollisionHandler(gameSpace, kBULLET_COLL, kWALL_COLL, bulletCollisionWall, NULL, NULL, NULL, self);
    cpSpaceAddCollisionHandler(gameSpace, kBULLET_COLL, kPLAYER1_COLL, bulletCollisionPlayer, NULL, NULL, NULL, self);
    cpSpaceAddCollisionHandler(gameSpace, kBULLET_COLL, kPLAYER2_COLL, bulletCollisionPlayer, NULL, NULL, NULL, self);
    cpSpaceAddCollisionHandler(gameSpace, kBULLET_COLL, kTARGET_COLL, bulletCollisionTarget, NULL, NULL, NULL, self);
    cpSpaceAddCollisionHandler(gameSpace, kPLAYER1_COLL, kTARGET_COLL, enemyCollisionPlayer, NULL, NULL, NULL, self);
    cpSpaceAddCollisionHandler(gameSpace, kPLAYER2_COLL, kTARGET_COLL, enemyCollisionPlayer, NULL, NULL, NULL, self);
    cpSpaceAddCollisionHandler(gameSpace, kTARGET_COLL, kWALL_COLL, enemyCollisionWall, NULL, NULL, NULL, self);
}

-(void)setupPlayers {
    //Thinking ahead...
    //Number of players?
    players = [[NSMutableArray alloc] init];
    NSArray *playerNames;
    if ([[GameGlobal sharedGlobals] gameType] == SINGLE_PLAYER) {
        playerNames =   [NSArray arrayWithObjects:   [NSString stringWithString:@"trooperSpriteSheet"],nil];        
    }else if([[GameGlobal sharedGlobals] gameType] == COOP ){
        playerNames =   [NSArray arrayWithObjects:   
                        [NSString stringWithString:@"trooperSpriteSheet"],
                        [NSString stringWithString:@"trooperSpriteSheet"],nil];
    }
    
    int player_counter=1; //Start off with the first player
    for (NSString *name in playerNames) {
        NSString *path = [NSString stringWithFormat:@"%@.png",name];
        CCSpriteBatchNode *sheet = [CCSpriteBatchNode batchNodeWithFile:path];
        //will only apply to one and two
        int sheet_loc_y = (player_counter == 1) ? 0: 64; 
        
        //Consider making player height/width a global macro
        Player *p = [Player spriteWithBatchNode:sheet rect:CGRectMake(0, sheet_loc_y, 32, 32)];
        [p setupPlayer:name :player_counter];
        [players addObject:p];
        [self addChild:sheet];
        [sheet addChild:p];
        
        player_counter++;
    }

}

-(bool)multiplayerCheck {
    int game = [[GameGlobal sharedGlobals] gameType];
    if (game == COOP || game == MULTI) {
        return YES;
    }
    return NO;
}

-(void)setupWeapons {
    //For player Weapons
    CCSpriteBatchNode *weaponSheet = [CCSpriteBatchNode batchNodeWithFile:@"bulletsSheet.png"];
    [self addChild:weaponSheet];
    for (Player *p in players) {
        [p setupWeapons:weaponSheet withSpace:gameSpace];        
    }
}

//#define enemy_tag 999
-(void)setupEnemies {
    enemies = [[NSMutableArray alloc] init];
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    int x = position.x / level_map.tileSize.width;
    int y = ((level_map.mapSize.height * level_map.tileSize.height) - position.y) / level_map.tileSize.height;
    return ccp(x, y);
}

#define ground      1
#define wall_bottom 67
#define wall_full   66
#define wall_top    1
#define enemy       4
#define enemy2      13
#define enemy3      14
#define p1_start    5
#define p2_start    6

-(void)createWall:(int)wall_type atPoint:(CGPoint)origin {
    int coll_width  = 0;
    int coll_height = 0;
    int y_offset    = 0;
    int x_offset    = -64;
    
    switch (wall_type) {
        case wall_top:
            coll_width  = 64;
            coll_height = 32;
            break;
        case wall_bottom:
            coll_width  = 64;
            coll_height = 48;
            y_offset    = 16;
            break;
        case wall_full:
            coll_width  = 64;
            coll_height = 64;            
            break;
        default:
            break;
    }
    cpShape *shape;
    
    //define retangular box shape
    cpVect verts[] = {
		cpv(0,0),
		cpv(0, coll_height),
		cpv( coll_width, coll_height),
		cpv( coll_width,0),
	};
    
    //create shape
    shape = cpPolyShapeNew(background_collision, 4, verts, ccp(origin.x-(coll_width + x_offset),origin.y-(coll_height + y_offset)));
    shape->e = 0.0f;
    shape->collision_type = kWALL_COLL;
    cpSpaceAddStaticShape(gameSpace, shape);
    cpShapeSetGroup(shape, kNEUTRAL);
    
}

-(void)loadSounds {
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"beacon.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"player_death.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"start.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"shoot.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"shoot2.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"enemy_death.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"healthpickup.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"hit_wall.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"hit.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"explode.wav"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"ut_start.wav"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"loop.wav"];
//    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"ut_loop.wav"];
}

-(void)loadLevel:(NSString*)levelName {
    //loads a map from a file that was created by a nice map making program called "Tiled"
	level_map = [CCTMXTiledMap tiledMapWithTMXFile:levelName];
	[level_map setAnchorPoint:ccp(0,0)];
    [self addChild:level_map z:-1];
    [self reorderChild:[level_map layerNamed:@"top_layer"] z:100];
	
    //for immovable background tiles
    background_collision = cpBodyNew(INFINITY, INFINITY);
    background_collision->p = cpvzero;
    
    //setup enemies
    CCSpriteBatchNode *enemySheet = [CCSpriteBatchNode batchNodeWithFile:@"baddieSheet.png"];
    [self addChild:enemySheet];
    
    //create HiveMind (for enemy AI)
    [GameGlobal sharedGlobals].hive = [[HiveMind alloc] init];
    [[[GameGlobal sharedGlobals] hive] setup:level_map.mapSize.width :level_map.mapSize.height :64];
    HiveMind *_hive = [[GameGlobal sharedGlobals] hive];
    
    //Loop through all the tiles in background
    //find ones that have collidable property
    [[level_map layerNamed:@"dynamic"] setVisible:NO];
    
    int i,j;
    for(i=0; i<level_map.mapSize.width; i++) {
        for(j=0; j<level_map.mapSize.height; j++) {
            //meta tile data
            int tile = [[level_map layerNamed:@"meta"] tileGIDAt:ccp(i,j)];
            if (tile != 0) {
//                NSLog(@"\nTile (%i,%i) id: %i",i,j,tile); 
                [self createWall:tile atPoint:ccp(i*64,(level_map.mapSize.height*64) - j*64)];
                [_hive setMapObject:kMAP_WALL :ccp(i*64,j*64)];
            }
            
            //dynamic tile data
            int dynamic = [[level_map layerNamed:@"dynamic"] tileGIDAt:ccp(i,j)];
            
            if (dynamic == p1_start) {
                [[GameGlobal sharedGlobals] setP1Start:ccp((i*64) + 32,((level_map.mapSize.height*64) - j*64) - 32)];
                [[players objectAtIndex:0] playerBody]->p = [[GameGlobal sharedGlobals] p1Start]; 
            }
            if ([self multiplayerCheck]) {
                if (dynamic == p2_start) {
                    [[GameGlobal sharedGlobals] setP2Start:ccp((i*64) + 32,((level_map.mapSize.height*64) - j*64) - 32)];
                    [[players objectAtIndex:1] playerBody]->p = [[GameGlobal sharedGlobals] p2Start];
                }
            }
            if (dynamic == enemy || dynamic == enemy2 || dynamic == enemy3) {
                int enemy_type;
                switch (dynamic) {
                    case enemy:
                        enemy_type = kGREEN;
                        break;
                    case enemy2:
                        enemy_type = kRED;
                        break;
                    case enemy3:
                        enemy_type = kPURP;
                        break;
                    default:
                        break;
                }
                
                Target *t = [[Target alloc] initWithMovement:nil withBatchNode:enemySheet asEnemy:enemy_type];
                [t setPosition:ccp((i*64) + 32,((level_map.mapSize.height*64) - j*64) - 32)];
                [t setTarget_id:[enemies count]];
                [t addToSpace:gameSpace];
                [enemySheet addChild:t];
                //Add reference to enemy array
                [enemies addObject:t];
                [t setMind:_hive];
                [_hive addEnemy];
                
            }
        }
    }
	[[level_map layerNamed:@"meta"] setVisible:NO];
//    [_hive debugMap];
    _hive.p1_ref = [players objectAtIndex:0];
    if ([self multiplayerCheck]) {
        _hive.p2_ref = [players objectAtIndex:1];
    }
    //Start playing music (out of place slightly???)       
   [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ut_start.wav" loop:NO];
//    bgm_start = NO;
    
}


-(void)setViewpointCenter:(CGPoint) position {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (level_map.mapSize.width * level_map.tileSize.width) - winSize.width / 2);
    y = MIN(y, (level_map.mapSize.height * level_map.tileSize.height) - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = ccp((int)viewPoint.x, (int)viewPoint.y);
}

-(void)updateCamera {
    //Player 1
	Player *p = [players objectAtIndex:0];
    Player *p2;
    if(p.dead == YES) {
        if ([self multiplayerCheck]) {
            p2 = [players objectAtIndex:1];
            [self setViewpointCenter:p2.position];
        }
    }else{
        [self setViewpointCenter:p.position];        
    }

}


-(void)updateControllerForPlayer:(Player*)player{
    
}

- (void)ccKeyDown:(NSEvent*)keyDownEvent {
	// Get pressed key (code)
	NSString * character = [keyDownEvent characters];
    unichar keyCode = [character characterAtIndex: 0];
    
    for (Player *p in players) {
        [p controllerKey:keyCode pressed:YES];
    }

}

- (void)ccKeyUp:(NSEvent*)keyUpEvent {
	// Get pressed key (code)
	NSString * character = [keyUpEvent characters];
    unichar keyCode = [character characterAtIndex: 0];
    
    for (Player *p in players) {
        [p controllerKey:keyCode pressed:NO];
    }
    
    //NSLog(@"key: %u", [character characterAtIndex: 0]);
}

//#define TOP_LEVEL 8
//-(int)screenTier:(CGPoint)pos {
//    CGPoint rel = [self convertToWorldSpace:pos];
//    float determinant = ceilf(rel.y/64);
//    int order = TOP_LEVEL - determinant;
//    NSLog(@"%i",order);
//    return order;
//}


-(void)mainLoop:(ccTime)dt {
    cpSpaceStep(gameSpace, dt);
    cpSpaceEachShape(gameSpace, &eachShape, nil);
    [self updateCamera];
    
    bool gameOver = NO;
    
    for (Player *p in players) {
        [p updatePlayer:dt];
    }
    
    //Consider Position Grid Priority (not sure actual name)
    Player *p1 = [players objectAtIndex:0];
    if ([self multiplayerCheck]) {
        Player *p2 = [players objectAtIndex:1];
        
        if(p1.position.y > p2.position.y){
            [self reorderChild:p1.parent z:0];
            [self reorderChild:p2.parent z:1];
        }else{
            [self reorderChild:p2.parent z:0];
            [self reorderChild:p1.parent z:1];
        }
        if (p1.dead == YES && p2.dead == YES) {
            gameOver = YES;
        }
    }else{
        if (p1.dead == YES) {
            gameOver = YES;
        }
    }
    
    if (gameOver == YES) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                   transitionWithDuration:2
                                                   scene:[GameOverScene scene]]];
        
    }
    
    for(Target* t in enemies) {
        [t updateTarget:dt];
        //[self reorderChild:t z:[self screenTier:t.position]];
    }
    
    
    //Points
    CCNode *points = [self.parent getChildByTag:kPOINTS_SPRITE];
    if (points != nil) {
        CCAction *doneYet = [points getActionByTag:kPOINTS_SPRITE];
        if( doneYet == nil){
            [self.parent removeChild:points cleanup:YES];
            [self updateHUDs];
        }
    }
    
    if ([[GameGlobal sharedGlobals] hive].enemies_cleared == YES) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                   transitionWithDuration:2
                                                   scene:[LevelClearScene scene]]];
    }
    
    //BGM
    if(bgm_start == NO){
        bgm_timer += dt;
        if (bgm_timer > 12.7) {
            [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"loop.wav" loop:YES];
            bgm_start = YES;
        }
    }
}

-(void) dealloc {
    players = nil;
    weapons = nil;
    enemies = nil;
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
	[super dealloc];
	
}

@end

