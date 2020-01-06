//
//  AStarNode.h
//  Ultra Troopers
//
//  Created by Timothy Cool on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "chipmunk.h"


@interface AStarNode : NSObject {
    int         x_value;
    int         y_value;
    //should always display the "manhattan" distance from goal
    int         heuristic;
    //grid_cost should be square relative to STARTING! position
    int         grid_cost;
    int         movement_cost;
    //H + G = Find Cost
    int         find_cost;
    cpVect      direction;
}

@property(readwrite, assign)int x_value;
@property(readwrite, assign)int y_value;
@property(readwrite, assign)int heuristic;
@property(readwrite, assign)int movement_cost;
@property(readwrite, assign)int grid_cost;
@property(readwrite, assign)int find_cost;
@property(readwrite, assign)cpVect direction;

-(id)initWithX:(int)_x andY:(int)_y;
//remember that positions are in terms of tiles not pixels
-(void)calculatePosition:(CGPoint)current_pos:(CGPoint)destination:(int)total_cost; 
//-(bool)compareNodes:(AStarNode *)otherNode;
-(NSString *)identity;

@end
