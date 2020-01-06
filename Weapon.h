//
//  Weapon.h
//  Ultra Troopers
//
//  Created by Timothy Cool on 7/14/11.
//  Copyright 2011 Electrobud. All rights reserved.
//

//  Manages/Creates Bullets 

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameGlobal.h"
#include "chipmunk/chipmunk.h"
#import "Bullet.h"


@interface Weapon : NSObject {
    int                 type;
    int                 myPlayer;
    //Array of bullets
    NSMutableArray      *bullets;
    //Iterator
    int                 current_bullet;
    
    //The amount of damage the weapon does
    int                 strength;
    //The range of the weapon
    int                 range;
    //How long the weapon takes to recharge
    int                 rate;
    //Incrementor for rate
    float               current_charge;
    float               reload_ticker;
    
    //Flag for whether or not the weapon has cooled
    //and is ready to be used again
    bool                ready;
}

@property(readwrite)int      type;
@property(readwrite, assign) NSMutableArray *bullets;

@property(readwrite)bool    ready;
@property(readwrite)int     rate;
@property(readwrite)int     range;
@property(readwrite)int     strength;
@property(readwrite)int     myPlayer;
@property(readwrite)float   current_charge;
@property(readwrite)float   reload_ticker;
@property(readwrite)int     current_bullet;


+(void)upgradeWeapon:(int)weapon_upgrade;
-(id)initAsWeapon:(int)weapon_type withBatch:(CCSpriteBatchNode*)bullet_batch inSpace:(cpSpace*)_space forPlayer:(int)player;
-(void)setupWeapon;
-(void)fireWeapon:(CGPoint)point withVelocity:(cpVect)vel andDirection:(int)direction;
-(void)updateWeapon:(ccTime)dt;
-(bool)canShoot;
-(void)rechargeWeapon;


@end
