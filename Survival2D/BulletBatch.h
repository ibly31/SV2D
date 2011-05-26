//
//  BulletBatch.h
//  Survival2D
//
//  Created by Billy Connolly on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "SpaceManagerCocos2d.h"

#define MAXBULLETS 1000

typedef struct Bullet{
    CCSprite *bulletSprite;
    cpShape *bulletShape;
    int damage;
    int penetration;
    
    BOOL taken;
    
}Bullet;

@interface BulletBatch : CCSpriteBatchNode {
    SpaceManagerCocos2d *smgr;
    
    Bullet bullets[MAXBULLETS];
}

@property (nonatomic, retain) SpaceManagerCocos2d *smgr;

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)smanager;

- (void)fireBulletFrom:(CGPoint)start withRotation:(float)rotation withDamage:(int)damage withPenetration:(int)penetration;
- (BOOL)bulletCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (BOOL)ignoreCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (BOOL)wallCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;

- (void)destroyBullet:(int)index;

- (void)updateBullets;

- (int)nextOpenBulletSlot;

@end
