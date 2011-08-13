//
//  BulletBatch.m
//  Survival2D
//
//  Created by Billy Connolly on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BulletBatch.h"
#import "ZombieBatch.h"
#import "GameScene.h"

#define BULLETSPEED 500

@implementation BulletBatch
@synthesize smgr;

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)smanager{
    self = [super initWithFile:@"Bullet.png" capacity:MAXBULLETS];
    if(self){
        self.smgr = smanager;           //  ZOMBIE      BULLET
        [smgr addCollisionCallbackBetweenType:0 otherType:2 target:self selector:@selector(bulletCollision:arbiter:space:) moments:COLLISION_BEGIN, nil];
        [smgr addCollisionCallbackBetweenType:-1 otherType:2 target:self selector:@selector(wallCollision:arbiter:space:) moments:COLLISION_BEGIN, nil];
        [smgr addCollisionCallbackBetweenType:1 otherType:2 target:self selector:@selector(ignoreCollision:arbiter:space:)];
        [smgr addCollisionCallbackBetweenType:2 otherType:2 target:self selector:@selector(ignoreCollision:arbiter:space:)];
        
        for(int x = 0; x < MAXBULLETS; x++){
            bullets[x].taken = NO;
            bullets[x].damage = 0;
            bullets[x].penetration = 0;
            bullets[x].bulletShape = NULL;
            CCSprite *bulletSprite = [[CCSprite alloc] initWithFile:@"Bullet.png"];
            [bulletSprite setOpacity: 0];
            [bulletSprite setAnchorPoint: ccp(0.5f, 1.0f)];
            bullets[x].bulletSprite = bulletSprite;
            [self addChild: bulletSprite];
            [bulletSprite release];
        }
        
        [self schedule: @selector(updateBullets) interval: 1.0f / 60.0f];
    }
    return self;
}

- (void)updateBullets{
    for(int x = 0; x < MAXBULLETS; x++){
        if(bullets[x].taken){
            
            cpBodyActivate(bullets[x].bulletShape->body);
            
            CGPoint pos = bullets[x].bulletShape->body->p;
            [bullets[x].bulletSprite setPosition: pos];
            
            float rot = bullets[x].bulletShape->body->a;
            [bullets[x].bulletSprite setRotation: 90.0f - CC_RADIANS_TO_DEGREES(rot)];
        }
    }
}

- (int)nextOpenBulletSlot{
    for(int x = 0; x < MAXBULLETS; x++){
        if(bullets[x].taken == NO){
            return x;
        }
    }
    return 0;
}

- (void)destroyBullet:(int)index{
    [bullets[index].bulletSprite stopAllActions];
    [bullets[index].bulletSprite setOpacity: 0];
    [bullets[index].bulletSprite setScaleY: 1.0f];
    [smgr removeAndFreeShape: bullets[index].bulletShape];
    bullets[index].bulletShape = NULL;
    bullets[index].taken = NO;
}

- (BOOL)wallCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space{
    cpShape *a, *b;
    cpArbiterGetShapes(arb, &a, &b);
    
    for(int x = 0; x < MAXBULLETS; x++){
        if(bullets[x].bulletShape == b){
            [self destroyBullet: x];
            return NO;
        }
    }
    
    return NO;
}

- (BOOL)ignoreCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space{
    return NO;
}

- (void)fireBulletFrom:(CGPoint)start withRotation:(float)rotation withDamage:(int)damage withPenetration:(int)penetration{
    
    int x = [self nextOpenBulletSlot];
    bullets[x].damage = damage;
    bullets[x].penetration = penetration;
    bullets[x].bulletShape = [smgr addRectAt:start mass:3.0f width:2 height:16 rotation:CC_DEGREES_TO_RADIANS(90.0f - rotation)];
    bullets[x].bulletShape->collision_type = 2;
    [bullets[x].bulletSprite runAction: [CCFadeTo actionWithDuration: 0.075f opacity: 255]];
    [bullets[x].bulletSprite runAction: [CCScaleTo actionWithDuration: 1.0f scaleX: 1.0f scaleY: 16.0f]];
    bullets[x].taken = YES;
    
    float rotInRads = CC_DEGREES_TO_RADIANS(90.0f - rotation);
    bullets[x].bulletShape->body->v = ccp(BULLETSPEED * cosf(rotInRads), BULLETSPEED * sinf(rotInRads));

    [self updateBullets];
}

- (BOOL)bulletCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space{

    cpShape *a, *b = NULL;
    cpArbiterGetShapes(arb, &a, &b);
    
    int whichBullet = -1;
    int bulletDamage = 0;
    for(int x = 0; x < MAXBULLETS; x++){
        if(bullets[x].bulletShape == b){
            whichBullet = x;
        }
    }
    
    if(whichBullet == -1){
        NSLog(@"NO BULLET CONNECTION");return NO;
    }else{
        bulletDamage = bullets[whichBullet].damage;
    }
    
    if(a->data != nil){
        int whichZombie = [(NSNumber *)a->data intValue];
        if(whichZombie != -1){
            [[(GameScene *)parent_ zombieBatch] zombieTakeDamage:bulletDamage index:whichZombie];
        }else{
            NSLog(@"NO ZOMBIE CONNECTION in BULLETCOLLISION");
        }
        
        if(bullets[whichBullet].penetration != -1){
            bullets[whichBullet].penetration--;
            bullets[whichBullet].damage /= 2;
            if(bullets[whichBullet].penetration == 0){
                [self destroyBullet: whichBullet];
            }
        }
    }
    return NO;
}

@end
