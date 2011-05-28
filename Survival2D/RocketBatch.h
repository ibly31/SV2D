//
//  RocketBatch.h
//  Survival2D
//
//  Created by Billy Connolly on 5/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "SpaceManagerCocos2d.h"

#define MAXROCKETS 30

typedef struct Rocket{
    CCSprite *rocketSprite;
    cpShape *rocketShape;
    int damage;
    float speed;
    
    BOOL taken;
    
}Rocket;

@interface RocketBatch : CCSpriteBatchNode {
    SpaceManagerCocos2d *smgr;
    
    Rocket rockets[MAXROCKETS];
}

@property (nonatomic, retain) SpaceManagerCocos2d *smgr;

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)smanager;

- (void)fireRocketFrom:(CGPoint)start withRotation:(float)rotation withDamage:(int)damage;
- (BOOL)rocketCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (BOOL)ignoreCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (BOOL)wallCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;

- (void)destroyRocket:(int)index;

- (void)updateRockets;

- (int)nextOpenRocketSlot;

@end