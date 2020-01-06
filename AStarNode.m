//
//  AStarNode.m
//  Ultra Troopers
//
//  Created by Timothy Cool on 10/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AStarNode.h"


@implementation AStarNode

@synthesize x_value,y_value;
@synthesize heuristic,grid_cost,movement_cost,find_cost;
@synthesize direction;

- (id)initWithX:(int)_x andY:(int)_y {
    self = [super init];
    if (self) {
        self.x_value = _x;
        self.y_value = _y;
        // Initialization code here.
    }
    
    return self;
}

-(void)calculatePosition:(CGPoint)current_pos:(CGPoint)destination:(int)total_cost {
    //Gives Grid Cost, Lowest Cost, and Heuristic (Guess Amount)
    int delta_x, delta_y;
    
    delta_x = abs(current_pos.x - x_value);
    delta_y = abs(current_pos.y - y_value);
    
    if ( (delta_x + delta_y) == 1 ) {
        movement_cost = 10;}
    else{//Diagonal
        movement_cost = 14;}

    grid_cost = grid_cost + movement_cost;
    delta_x     = abs(destination.x - x_value);
    delta_y     = abs(destination.y - y_value);
    heuristic   = (delta_x + delta_y)*10; //the manhattan value
    
    find_cost = heuristic + grid_cost; //total path finding cost
}

//-(bool)compareNodes:(AStarNode *)otherNode {
//    if (otherNode.x_value == x_value && otherNode.y_value == y_value) {
//        return YES;
//    }
//    return NO;
//}


-(NSString*)identity {
    //Create a unique id
    return [NSString stringWithFormat:@"%iU%i",x_value,y_value];
    
}

- (void)dealloc
{
    [super dealloc];
}

@end
