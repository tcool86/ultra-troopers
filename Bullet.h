//
//  Bullet.h
//  Ultra Troopers
//
//  Created by Timothy Cool on 7/14/11.
//  Copyright 2011 Electrobud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameGlobal.h"
#import "SimpleAudioEngine.h"
#include "chipmunk/chipmunk.h"

@interface Bullet : CCSprite {
    cpBody      *bullet_body;
    cpShape     *bullet_shape;
 
    CCParticleSystem    *trail;
    CCParticleSystem    *contact;
    
    int         type;
    bool        ready;

    int         range;
    int         strength;
    
    float       ticker;
}

@property(readwrite)int type;
@property(readwrite)bool ready;
@property(readwrite)int range;
@property(readwrite)int strength;

-(id)initBulletAs:(int)bullet_type withSheet:(CCSpriteBatchNode*)_sheet inSpace:(cpSpace*)_space withRange:(int)_range andStrength:(int)_strength;

-(void)bulletActive;
-(void)updateBullet:(ccTime)dt;

-(void)fireBulletAtPoint:(CGPoint)point;
-(void)fireBulletAtPoint:(CGPoint)point withVelocity:(cpVect)vel;
-(void)fireBulletAtPoint:(CGPoint)point withVelocity:(cpVect)vel andDirection:(int)direction;

-(void)contactWithObject; //consider (id)sender if selector performed
-(void)resetBullet;

@end
