//
//  Player.h
//  Demo Mac Port
//
//  Created by Timothy Cool on 7/1/11.
//  Copyright 2011 Electrobud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameGlobal.h"
#import "PlayerController.h"
#include "chipmunk/chipmunk.h"
#import "Weapon.h"

@class Weapon;
@interface Player : CCSprite {
    NSMutableArray       *animations;
    int                  player_number;
    //Player Attributes
    float                speed;
    Weapon               *primary;
    int                  direction;
    
    //Animation
    int                 current_animation;
    int                 previous_animation;
    
    //Movement flags
    PlayerController    *controller;
    
    //Collision
    cpBody              *playerBody;
    cpShape             *playerShape;
    bool                gotHit;
    bool                dead;
    
}

@property(readwrite, retain)NSMutableArray      *animations;
@property(readwrite, assign)PlayerController    *controller;
@property(readwrite, assign)cpBody              *playerBody;
@property(readwrite, assign)cpShape             *playerShape;
@property(readwrite, assign)bool                gotHit;
@property(readwrite, assign)bool                dead;
@property(readwrite, assign)int                 player_number;

//Game Setup Methods
-(void)setupPlayer:(NSString*)characterChosen:(int)playerSlot;
-(void)loadAnimation;
-(void)setupAnimationSet:(int)starting_row;
-(void)addPlayerAnimation:(NSString *)name startColumn:(int)anim_col inRow:(int)anim_row withFrameCount:(int)number_of_frames;
-(void)setupCollision;
-(void)addToSpace:(cpSpace*)_space;
-(void)setupWeapons:(CCSpriteBatchNode*)weapons_sheet withSpace:(cpSpace*)_space;

//In Game
-(void)updatePlayer:(ccTime)dt;
-(void)move;
-(void)controllerKey:(int)key pressed:(bool)_pressed;
-(void)getHit:(int)damage;
-(void)die;
@end
