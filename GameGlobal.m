//
//  GameGlobal.m
//  MaidenDays
//
//  Created by Timothy Cool on 6/5/11.
//  Copyright 2011 Electrobud. All rights reserved.
//

#import "GameGlobal.h"

static GameGlobal *sharedInstance = nil;

@implementation GameGlobal

@synthesize p1Start,p2Start;
@synthesize p1_health,p2_health;
@synthesize p1_reload,p2_reload;
@synthesize p1_score,p2_score;
@synthesize current_level;
@synthesize gameType;
@synthesize hive;

+(GameGlobal *)sharedGlobals {
    @synchronized (self) {
        if (sharedInstance == nil) {
            [[self alloc] init];
        }
    }
    return sharedInstance;
}

- (id)init {
    @synchronized(self) {
        [super init];
        [self setKeysForPlayer:1 up:KEY_UP down:KEY_DOWN left:KEY_LEFT right:KEY_RIGHT primary:KEY_SHOOT];
        [self setKeysForPlayer:2 up:KEY_UP_2 down:KEY_DOWN_2 left:KEY_LEFT_2 right:KEY_RIGHT_2 primary:KEY_SHOOT_2];
        self.current_level = 1;
        return self;
    }
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    
    return nil;
}

-(void)setKeysForPlayer:(int)player up:(int)_up down:(int)_down left:(int)_left right:(int)_right primary:(int)_prime {
    if (player == 1) {
        p1Keys[kUP]     = _up;
        p1Keys[kDOWN]   = _down;
        p1Keys[kLEFT]   = _left;
        p1Keys[kRIGHT]  = _right;
        p1Keys[5]       = _prime;
    }else if(player==2) {
        p2Keys[kUP]     = _up;
        p2Keys[kDOWN]   = _down;
        p2Keys[kLEFT]   = _left;
        p2Keys[kRIGHT]  = _right;
        p2Keys[5]       = _prime;
    }
}

-(int)getKey:(int)key forPlayer:(int)player {
    if (player == 1) {
        return p1Keys[key];
    }else if(player == 2){
        return p2Keys[key];        
    }
    //No button?
    NSLog(@"Error no button found");
    return 0;
}

#define TOTAL_LEVELS 5
-(bool)nextLevel{
    current_level++;
    if (current_level == TOTAL_LEVELS) {
        return NO;
    }
    return YES;
}

- (id)copyWithZone:(NSZone *)zone {return self;}

- (id)retain {return self;}

- (void)release {}

- (id)autorelease {return self;}


@end
