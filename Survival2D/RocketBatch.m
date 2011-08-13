//
//  RocketBatch.m
//  Survival2D
//
//  Created by Billy Connolly on 5/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RocketBatch.h"
#import "ZombieBatch.h"
#import "GameScene.h"

@implementation RocketBatch
@synthesize smgr;
@synthesize rocketTrails;

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)smanager trailBatch:(CCSpriteBatchNode *)trailBatch{
    self = [super initWithFile:@"Rocket.png" capacity:MAXROCKETS];
    if(self){
        self.smgr = smanager;           //  ZOMBIE      ROCKET
        [smgr addCollisionCallbackBetweenType:0 otherType:3 target:self selector:@selector(rocketCollision:arbiter:space:) moments:COLLISION_BEGIN, nil];
        [smgr addCollisionCallbackBetweenType:-1 otherType:3 target:self selector:@selector(wallCollision:arbiter:space:) moments:COLLISION_BEGIN, nil];
        [smgr addCollisionCallbackBetweenType:1 otherType:3 target:self selector:@selector(ignoreCollision:arbiter:space:)];
        [smgr addCollisionCallbackBetweenType:2 otherType:3 target:self selector:@selector(ignoreCollision:arbiter:space:)];
        [smgr addCollisionCallbackBetweenType:3 otherType:3 target:self selector:@selector(ignoreCollision:arbiter:space:)];
        
        rocketTrails = trailBatch;
                
        for(int x = 0; x < MAXROCKETS; x++){
            rockets[x].taken = NO;
            rockets[x].rocketShape = NULL;
            rockets[x].speed = 0.0f;
            CCSprite *rocketSprite = [[CCSprite alloc] initWithFile:@"Rocket.png"];
            [rocketSprite setOpacity: 0];
            [rocketSprite setAnchorPoint: ccp(0.5f, 1.0f)];
            rockets[x].rocketSprite = rocketSprite;
            [self addChild: rocketSprite];
            [rocketSprite release];
            
            CCSprite *rocketTrail = [[CCSprite alloc] initWithFile: @"RocketTrail.png"];
            [rocketTrail setOpacity: 0];
            [rocketTrail setAnchorPoint: ccp(0.5f, 1.0f)];
            rockets[x].rocketTrail = rocketTrail;
            [rocketTrails addChild: rocketTrail];
            [rocketTrail release];
        }
        [self schedule: @selector(updateRockets) interval: 1.0f / 60.0f];
    }
    return self;
}

- (void)updateRockets{
    for(int x = 0; x < MAXROCKETS; x++){
        if(rockets[x].taken){
            cpBodyActivate(rockets[x].rocketShape->body);
            
            rockets[x].speed += 0.05f;
            rockets[x].rocketShape->body->v = ccp(rockets[x].speed * 500.0f * cosf(rockets[x].rocketShape->body->a), rockets[x].speed * 500.0f * sinf(rockets[x].rocketShape->body->a));
            
            CGPoint pos = rockets[x].rocketShape->body->p;
            [rockets[x].rocketSprite setPosition: pos];
            [rockets[x].rocketTrail setPosition: pos];
            
            float rot = rockets[x].rocketShape->body->a;
            [rockets[x].rocketSprite setRotation: 90.0f - CC_RADIANS_TO_DEGREES(rot)];
            [rockets[x].rocketTrail setRotation: 90.0f - CC_RADIANS_TO_DEGREES(rot)];
            
            float distanceTravelled = distance(pos, rockets[x].origin);
            [rockets[x].rocketTrail setScaleY: distanceTravelled];
        }
    }
}

- (int)nextOpenRocketSlot{
    for(int x = 0; x < MAXROCKETS; x++){
        if(rockets[x].taken == NO){
            return x;
        }
    }
    return 0;
}

- (void)destroyRocket:(int)index{
    
    [[(GameScene *)parent_ zombieBatch] explosionAt: rockets[index].rocketShape->body->p withRadius:150.0f withDamage:rockets[index].damage];
    
    [rockets[index].rocketTrail stopAllActions];
    [rockets[index].rocketTrail setOpacity: 0];
    [rockets[index].rocketTrail setScaleY: 1.0f];
    [rockets[index].rocketSprite stopAllActions];
    [rockets[index].rocketSprite setOpacity: 0];
    [rockets[index].rocketSprite setScaleY: 1.0f];
    [smgr removeAndFreeShape: rockets[index].rocketShape];
    rockets[index].rocketShape = NULL;
    rockets[index].taken = NO;
}

- (BOOL)wallCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space{
    cpShape *a, *b;
    cpArbiterGetShapes(arb, &a, &b);
    
    for(int x = 0; x < MAXROCKETS; x++){
        if(rockets[x].rocketShape == b){
            [self destroyRocket: x];
            return NO;
        }
    }
    
    return NO;
}

- (BOOL)ignoreCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space{
    return NO;
}

- (void)fireRocketFrom:(CGPoint)start withRotation:(float)rotation withDamage:(int)damage{
    int x = [self nextOpenRocketSlot];
    rockets[x].damage = damage;
    rockets[x].speed = 0.05f;
    rockets[x].rocketShape = [smgr addRectAt:start mass:3.0f width:3 height:16 rotation:CC_DEGREES_TO_RADIANS(90.0f - rotation)];
    rockets[x].rocketShape->collision_type = 3;
    rockets[x].origin = start;
    [rockets[x].rocketTrail setOpacity: 255];
    [rockets[x].rocketSprite runAction: [CCFadeTo actionWithDuration: 0.075f opacity: 255]];
    [rockets[x].rocketTrail runAction: [CCFadeTo actionWithDuration: 1.5f opacity: 0]];
    rockets[x].taken = YES;
    
    float rotInRads = CC_DEGREES_TO_RADIANS(90.0f - rotation);
    rockets[x].rocketShape->body->v = ccp(500.0f * cosf(rotInRads), 500.0f * sinf(rotInRads));
    
    [self updateRockets];
}

- (BOOL)rocketCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space{
    
    cpShape *a, *b = NULL;
    cpArbiterGetShapes(arb, &a, &b);
    
    int whichRocket = -1;
    int rocketDamage = 0;
    for(int x = 0; x < MAXROCKETS; x++){
        if(rockets[x].rocketShape == b){
            whichRocket = x;
        }
    }
        
    if(whichRocket == -1){
        NSLog(@"NO ROCKET CONNECTION");return NO;
    }else{
        rocketDamage = rockets[whichRocket].damage;
    }
    
    int whichZombie = [(NSNumber *)a->data intValue];
    if(whichZombie != -1){
        [[(GameScene *)parent_ zombieBatch] zombieTakeDamage:100 index:whichZombie];
    }else{
        NSLog(@" ");
    }
    
    [[(GameScene *)parent_ zombieBatch] explosionAt:cpArbiterGetPoint(arb, 0) withRadius:100 withDamage:rocketDamage];
    [self destroyRocket: whichRocket];
    
    return NO;
}

@end
