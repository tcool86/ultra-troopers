//
//  HiveMind.m
//  Ultra Troopers
//
//  Created by Timothy Cool on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HiveMind.h"


@implementation HiveMind

@synthesize p1_ref, p2_ref;
@synthesize total_enemies, enemies_cleared;
@synthesize openList,closedList;

-(void)addEnemy{
    total_enemies++;
}
-(void)removeEnemy{
    total_enemies--;
    if (total_enemies <= 0) {
        enemies_cleared = YES;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

//Lol at no error checks!!!
-(void)setup:(int)map_height:(int)map_width:(int)tile_size{
    mapHeight   = map_height;
    mapWidth    = map_width;
    tileSize    = tile_size;
    
    openList =[[NSMutableArray alloc] init];
    closedList =[[NSMutableArray alloc] init];
}

-(void)setMapObject:(int)mapObject:(CGPoint)point{
    int actualX = point.x/tileSize;
    int actualY = point.y/tileSize;
    
    map[actualX][actualY] = mapObject;
    
}

-(float)distance:(CGPoint)point1:(CGPoint)point2{
    return ccpDistance(point1, point2);
}

-(CGPoint)closestPlayer:(CGPoint)myPoint {
    float dist_p1 = [self distance:p1_ref.position :myPoint];
    float dist_p2 = [self distance:p2_ref.position :myPoint];
    //NSLog(@"\nP1 Distance: %f \nP2 Distance: %f",dist_p1, dist_p2);
    if (p1_ref != nil) {
        if (dist_p1 < dist_p2) {
            return p1_ref.position;
        }else{
            return p2_ref.position;
        }
    }else{
        return p2_ref.position;
    }
    if (p2_ref != nil){
        if (dist_p2 < dist_p1) {
            return p2_ref.position;
        }else{
            return p1_ref.position;
        }
    }else{
        return p1_ref.position;
    }
    
    //By default target p1
    return p1_ref.position;
}

#define SIGHT 704
-(bool)shouldTry:(CGPoint)myPoint {
    float dist_p1 = [self distance:p1_ref.position :myPoint];
    float dist_p2 = [self distance:p2_ref.position :myPoint];
    
    if (dist_p1 < SIGHT || dist_p2 < SIGHT) {
        return YES;
    }
        
    return NO;
}


-(void)findCostForDirection:(int)dx:(int)dy:(int)current_x:(int)current_y:(int)goal_x:(int)goal_y:(CGPoint)start {
    //if there is a node (square) in the closed list, it cannot be put into the openlist for choosing
    int total_heuristics = 0;
    AStarNode *node = [[AStarNode alloc] initWithX:dx andY:dy];
    cpVect direction = cpv(dx-current_x, dy-current_y);
    [node setDirection:direction];

    for (AStarNode *closed_node in closedList) {
        if ([[closed_node identity] isEqualToString:[node identity]] ) {
            //this node is closed
            return;
        }
    }
    
    if ( (dx >= 0 && dx <= mapWidth) && (dy >= 0 && dy <= mapHeight) ) {
        if (map[dx][dy] == kMAP_WALL) {
            //Wall in the way
            return;
        }else{
            [node calculatePosition:ccp(current_x,current_y) :ccp(goal_x, goal_y) :total_heuristics];
            [openList addObject:node];
        }
    }else{
        //Out of bounds
        return;
    }
}

-(NSMutableArray *)solutionForPointsPath:(CGPoint)start:(CGPoint)goal {
    
    //Get starting Square
    int x_tile  = start.x/tileSize
        ,y_tile = start.y/tileSize;
    int fx_tile  = goal.x/tileSize
        ,fy_tile = goal.y/tileSize;
    
    CGPoint starting_point = ccp(x_tile,y_tile);
    AStarNode *start_node = [[AStarNode alloc] initWithX:x_tile andY:y_tile];
    //Begin at starting point, with key 0 and add it to the closed list.
    [closedList addObject:start_node];
    
    //pathing vars
    int next_x, next_y;
    //adjacent squares
    do {
        [openList removeAllObjects];
        
        //Right Side
        next_x = x_tile + 1;
        [self findCostForDirection:next_x :y_tile :x_tile :y_tile :fx_tile :fy_tile :starting_point];
        
        //Left Side
        next_x = x_tile - 1;
        [self findCostForDirection:next_x :y_tile :x_tile :y_tile :fx_tile :fy_tile :starting_point];
        
        //Above
        next_y = y_tile - 1;
        [self findCostForDirection:x_tile :next_y :x_tile :y_tile :fx_tile :fy_tile :starting_point];
        
        //Below
        next_y = y_tile + 1;
        [self findCostForDirection:x_tile :next_y :x_tile :y_tile :fx_tile :fy_tile :starting_point];
        
        //Above Right
        next_x = x_tile + 1;
        next_y = y_tile - 1;
        [self findCostForDirection:next_x :next_y :x_tile :y_tile :fx_tile :fy_tile :starting_point];
        
        //Above Left
        next_x = x_tile - 1;
        next_y = y_tile - 1;
        [self findCostForDirection:next_x :next_y :x_tile :y_tile :fx_tile :fy_tile :starting_point];

        //Below Right
        next_x = x_tile + 1;
        next_y = y_tile + 1;
        [self findCostForDirection:next_x :next_y :x_tile :y_tile :fx_tile :fy_tile :starting_point];
        
        //Below Left
        next_x = x_tile - 1;
        next_y = y_tile + 1;
        [self findCostForDirection:next_x :next_y :x_tile :y_tile :fx_tile :fy_tile :starting_point];
        
        //chose lowest scoring square from open list
        //add that to closed list
        least_cost = 1000;
        chosen_node = nil;
        for (AStarNode *node in openList) {
            if (least_cost > [node find_cost]) {
                chosen_node = node;
            }
        }
        [closedList addObject:chosen_node];

    }while (x_tile != fx_tile && y_tile != fy_tile);
    
    //find quickest route
    return closedList;
}

- (void)debugMap {
    int i, j;
    NSString *map_string = [NSString stringWithString:@"\n"];
    
    NSLog(@"\n");
    for (i=0; i<mapHeight; i++) {
        for (j=0; j<mapWidth; j++) {
            if (map[j][i]==kMAP_WALL) {
                NSString *temp = [NSString stringWithFormat:@"%@[%i,%i]%@",map_string,j,i,@"="];
                map_string = temp;
            }else{
                NSString *temp = [NSString stringWithFormat:@"%@[%i,%i]%@",map_string,j,i,@"0"];
                map_string = temp;
            }

        }
        NSString *temp = [NSString stringWithFormat:@"%@%@",map_string,@"\n"];
        map_string = temp;
    }
    
    NSLog(@"%@",map_string);
    
}

- (void)dealloc
{
    [super dealloc];
}

@end
