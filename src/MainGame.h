//
//  MainGame.h
//  Ultra Troopers
//
//  Created by Timothy Cool on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "Target.h"
#import "GameGlobal.h"
#import "SimpleAudioEngine.h"
#include "chipmunk/chipmunk.h"
#include "drawSpace.h"
#include "GameHUD.h"
#include "LevelClearScene.h"
#include "GameOverScene.h"

@interface MainGameLayer : CCLayer {

	CCDirector      *director;

    NSMutableArray  *players;
    NSMutableArray  *weapons;
    NSMutableArray  *enemies;
    cpSpace         *gameSpace;
    
    CCTMXTiledMap   *level_map;
    cpBody          *background_collision;
    
    bool            bgm_start;
    float           bgm_timer;
}
@property (readwrite, assign) NSMutableArray    *players;
@property(nonatomic, retain)CCTMXTiledMap       *level_map;

-(void)setupPhysics;
-(void)setupPlayers;
-(void)setupWeapons;
-(void)setupEnemies;
-(bool)multiplayerCheck;
-(void)updateHUDs;

-(void)loadSounds;
-(void)loadLevel:(NSString*)levelName;
-(void)detectControllers;

-(void)ccKeyDown:(NSEvent*)keyDownEvent;
-(void)ccKeyUp:(NSEvent*)keyUpEvent;

-(void)playSound:(NSString*)sound;

//Collision Functions
-(void)bulletCollisionWall;
-(void)bulletCollisionPlayer;
@end


@interface MainGame : CCScene {
	
	MainGameLayer  *_layer;
    GameHUD        *p1_HUD;
    GameHUD        *p2_HUD;
}

@property (nonatomic, retain) MainGameLayer *layer;
@property (nonatomic, retain)GameHUD *p1_HUD;
@property (nonatomic, retain)GameHUD *p2_HUD;

-(void)setupHUD;

+(id)scene;



@end
