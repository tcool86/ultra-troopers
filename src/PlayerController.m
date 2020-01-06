//
//  PlayerController.m
//  Ultra Troopers
//
//  Created by Timothy Cool on 7/8/11.
//  Copyright 2011 Electrobud. All rights reserved.
//

#import "PlayerController.h"

@implementation PlayerController

@synthesize up,down,left,right;
@synthesize last_up,last_down,last_left,last_right;
@synthesize primary;

-(id)init {
    [super init];
    up = NO;
    down = NO;
    left = NO;
    right = NO;
    primary = NO;
    
    last_up     = NO;
    last_down   = NO;
    last_left   = NO;
    last_right  = NO;
    
    return self;
}

-(void)updateXboxController {
    
}

@end
