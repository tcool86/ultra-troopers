//
//  Bullet.m
//  Ultra Troopers
//
//  Created by Timothy Cool on 7/14/11.
//  Copyright 2011 Electrobud. All rights reserved.
//

#import "Bullet.h"


@implementation Bullet

@synthesize type, ready;
@synthesize range, strength;

-(void)setupCollision {
    //Collision width and height
    int coll_width=6;
    int coll_height=6;
    
    //change depending on weapon
    switch (type) {
        case 0:
            //^
            break;
        case 1:
            //^
            
        //Other cases?
        default:
            break;
    }
    
    //Mass maybe different for each character?
    bullet_body = cpBodyNew(40, INFINITY);
    bullet_body->p = self.position;
    
    //define retangular box shape
    cpVect verts[] = {
		cpv(-coll_width,-coll_height),
		cpv(-coll_width, coll_height),
		cpv( coll_width, coll_height),
		cpv( coll_width,-coll_height),
	};
    
    //create shape
    bullet_shape = cpPolyShapeNew(bullet_body, 4, verts, ccp(coll_width/2,-(coll_height/2)));
    bullet_shape->e = 0.0f;
    bullet_shape->data = self;
    bullet_shape->collision_type = kBULLET_COLL;
    //A group value of 2 for now... just to prevent collision with players
    cpShapeSetGroup(bullet_shape, kFRIENDLY);
}

-(void)addToSpace:(cpSpace*)_space {
    cpSpaceAddBody(_space, bullet_body);
    cpSpaceAddShape(_space, bullet_shape);
}


-(id)initBulletAs:(int)bullet_type withSheet:(CCSpriteBatchNode*)_sheet inSpace:(cpSpace*)_space withRange:(int)_range andStrength:(int)_strength {
    self.type = bullet_type;
    self.ready = YES; //initially ready
    self.range = _range;
    self.strength = _strength;
    CGRect bullet_texture_rect = CGRectMake(0, 0, 32, 32);
    
    switch (bullet_type) {
        case 0:
            //^
            break;
        case 1:
            bullet_texture_rect  = CGRectMake(0, 0, 32, 32);
            trail = [CCParticlePlayer1 node];
            break;
        case 2:
            bullet_texture_rect  = CGRectMake(32, 0, 32, 32);
            trail = [CCParticlePlayer2 node];
            break;
        default:
            break;
    }

    
    self = [super initWithBatchNode:_sheet rect:bullet_texture_rect];
    
    //Particle Effects
    [trail stopSystem];
    trail.positionType = kCCPositionTypeGrouped;
    
    contact = [CCParticleTestExplode node];
    [contact stopSystem];
    contact.positionType = kCCPositionTypeGrouped;
    
    [_sheet.parent addChild:trail];    
    [_sheet.parent addChild:contact];
    [_sheet.parent reorderChild:trail z:101];
    [_sheet.parent reorderChild:contact z:101];
    
    [self setupCollision];
    [self addToSpace:_space];
    
    return self;
}

#define MAX_SPEED 300
#define LIFE      1

-(void)bulletActive {
    ticker = LIFE;
    cpShapeSetCollisionType(bullet_shape, kBULLET_COLL); //Collide with anything but friendlies
    [self setVisible:YES];
    ready = YES;
    [trail resetSystem];
}

-(void)updateBullet:(ccTime)dt {
    if (ready == YES) {
        CGPoint trailPoint = ccp(self.position.x,self.position.y);
        [trail setPosition:trailPoint];
        ticker -= dt;
        if (ticker <= 0 ) {
            [self resetBullet];
        }
    }
}

-(void)fireBulletAtPoint:(CGPoint)point {
    
}
-(void)fireBulletAtPoint:(CGPoint)point withVelocity:(cpVect)vel {
    
}


-(void)fireBulletAtPoint:(CGPoint)point withVelocity:(cpVect)vel andDirection:(int)direction {
    int x=0,y=0;
    
//    if (vel.x == 0 && vel.y == 0) {
        //Use last direction to determine bullet movement
    switch (direction) {
        case kUP:
            y = MAX_SPEED;
            [trail setAngle:270];
            break;
        case kDOWN:
            y = -MAX_SPEED;
            [trail setAngle:90];
            break;
        case kRIGHT:
            x = MAX_SPEED;
            [trail setAngle:180];
            break;
        case kLEFT:
            x = -MAX_SPEED;
            [trail setAngle:0];
            break;
        default:
            break;
    }

    bullet_body->p = point;
    bullet_body->v = cpv(x, y);
    [self bulletActive];
    [[SimpleAudioEngine sharedEngine] playEffect:@"shoot2.wav"];
    //NSLog(@"\nBullet Vel: %i, %i",x,y);
}

-(void)contactWithObject { //consider (id)sender if selector performed
    CGPoint contactPoint = ccp(self.position.x,self.position.y);
    [contact setPosition:contactPoint];
    [contact resetSystem];
    [trail stopSystem];
    self.scale = 2.0f;
    [self resetBullet];
}

-(void)resetBullet {
    [self setVisible:NO];
    ticker = 0;
    //Send 'Er off to the ether
    bullet_body->p = ccp(-1000,-1000);
    cpShapeSetCollisionType(bullet_shape, -1); //Collide with nothing
    ready = NO;
    [self setScale:1.0f];
}

@end
