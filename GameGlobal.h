//
//  GameGlobal.h
//  MaidenDays
//
//  Created by Timothy Cool on 6/5/11.
//  Copyright 2011 Electrobud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerController.h"
#import "HiveMind.h"

#define KEY_UP      119
#define KEY_DOWN    115
#define KEY_LEFT    97
#define KEY_RIGHT   100
#define KEY_SHOOT   102

#define KEY_UP_2      63232
#define KEY_DOWN_2    63233
#define KEY_LEFT_2    63234
#define KEY_RIGHT_2   63235
#define KEY_SHOOT_2   46

enum directions_move {
    kNONE,
    kDOWN,
    kUP,
    kLEFT,
    kRIGHT
};

enum enemy_types {
    kGREEN = 2,
    kRED  = 4,
    kPURP = 0
};

enum shape_types {
    kSQUARE,
    kCIRCLE
};
//enum directions_shoot {
//    kSHOOT_UP,
//    kSHOOT_UP_RIGHT,
//    kSHOOT_UP_LEFT,
//    kSHOOT_DOWN,
//    kSHOOT_DOWN_RIGHT,
//    kSHOOT_DOWN_LEFT,
//    kSHOOT_RIGHT,
//    kSHOOT_LEFT
//};
//enum screen_tiers {
//    kST_ZERO = 3,
//    kST_ONE = 5,
//    kST_TWO = 7,
//    kST_THREE = 9,
//    kST_FOUR = 11,
//    kST_FIVE = 13,
//    kST_SIX = 15,
//    kST_SEVEN = 17,
//    kST_SEVEN_FIVE = 19
//};
enum game_types {
    SINGLE_PLAYER,
    COOP,
    MULTI
};

enum collision_types {
    kWALL_COLL   = 0,
    kBULLET_COLL = 1,
    kTARGET_COLL = 2,
    kPLAYER1_COLL = 3,
    kPLAYER2_COLL = 4
};

enum action_refs {
    kHIT_TAG = 999,
    kDEATH_TAG = 998
};

enum sprite_references {
    kPOINTS_SPRITE = 1000
};

enum collision_groups {
    kFRIENDLY,
    kNEUTRAL,
    kENEMIES
};

enum weapon_types {
    kTEST_WEAPON
};

#define MOVE_TAG  100
#define ANIM_TAG  101
@class HiveMind;
@interface GameGlobal : NSObject {
    //Will be replaced by controller objects
    int     p1Keys[6];
    int     p2Keys[6];
    
    PlayerController    *p1Controller;
    PlayerController    *p2Controller;
    
    CGPoint p1Start;
    CGPoint p2Start;
    
    HiveMind    *hive;
    int         p1_health;
    int         p2_health;
    
    float       p1_reload;
    float       p2_reload;
    
    int         p1_score;
    int         p2_score;
    
    int         gameType;
    int         current_level;
}

@property(readwrite)CGPoint p1Start;
@property(readwrite)CGPoint p2Start;
@property(readwrite)int     p1_health;
@property(readwrite)int     p2_health;
@property(readwrite)int     p1_score;
@property(readwrite)int     p2_score;
@property(readwrite)int     gameType;
@property(readwrite)float   p1_reload;
@property(readwrite)float   p2_reload;
@property(readwrite)int     current_level;
@property(readwrite, assign)HiveMind *hive;

+(GameGlobal *)sharedGlobals;

-(bool)nextLevel;
-(void)setKeysForPlayer:(int)player up:(int)_up down:(int)_down left:(int)_left right:(int)_right primary:(int)_prime;
-(int)getKey:(int)key forPlayer:(int)player;

@end
