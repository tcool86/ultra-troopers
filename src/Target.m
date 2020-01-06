//
//  Target.m
//  Ultra Troopers
//
//  Created by Timothy Cool on 7/19/11.
//  Copyright 2011 Electrobud. All rights reserved.
//

#import "Target.h"


@implementation Target
@synthesize type;
@synthesize strength;
@synthesize hit;
@synthesize direction;
@synthesize dead;
@synthesize mind;
@synthesize attack_mode;
@synthesize target_id;
@synthesize updateMovement;
@synthesize movements;

-(id) initWithMovement:(NSMutableArray*)movements withBatchNode:(CCSpriteBatchNode*)batch asEnemy:(int)_type {
    CGRect startCoordinates;
    startCoordinates = CGRectMake(0, 0, 32, 32);
    self.type = _type;
    self = [super initWithBatchNode:batch rect:startCoordinates];
    
    return self;
}

-(void)setupCollision {
    int mass;
    int radius;
    CGRect rect;
    CGPoint offset;
    int shapeType;
    
    movements = [[NSMutableArray alloc] init];
    attack_mode = NO;
    updateMovement = YES;
    
    //initialize animations array
    animations = [[NSMutableArray alloc] init];
    
    //Select type and determine attributes
    switch (type) {
        case kGREEN:
            hitPoints = 3;
            strength = 1;
            mass = 100;
            speed = 128;
            radius = 0.0;
            rect = CGRectMake(0, 0, 16, 16);
            offset = cpvzero;
            shapeType = kSQUARE;
            [self setupAnimation:kGREEN];
            break;
        case kRED:
            hitPoints = 3;
            strength = 1;
            mass = 100;
            speed = 196;
            radius = 0.0;
            rect = CGRectMake(0, 0, 16, 16);
            offset = cpvzero;
            shapeType = kSQUARE;
            [self setupAnimation:kRED];
            break;
        case kPURP:
            hitPoints = 8;
            strength = 3;
            mass = 100;
            speed = 132;
            radius = 0.0;
            rect = CGRectMake(0, 0, 16, 16);
            offset = cpvzero;
            shapeType = kSQUARE;
            [self setupAnimation:kPURP];
            break;
        default:
            break;
    }
    
    target_body = cpBodyNew(mass, INFINITY);
    target_body->p = self.position;
    
    //define retangular box shape
    cpVect verts[] = {
		cpv(-rect.size.width,-rect.size.height),
		cpv(-rect.size.width, rect.size.height),
		cpv( rect.size.width, rect.size.height),
		cpv( rect.size.width,-rect.size.height),
	};
    
    //create shape
    if (shapeType == kSQUARE) {
        target_shape = cpPolyShapeNew(target_body, 4, verts, offset);
    }else if(shapeType == kCIRCLE) {
        target_shape = cpCircleShapeNew(target_body, radius, offset);
    }
    target_shape->data = self;
    target_shape->collision_type = kTARGET_COLL;
    
    cpShapeSetGroup(target_shape, kENEMIES+target_id);
    hit = NO;
    dead = NO;
    moveTicks = 100;
}

-(void)addToSpace:(cpSpace*)_space {
    [self setupCollision];
    cpSpaceAddBody(_space, target_body);
    cpSpaceAddShape(_space, target_shape);
}

-(AStarNode*)nodeWithDirection:(cpVect)vector {
    AStarNode *node = [[AStarNode alloc] initWithX:0 andY:0];
    [node setDirection:vector];
    return node;
}
-(AStarNode*)randomDirection {
    float  x = CCRANDOM_MINUS1_1();
    float  y = CCRANDOM_MINUS1_1();
    int     round_x = roundf(x);
    int     round_y = roundf(y);
    AStarNode *node = [[AStarNode alloc] initWithX:0 andY:0];
    [node setDirection:cpv(round_x,round_y)];
    return node;
}

#define ATTACK_DIST 196
-(void)tryMove {
    CGPoint player_pos = [mind closestPlayer:self.position];
    if (ccpDistance(player_pos, self.position) <= ATTACK_DIST) {
        attack_mode = YES;
        NSLog(@"ATTACK!");
    }
    //NSLog(@"Closest Player at: %f, %f", player_pos.x, player_pos.y);
    
    int   path_x = 0, path_y = 0;
    float move_x = 0, move_y = 0;
    
    if (updateMovement == YES) {
        [movements removeAllObjects];
 
        AStarNode *node = [self randomDirection];
        [movements addObject:node];
        AStarNode *node2 = [self randomDirection];
        [movements addObject:node2];
        AStarNode *node3 = [self randomDirection];
        [movements addObject:node3];
        AStarNode *node4 = [self randomDirection];
        [movements addObject:node4];
        
        next_move = 0;
        updateMovement = NO;
       //[mind solutionForPointsPath:self.position :player_pos];
    }else{
        if (next_move >= [movements count]) {
            updateMovement = YES;
        }else{
            AStarNode *move = [movements objectAtIndex:next_move];
            path_x = move.direction.x;
            path_y = move.direction.y;
            next_move++;
        }
    }
    if (attack_mode == YES) {
        if (self.position.x < player_pos.x) {
            move_x = speed;
            current_animation = kRIGHT;
        }else if (self.position.x > player_pos.x){
            move_x = -speed;
            current_animation = kLEFT;
        }else{
            move_x = 0;
        }
        if (self.position.y < player_pos.y) {
            move_y = speed;
            if(self.position.y < player_pos.y - 32){current_animation = kUP;}
        }else if(self.position.y > player_pos.y){
            move_y = -speed;
            if(self.position.y < player_pos.y + 32){current_animation = kDOWN;}
        }else{
            move_y = 0;
        }
        
    }else{ //pathfinding mode
        if(path_x > 0){
            move_x = speed;
            current_animation = kRIGHT;
        }else if(path_x < 0){
            move_x = -speed;
            current_animation = kLEFT;
        }else{
            move_x = 0;
        }
        
        if(path_y > 0){
            move_y = speed;
            current_animation = kUP;
        }else if(path_y < 0){
            move_y = -speed;
            current_animation = kDOWN;
        }else{
            move_y = 0;
        }
    }
    direction = current_animation;
    target_body->v = cpv(move_x,move_y);
}

-(void)setupAnimation:(int)starting_row {
    [self setScale:1.5f];
    
    //idle
    [self addEnemyAnimation:@"idle"startColumn:0 inRow:starting_row withFrameCount:1];
    //walking
    [self addEnemyAnimation:@"walk_forward"startColumn:0 inRow:starting_row withFrameCount:4];
    [self addEnemyAnimation:@"walk_backward"startColumn:4 inRow:starting_row withFrameCount:4];
    [self addEnemyAnimation:@"walk_left"startColumn:0 inRow:starting_row+1 withFrameCount:4];
    [self addEnemyAnimation:@"walk_right"startColumn:4 inRow:starting_row+1 withFrameCount:4];
}

#define ENEMY_WIDTH    32
#define ENEMY_HEIGHT   32

-(void)addEnemyAnimation:(NSString *)name startColumn:(int)anim_col inRow:(int)anim_row withFrameCount:(int)number_of_frames {
    //Add animations by row
    //anim_col = starting position
    //anim_row = the row from the sheet
    //i is the counter that increments the position
    int i;
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    for (i=0;i<number_of_frames;i++) {
        CCSpriteFrame   *frame      = [CCSpriteFrame frameWithTexture:self.textureAtlas.texture 
                                                                 rect:CGRectMake((anim_col+i)*ENEMY_WIDTH, anim_row*ENEMY_HEIGHT,
                                                                                 ENEMY_WIDTH, ENEMY_HEIGHT)];
        [frames addObject:frame];
    }
    
    CCAnimation     *animation  = [CCAnimation animationWithName:name frames:[NSArray arrayWithArray:frames]];
    [animation setDelay:0.2];
    [animations addObject:animation];
}

-(void)updateTarget:(ccTime)dt {
    //AI here
    hitTicker += dt;
    moveTicks += dt;
    
    if (hit==YES) {
        hit = NO;
        //DEAD
        if (dead == YES) {
            hitTicker = 0;
            id stretch = [CCScaleTo actionWithDuration:0.2 scaleX:0.5 scaleY:2.7];
            id fade = [CCFadeOut actionWithDuration:0.2f];
            [self runAction:stretch];
            [self runAction:fade];
            [[SimpleAudioEngine sharedEngine] playEffect:@"enemy_death.wav"];
            cpShapeSetCollisionType(target_shape, -1); //Collide with nothing
            [mind removeEnemy];
        }
    }
    if (dead && hitTicker >= 0.2) {
        //take the body off screen
        target_body->p = ccp(-1000,-1000);
    }
    if ([mind shouldTry:self.position]) {
        if (moveTicks > .25) {
            moveTicks = 0;
            [self tryMove];
        }
    }
    
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
    
}

-(void)gotHit {
    hitPoints--;
    hit = YES;
    if (hitPoints <= 0) {
        dead = YES;
    }
    id flash = [CCTintTo actionWithDuration:0.05f red:255 green:0 blue:0];
    id flashBack = [CCTintTo actionWithDuration:0.1f red:255 green:255 blue:255];
    id hitFlashes = [CCSequence actions:flash, flashBack, nil];
    
    [self runAction:hitFlashes];
}

@end
