//
//  PlayerController.h
//  Ultra Troopers
//
//  Created by Timothy Cool on 7/8/11.
//  Copyright 2011 Electrobud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Xbox360ControllerManager.h"

struct keys {
    int up_key;
    int down_key;
    int right_key;
    int left_key;
    int primary_key;
};

@interface PlayerController : NSObject {
    bool    up;
    bool    down;
    bool    left;
    bool    right;
    bool    primary;
    
    Xbox360Controller   *xbox;
    struct keys         keyboard;
    
    int     last_up;
    int     last_down;
    int     last_left;
    int     last_right;

}

@property(readwrite, assign)bool up;
@property(readwrite, assign)bool down;
@property(readwrite, assign)bool left;
@property(readwrite, assign)bool right;
@property(readwrite, assign)bool primary;
@property(readwrite, assign)int last_up;
@property(readwrite, assign)int last_down;
@property(readwrite, assign)int last_left;
@property(readwrite, assign)int last_right;

-(void)updateXboxController;

@end
