//
//  GameHUD.h
//  Ultra Troopers
//
//  Created by Timothy Cool on 9/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameGlobal.h"

@interface GameHUD : CCLayer {
    NSMutableArray  *bars;
    CCSprite        *reload_circle;
    CCLabelBMFont   *score;
    int             player;
}

-(id)initWithPlayer:(int)p_num;
-(void)updateHUD;

@end
