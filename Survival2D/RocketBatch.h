//
//  RocketBatch.h
//  Survival2D
//
//  Created by Billy Connolly on 5/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "SpaceManagerCocos2d.h"

#define MAXROCKETS 10

typedef struct Rocket{
    CCSprite *rocketSprite;
    CCSprite *rocketTrail;
    cpShape *rocketShape;
    int damage;
    float speed;
    CGPoint origin;
    
    BOOL taken;
}Rocket;

@interface RocketBatch : CCSpriteBatchNode {
    SpaceManagerCocos2d *smgr;
    
    Rocket rockets[MAXROCKETS];
    
    CCSpriteBatchNode *rocketTrails;
}

@property (nonatomic, retain) SpaceManagerCocos2d *smgr;
@property (nonatomic, retain) CCSpriteBatchNode *rocketTrails;

float distance(CGPoint point1,CGPoint point2);

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)smanager trailBatch:(CCSpriteBatchNode *)trailBatch;

- (void)fireRocketFrom:(CGPoint)start withRotation:(float)rotation withDamage:(int)damage;
- (BOOL)rocketCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (BOOL)ignoreCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (BOOL)wallCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;

- (void)destroyRocket:(int)index;

- (void)updateRockets;

- (int)nextOpenRocketSlot;

@end