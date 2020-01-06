//
//  Target.h
//  Ultra Troopers
//
//  Created by Timothy Cool on 7/19/11.
//  Copyright 2011 Electrobud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameGlobal.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "AStarNode.h"
#include "chipmunk/chipmunk.h"

@class HiveMind;
@interface Target : CCSprite {
    cpBody          *target_body;
    cpShape         *target_shape;
    
    NSMutableArray  *movements;
    bool            updateMovement;
    int             next_move;

    float           moveTicks;
    int             direction;
    
    //Animation
    int             current_animation;
    int             previous_animation;
    NSMutableArray  *animations;
    
    int             strength;
    int             speed;
    int             hitPoints;
    int             type;
    
    bool            hit;
    float           hitTicker;
    bool            dead;
    bool            attack_mode;
    
    int             memory[50];
    HiveMind        *mind;
    
    int             target_id;
}

@property(readwrite)int type;
@property(readwrite)int strength;
@property(readwrite)int target_id;
@property(readwrite)bool hit;
@property(readwrite)bool dead;
@property(readwrite)bool attack_mode;
@property(readwrite)int direction;
@property(readwrite)bool updateMovement;
@property(readwrite, assign)HiveMind *mind;
@property(readwrite, assign)NSMutableArray *movements;

-(id)initWithMovement:(NSMutableArray*)movements withBatchNode:(CCSpriteBatchNode*)batch asEnemy:(int)type;
-(void)setupAnimation:(int)starting_row;
-(void)addEnemyAnimation:(NSString *)name startColumn:(int)anim_col inRow:(int)anim_row withFrameCount:(int)number_of_frames;
-(void)addToSpace:(cpSpace*)_space;

//IN Game
-(void)gotHit;
-(void)updateTarget:(ccTime)dt;
@end
