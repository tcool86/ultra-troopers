//
//  Weapon.m
//  Ultra Troopers
//
//  Created by Timothy Cool on 7/14/11.
//  Copyright 2011 Electrobud. All rights reserved.
//

#import "Weapon.h"


@implementation Weapon
@synthesize type;
@synthesize bullets;
@synthesize ready, rate, range, strength;
@synthesize current_bullet, current_charge, reload_ticker;
@synthesize myPlayer;

+(void)upgradeWeapon:(int)weapon_upgrade{
    
}

-(id)initAsWeapon:(int)weapon_type withBatch:(CCSpriteBatchNode*)bullet_batch inSpace:(cpSpace*)_space forPlayer:(int)player {
    self = [super init];
    self.type = weapon_type;
    self.myPlayer = player;
    [self setupWeapon];
    
    //Add costumization later
    //for now
    bullets = [[NSMutableArray alloc] init];
    int i;
    for (i=0; i<self.rate; i++) {
        Bullet *b = [[Bullet alloc] initBulletAs:weapon_type 
                                       withSheet:bullet_batch 
                                         inSpace:_space 
                                       withRange:self.range 
                                     andStrength:self.strength];
        [bullet_batch addChild:b];
        [bullets addObject:b];
    }
    
    return self;
}

-(void)updateWeapon:(ccTime)dt {
    current_charge += dt;
    reload_ticker += dt;
    if (ready == NO) {
        if (current_charge >= .50) {
            ready = YES;
            current_charge = 0;
        }
    }else{
    }
    
    if (reload_ticker > 0.1) {
        reload_ticker = 0;
        if (myPlayer == 1) {
            if ([GameGlobal sharedGlobals].p1_reload < 10) {[GameGlobal sharedGlobals].p1_reload++;};
        }else if(myPlayer == 2) {
            if ([GameGlobal sharedGlobals].p2_reload < 10) {[GameGlobal sharedGlobals].p2_reload++;};
        }
    }
   
    for (Bullet *b in bullets) {
            [b updateBullet:dt];
    }

}

-(void)setupWeapon{
    
    //Add costumization later
    //for now
    self.ready          = YES;
    self.rate           = 20;
    self.range          = 600;
    self.strength       = 10;
    self.current_bullet = 0;
    self.current_charge = 0;
}

-(void)rechargeWeapon {
    current_charge = 0;
    ready = YES;
}

-(bool)canShoot {
    if (ready == NO){
        return NO;
    }
    return YES;
}

-(void)fireWeapon:(CGPoint)point withVelocity:(cpVect)vel andDirection:(int)direction{
    
    if (ready == YES) {
        Bullet *b = [bullets objectAtIndex:current_bullet];
        [b fireBulletAtPoint:point withVelocity:vel andDirection:direction];
        current_bullet++;
        if (current_bullet > [bullets count]-1) {
            current_bullet = 0;
        }
        if (myPlayer == 1) {
            if ([GameGlobal sharedGlobals].p1_reload > 0) {[GameGlobal sharedGlobals].p1_reload--;}
        }else{
            if ([GameGlobal sharedGlobals].p2_reload > 0) {[GameGlobal sharedGlobals].p2_reload--;}
        }
        ready = NO;
    }
    
}


@end
