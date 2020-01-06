//
//  HiveMind.h
//  Ultra Troopers
//
//  Created by Timothy Cool on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "LinkedList.h"
#import "AStarNode.h"

enum mapObjects{
    kMAP_NIL,
    kMAP_WALL,
    kMAP_SPAWN
};
enum path_finding {
    kOPEN_PATH,
    kCLOSED_PATH
};

@class Player;
@interface HiveMind : NSObject {
@private
    int     map[50][50];
    int     mapHeight;
    int     mapWidth;
    int     tileSize;
    
    Player  *p1_ref;
    Player  *p2_ref;
    
    int         least_cost;
    AStarNode   *chosen_node;
    
    NSMutableArray *openList;
    NSMutableArray *closedList;
    
    int      total_enemies;
    bool     enemies_cleared;
}

@property(readwrite, assign)Player *p1_ref;
@property(readwrite, assign)Player *p2_ref;
@property(nonatomic, retain)NSMutableArray *openList;
@property(nonatomic, retain)NSMutableArray *closedList;
@property(readwrite)int     total_enemies;
@property(readwrite)bool    enemies_cleared;

-(void)addEnemy;
-(void)removeEnemy;

-(void)setup:(int)map_height:(int)map_width:(int)tile_size;
-(void)setMapObject:(int)mapObject:(CGPoint)point;

-(bool)shouldTry:(CGPoint)myPoint;
-(NSMutableArray *)solutionForPointsPath:(CGPoint)start:(CGPoint)goal;
-(CGPoint)closestPlayer:(CGPoint)myPoint;

-(void)debugMap;

@end
