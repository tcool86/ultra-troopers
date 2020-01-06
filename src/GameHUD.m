//
//  GameHUD.m
//  Ultra Troopers
//
//  Created by Timothy Cool on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameHUD.h"


@implementation GameHUD

-(int)multiplayerCheck {
    int game = [[GameGlobal sharedGlobals] gameType];
    return game;
}


-(id)initWithPlayer:(int)p_num {
    
    self = [super init];
    if (self) {
        //Backdrop
        CCSprite *back = [CCSprite spriteWithFile:@"hud_backdrop.png"];
        [self addChild:back];
        //Score text
        score = [CCLabelBMFont labelWithString:@"0" fntFile:@"ultra_troper_score.fnt"];
        [score setScale:0.75];
        //Health Bars
        bars = [[NSMutableArray alloc] init];
        CGPoint start_pos = ccp(0,0);
        if (p_num == 1) {
            start_pos = ccp(72,456);
            [back setAnchorPoint:ccp(0,0.5)];
            [back setPosition:ccp(0,455)];
        }else if(p_num == 2) {
            start_pos = ccp(640-72,456);
            [back setAnchorPoint:ccp(1,0.5)];
            [back setFlipX:YES];
            [back setPosition:ccp(640,455)];
        }
        int i;
        if (p_num == 1 || p_num == 3) {
            for (i=8; i>0; i--) {
                CCSprite *bar = [CCSprite spriteWithFile:@"p1Health.png"];
                [bar setPosition:ccp(start_pos.x + (i*24),start_pos.y)];
                [self addChild:bar];
                [bars addObject:bar];
            }   
        }
        if (p_num == 2 || p_num == 4) {
            for (i=8; i>0; i--) {
                CCSprite *bar = [CCSprite spriteWithFile:@"p2Health.png"];
                [bar setPosition:ccp(start_pos.x - (i*24),start_pos.y)];
                [self addChild:bar];
                [bars addObject:bar];                
            }   
        }
        reload_circle = [CCSprite spriteWithFile:@"reload_circle.png"];
        if (p_num == 1) {
            [reload_circle setPosition:ccp(71+(24*9),457)];
            [score setPosition:ccp(72,456)];
            [score setAnchorPoint:ccp(1,0.5)];
        }else if(p_num == 2){
            [reload_circle setPosition:ccp(640-71-(24*9), 457)];
            [reload_circle setFlipX:YES];
            [score setPosition:ccp(640-72,456)];
            [score setAnchorPoint:ccp(0,0.5)];
        }
        [self addChild:reload_circle];
        [self addChild:score];
        player = p_num;
    } 
    
    return self;
}

-(void)updateHUD {
    int health_left, current_score;
    if (player == 1) {
        health_left = [GameGlobal sharedGlobals].p1_health;
        current_score       = [GameGlobal sharedGlobals].p1_score;
    }else if(player == 2) {
        health_left = [GameGlobal sharedGlobals].p2_health;
        current_score       = [GameGlobal sharedGlobals].p2_score;
    }
    
    int i;
    for (i=0; i<[bars count]; i++) {
        if (health_left >= i) {
            if ([(CCSprite*)[bars objectAtIndex:i] scale]==0.1) {
                continue;
            }
            id grow = [CCScaleTo actionWithDuration:0.2 scale:1];
            id appear   = [CCFadeTo   actionWithDuration:0.2 opacity:255];
            
            [[bars objectAtIndex:i] runAction:grow];
            [[bars objectAtIndex:i] runAction:appear];
        }else{
            id shrink = [CCScaleTo actionWithDuration:0.2 scale:0.1];
            id fade   = [CCFadeTo   actionWithDuration:0.2 opacity:0];
            
            [[bars objectAtIndex:i] runAction:shrink];
            [[bars objectAtIndex:i] runAction:fade];
        }
    }
    
    [score setString:[NSString stringWithFormat:@"%i",current_score]];
    
}

- (void)dealloc {
    [super dealloc];
}

@end
