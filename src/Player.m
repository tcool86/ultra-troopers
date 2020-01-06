//
//  Player.m
//  Demo Mac Port
//
//  Created by Timothy Cool on 7/1/11.
//  Copyright 2011 Electrobud. All rights reserved.
//

#import "Player.h"


@implementation Player
@synthesize animations;
@synthesize controller;
@synthesize playerBody, playerShape;
@synthesize player_number;
@synthesize gotHit;
@synthesize dead;

-(id)initWithTexture:(CCTexture2D *)texture character:(NSString*)name {

    return self;
}

//May have to move unto main game
-(void)setupWeapons:(CCSpriteBatchNode *)weapons_sheet withSpace:(cpSpace *)_space {
    //Retrieve player weapon type
    int primary_weapon = player_number;
    
    primary = [[Weapon alloc] initAsWeapon:primary_weapon withBatch:weapons_sheet inSpace:_space forPlayer:player_number];
    
}

-(void)setupPlayer:(NSString*)characterChosen:(int)playerSlot {
    //setup initial player stuff from globals...
    player_number = playerSlot;
    speed = 2.0f;
    if (player_number == 1) {
        [GameGlobal sharedGlobals].p1_health = 7;
    }else{
        [GameGlobal sharedGlobals].p2_health = 7;
    }
    
    controller = [[PlayerController alloc] init];
    
    //Globally assign characterchosen to slot?
    [self loadAnimation];
    [self setupCollision];
}

#define COLL_WIDTH  14
#define COLL_HEIGHT 6

-(void)setupCollision {
    //Mass maybe different for each character?
    playerBody = cpBodyNew(120, INFINITY);
    playerBody->p = cpv(-1000,-1000);
    
    float shape_r   = 14 * scaleX_;
    float shape_dy  = -12 * scaleY_;
    
    playerShape = cpCircleShapeNew(playerBody, shape_r, ccp(0,shape_dy));
    playerShape->e = 0.0f;
    playerShape->data = self;
    if (player_number == 1) {
        playerShape->collision_type = kPLAYER1_COLL;
    }else{
        playerShape->collision_type = kPLAYER2_COLL;
    }
    cpShapeSetGroup(playerShape, kFRIENDLY);
}

-(void)addToSpace:(cpSpace*)_space {
    cpSpaceAddBody(_space, playerBody);      
    cpSpaceAddShape(_space, playerShape);

}

-(void)loadAnimation {
    animations = [[NSMutableArray alloc] init];
    
    //Animations for player 1 and 2
    if (player_number == 1) {
        [self setupAnimationSet:0];
    }else{
        [self setupAnimationSet:2];
    }
        
}

#define PLAYER_WIDTH    32
#define PLAYER_HEIGHT   32
-(void)setupAnimationSet:(int)starting_row {
    [self setScale:1.5f];
    //[self.textureAtlas.texture setAliasTexParameters];
    //idle
    [self addPlayerAnimation:@"idle"startColumn:0 inRow:starting_row withFrameCount:1];
    //walking
    [self addPlayerAnimation:@"walk_forward"startColumn:0 inRow:starting_row withFrameCount:4];
    [self addPlayerAnimation:@"walk_backward"startColumn:4 inRow:starting_row withFrameCount:4];
    [self addPlayerAnimation:@"walk_left"startColumn:0 inRow:starting_row+1 withFrameCount:4];
    [self addPlayerAnimation:@"walk_right"startColumn:4 inRow:starting_row+1 withFrameCount:4];
    
    NSMutableArray *death_frames = [[NSMutableArray alloc] init];
    CCSpriteFrame   *frame = [CCSpriteFrame frameWithTexture:self.textureAtlas.texture
                                                        rect:CGRectMake(  0, starting_row*PLAYER_HEIGHT, PLAYER_WIDTH, PLAYER_HEIGHT)];
    CCSpriteFrame   *frame2 = [CCSpriteFrame frameWithTexture:self.textureAtlas.texture
                                                         rect:CGRectMake(  0, (starting_row+1)*PLAYER_HEIGHT, PLAYER_WIDTH, PLAYER_HEIGHT)];
    CCSpriteFrame   *frame3 = [CCSpriteFrame frameWithTexture:self.textureAtlas.texture
                                                         rect:CGRectMake(128, starting_row*PLAYER_HEIGHT, PLAYER_WIDTH, PLAYER_HEIGHT)];
    CCSpriteFrame   *frame4 = [CCSpriteFrame frameWithTexture:self.textureAtlas.texture
                                                         rect:CGRectMake(128, (starting_row+1)*PLAYER_HEIGHT, PLAYER_WIDTH, PLAYER_HEIGHT)];
    [death_frames addObject:frame];
    [death_frames addObject:frame2];
    [death_frames addObject:frame3];
    [death_frames addObject:frame4];
    CCAnimation *death_animation = [CCAnimation animationWithName:@"death" delay:0.2 frames:death_frames];
    [animations addObject:death_animation];
}

-(void)addPlayerAnimation:(NSString *)name startColumn:(int)anim_col inRow:(int)anim_row withFrameCount:(int)number_of_frames {
    //Add animations by row
    //anim_col = starting position
    //anim_row = the row from the sheet
    //i is the counter that increments the position
    int i;
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    for (i=0;i<number_of_frames;i++) {
        CCSpriteFrame   *frame      = [CCSpriteFrame frameWithTexture:self.textureAtlas.texture 
                                                             rect:CGRectMake((anim_col+i)*PLAYER_WIDTH, anim_row*PLAYER_HEIGHT,
                                                                             PLAYER_WIDTH, PLAYER_HEIGHT)];
        [frames addObject:frame];
    }
//    for (i=number_of_frames-2;i>=1;i--) {
//        CCSpriteFrame   *frame      = [CCSpriteFrame frameWithTexture:self.textureAtlas.texture 
//                                                                 rect:CGRectMake((anim_col+i)*PLAYER_WIDTH, anim_row*PLAYER_HEIGHT,
//                                                                                 PLAYER_WIDTH, PLAYER_HEIGHT)];
//        [frames addObject:frame];
//    }
     
    CCAnimation     *animation  = [CCAnimation animationWithName:name frames:[NSArray arrayWithArray:frames]];
    [animation setDelay:0.2];
    [animations addObject:animation];
}

-(void)controllerKey:(int)key pressed:(bool)_pressed {
    if (key == [[GameGlobal sharedGlobals] getKey:kUP forPlayer:player_number]) {
        [controller setUp:_pressed];
        if (_pressed == YES) {
            if (controller.last_up < 0) {
                [controller setLast_up:0];
            }   
        }else{
            controller.last_up = -1;
        }
	}
    if (key == [[GameGlobal sharedGlobals] getKey:kDOWN forPlayer:player_number]) {
        [controller setDown:_pressed];
        if (_pressed == YES) {
            if (controller.last_down < 0) {
                [controller setLast_down:0];
            }   
        }else{
            controller.last_down = -1;
        }
	}
	if (key == [[GameGlobal sharedGlobals] getKey:kLEFT forPlayer:player_number]) {
		[controller setLeft:_pressed];
        if (_pressed == YES) {
            if (controller.last_left < 0) {
                [controller setLast_left:0];
            }
        }else{
            controller.last_left = -1;
        }
	}
    if (key == [[GameGlobal sharedGlobals] getKey:kRIGHT forPlayer:player_number]) {
		[controller setRight:_pressed];
        if (_pressed == YES) {
            if (controller.last_right < 0) {
                [controller setLast_right:0];
            }
        }else{
            controller.last_right = -1;
        }
	}
    if (key == [[GameGlobal sharedGlobals] getKey:5 forPlayer:player_number]) {
		[controller setPrimary:_pressed];
	}
}

-(void)updatePlayer:(ccTime)dt {
    if (dead == YES) {
        if (playerShape->collision_type != -1) {
            id death_anim = [self getActionByTag:kDEATH_TAG];
            if(death_anim == nil) {
                playerShape->collision_type = -1;
                playerBody->p = cpv(-1000,-1000);
            }
        }
        return;
    }
    if (gotHit == NO) {
        [self move];
    }
    [primary updateWeapon:dt];
    
    id hit = [self getActionByTag:kHIT_TAG];
    if (hit == nil) {
        gotHit = NO;
    }
}

-(void)switchToStillAnimation {
    
    if (current_animation == kLEFT) {
        
    }else if(current_animation == kRIGHT) {
        
    }else if(current_animation == kUP) {
        
    }else if(current_animation == kDOWN) {
        
    }
    
}

#define MOVE_STEP 640
//you'll want to variable this one later
#define MAX_SPEED 200
-(void)move {
    
    //Set movement to idle to begin
    int horiz = 0, vert = 0;
    current_animation = kNONE; //idle
    
    //Check for key presses
    
    //Left & Right
    if (controller.left == YES) {
        controller.last_left++;
        current_animation = kLEFT;
        horiz = -MOVE_STEP;
    }
    if (controller.right == YES) {
        controller.last_right++;
        current_animation = kRIGHT;
        horiz = MOVE_STEP;   
    }
    
    //If both are pressed
    if (controller.right == YES && controller.left == YES) {
        //check precedence
        cpVect vel = cpBodyGetVel(playerBody);
        if (controller.last_left > controller.last_right) {
            current_animation = kRIGHT;
            //reset x velocity if direction changed
            if (vel.x < 0) {playerBody->v = cpv(0,vel.y);}
            horiz = MOVE_STEP;
            
        }else{
            current_animation = kLEFT;
            //reset x velocity if direction changed
            if (vel.x > 0) {playerBody->v = cpv(0,vel.y);}
            horiz = -MOVE_STEP;
        }
    }
    
    
    //Up & Down
    if (controller.up == YES) {
        controller.last_up++;
        current_animation = kUP;
        vert = MOVE_STEP;
    }
    if (controller.down == YES) {
        controller.last_down++;
        current_animation = kDOWN;
        vert = -MOVE_STEP;
    }

    //If both are pressed
    if (controller.up == YES && controller.down == YES) {
        //check precedence
        cpVect vel = cpBodyGetVel(playerBody);
        if (controller.last_up > controller.last_down) {
            current_animation = kDOWN;
            //reset y velocity if direction changed
            if (vel.y > 0) {playerBody->v = cpv(vel.x,0);}
            vert = -MOVE_STEP;
        }else{
            current_animation = kUP;
            //reset y velocity if direction changed
            if (vel.y < 0) {playerBody->v = cpv(vel.x,0);}
            vert = MOVE_STEP;
        }
    }
    
    //Actual Impulse applied
    cpBodyApplyImpulse(playerBody, cpv(horiz*speed,vert*speed), cpvzero);
    
    //Stop player if idle in either direction
    if (horiz == 0) {
        cpVect vel = cpBodyGetVel(playerBody);
        playerBody->v = cpv(0,vel.y);
    }
    if (vert == 0) {
        cpVect vel = cpBodyGetVel(playerBody);
        playerBody->v = cpv(vel.x,0);
    }
    
    
    //Speed Limit Checks
    cpVect checkVel = cpBodyGetVel(playerBody);
    
    if (checkVel.x > MAX_SPEED) {
        playerBody->v = cpv(MAX_SPEED,checkVel.y);
        checkVel = cpBodyGetVel(playerBody);
    }
    
    if (checkVel.y > MAX_SPEED) {
        playerBody->v = cpv(checkVel.x,MAX_SPEED);
        checkVel = cpBodyGetVel(playerBody);
    }
    
    if (checkVel.x < -MAX_SPEED) {
        playerBody->v = cpv(-MAX_SPEED,checkVel.y);
        checkVel = cpBodyGetVel(playerBody);
    }
    
    if (checkVel.y < -MAX_SPEED) {
        playerBody->v = cpv(checkVel.x,-MAX_SPEED);
        checkVel = cpBodyGetVel(playerBody);
    }

//    if ((checkVel.x > MAX_SPEED || checkVel.y > MAX_SPEED) || (checkVel.x < -MAX_SPEED || checkVel.y < -MAX_SPEED)) {
//        NSLog(@"\nVelocity: %f, %f",checkVel.x,checkVel.y);        
//    }

    //Animation Purposes
    if (current_animation != previous_animation || [self getActionByTag:ANIM_TAG+current_animation] == nil) {
        [self stopActionByTag:ANIM_TAG+previous_animation];
        
        if (current_animation != kNONE) {
            id animation_action = [CCAnimate actionWithAnimation:[animations objectAtIndex:current_animation] restoreOriginalFrame:NO];
            [animation_action setTag:ANIM_TAG+current_animation];
            [self runAction:animation_action];
        }else{
            
        }
    }
    
    if(current_animation != kNONE) {
        direction = current_animation;
    }
    
    previous_animation = current_animation;
    
    //Shooting
    if (controller.primary == YES) {
        [primary fireWeapon:self.position withVelocity:checkVel andDirection:direction];
    }else{
        [primary rechargeWeapon];
    }
    
}

-(void)getHit:(int)damage {
    id flash = [CCTintTo actionWithDuration:0.2 red:255 green:0 blue:0];
    id flashback = [CCTintTo actionWithDuration:0.1 red:255 green:255 blue:255];
    
    id sequence = [CCSequence actions:flash, flashback, nil];
    [sequence setTag:kHIT_TAG];
    [self runAction:sequence];
    gotHit = YES;
    if (player_number == 1) {
        [GameGlobal sharedGlobals].p1_health -= damage;
        if ([GameGlobal sharedGlobals].p1_health < 0) {
            [self die];
        }
    }else{
        [GameGlobal sharedGlobals].p2_health -= damage;
        if ([GameGlobal sharedGlobals].p2_health < 0) {
            [self die];
        }
    }
    
}

-(void)die {
    NSLog(@"Player Dead!");
    id flash = [CCTintTo actionWithDuration:0.2 red:255 green:0 blue:0];
    id flashback = [CCTintTo actionWithDuration:0.1 red:255 green:255 blue:255];
    
    id sequence = [CCSequence actions:flash, flashback, nil];
    [sequence setTag:kHIT_TAG];
    [self runAction:sequence];
    [[SimpleAudioEngine sharedEngine] playEffect:@"player_death.wav"];
    id death_anim = [CCAnimate actionWithAnimation:[animations lastObject]];
    [death_anim setTag:kDEATH_TAG];
    [self runAction:death_anim];
    id fadeOut = [CCFadeOut actionWithDuration:1.0];
    [self runAction:fadeOut];
    dead = YES;
}


@end
