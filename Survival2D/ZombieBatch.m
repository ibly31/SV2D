//
//  ZombieBatch.m
//  Survival2D
//
//  Created by Billy Connolly on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZombieBatch.h"
#import "chipmunk.h"
#import "GameScene.h"
#import "BulletBatch.h"

@implementation ZombieBatch
@synthesize zombieTexture;
@synthesize smgr;

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)spacemgr{
    self.zombieTexture = [[CCTextureCache sharedTextureCache] addImage: @"Foodsheet.png"];
    self = [super initWithTexture:zombieTexture capacity:MAXZOMBIES];
    if(self){
        self.smgr = spacemgr;
        for(int x = 0; x < MAXZOMBIES; x++){
            CCSprite *zombieSprite = [[CCSprite alloc] initWithTexture:zombieTexture];
            [zombieSprite setOpacity: 0];
            
            Zombie newZombie;
            newZombie.health = 0;
            newZombie.alive = NO;
            newZombie.speed = 0.0f;
            newZombie.zombieSprite = zombieSprite;
            newZombie.zombieShape = NULL;
            newZombie.zombieType = 0;
            zombies[x] = newZombie;
            
            [zombieSprite setDisplayFrame: [CCSpriteFrame frameWithTexture:zombieTexture rect:CGRectMake(0, 0, 32, 32)]];
        }
        
        frozen = NO;
        
        playerPosition = ccp(512.0f, 512.0f);
        [self schedule:@selector(updateZombies) interval:1.0f/60.0f];
    }
    return self;
}

- (void)flamePath:(CGPoint)start withRotation:(float)rotation withVariance:(float)variance withDamage:(int)damage{
    rotation = CC_DEGREES_TO_RADIANS(rotation);
    variance = CC_DEGREES_TO_RADIANS(variance);
    
    for(int x = 0; x < MAXZOMBIES; x++){
        if(zombies[x].alive){
            CGPoint zombiePos = zombies[x].position;
            float angleToStart = atan2f(zombiePos.x - start.x, zombiePos.y - start.y);
            if(angleToStart < 0)
                angleToStart += 2.0f * M_PI;
            
            if(angleToStart > (rotation - variance) && angleToStart < (rotation + variance)){
                float distanceToZombie = distance(start, zombiePos);
                if(distanceToZombie < 200)
                    [self zombieTakeDamage:damage index: x];
            }
        }
    }
}

- (void)freezeZombies{
    frozen = YES;
}
- (void)unfreezeZombies{
    frozen = NO;
}

- (void)explosionAt:(CGPoint)start withRadius:(float)radius withDamage:(int)damage{
    for(int x = 0; x < MAXZOMBIES; x++){
        if(zombies[x].alive == YES){
            float dist = distance(start, zombies[x].position);
            if(dist < radius){
                [self zombieTakeDamage: ((radius - dist) / radius) * damage index:x];
            }
        }
    }
    
    int numberOfShrapnels = (int)(CCRANDOM_0_1() * 10);
    float initialAngle = (CCRANDOM_0_1() * (360.0f / (float)numberOfShrapnels));
    
    for(int x = 0; x < numberOfShrapnels; x++){
        [[(GameScene *)parent_ bulletBatch] fireBulletFrom:start withRotation:initialAngle + (x * (360.0f / numberOfShrapnels)) withDamage:damage / numberOfShrapnels withPenetration:1];
    }
    
    [(GameScene *)parent_ startExplosionAt: start];
}

- (int)nextOpenZombieSlot{
    for(int x = 0; x < MAXZOMBIES; x++){
        if(zombies[x].alive == NO){
            return x;
        }
    }
    return 0;
}

- (int)numberZombiesAlive{
    int number = 0;
    for(int x = 0; x < MAXZOMBIES; x++){
        if(zombies[x].alive){
            number++;
        }
    }
    return number;
}

- (void)destroyZombie:(int)index{
    [zombies[index].zombieSprite stopAllActions];
    [zombies[index].zombieSprite setOpacity: 0];
    [smgr removeAndFreeShape: zombies[index].zombieShape];
    zombies[index].zombieShape = NULL;
    zombies[index].alive = NO;
    [self removeChild:zombies[index].zombieSprite cleanup:NO];
}

- (void)updateZombies{
    for(int x = 0; x < MAXZOMBIES; x++){
        if(zombies[x].alive){
            cpShape *zombieShape = zombies[x].zombieShape;
            cpBody *shapeBody = zombieShape->body;
            
            CGPoint zombiePosition = CGPointMake(shapeBody->p.x, shapeBody->p.y);
            float angleTowardsPlayer = atan2f(zombiePosition.y - playerPosition.y, playerPosition.x - zombiePosition.x);
            CGPoint force = CGPointMake(zombies[x].speed * cosf(angleTowardsPlayer), -zombies[x].speed * sinf(angleTowardsPlayer));
            
            if(!frozen){
                shapeBody->v = cpv(force.x, force.y);
            }else{
                shapeBody->v = cpv(0,0);
            }
            
            [self zombieSetPosition:zombiePosition index:x];
            [self zombieSetRotation:0 index:x];
            
            cpBodyActivate(shapeBody);
            
        }
    }
}

- (void)addNewZombieAt:(CGPoint)newZomb{
    int numberAlive = [self numberZombiesAlive];
    if(numberAlive < MAXZOMBIES){
        printf("\nNumber of Zombies Alive: %i", numberAlive);
        
        if(numberAlive <= MAXZOMBIES){
            int x = [self nextOpenZombieSlot];
            [self addChild: zombies[x].zombieSprite];
            zombies[x].health = 100;
            zombies[x].alive = YES;
            zombies[x].speed = 45.0f;
            zombies[x].zombieType = (int)(CCRANDOM_0_1() * 7);
            zombies[x].zombieShape = [smgr addCircleAt:newZomb mass:1.0f radius:16.0f];
            zombies[x].zombieShape->collision_type = 0;
            [zombies[x].zombieSprite setOpacity: 255];
            [zombies[x].zombieSprite setDisplayFrame: [CCSpriteFrame frameWithTexture:self.zombieTexture rect:CGRectMake(zombies[x].zombieType * 32, 0, 32, 32)]];
            
            [self zombieSetPosition:newZomb index:x];
            [self zombieSetRotation:0.0f index:x];
        }
    }
}

- (int)whichZombie:(cpShape *)zombieShape{
    int whichZombie = -1;
    for(int x = 0; x < MAXZOMBIES; x++){
        if(zombies[x].zombieShape == zombieShape){
            whichZombie = x;
        }
    }
    
    if(whichZombie == -1){
        NSLog(@"NO ZOMBIE CONNECTION.");return -1;
    }else{
        return whichZombie;
    }
}

- (void)zombieSetPosition:(CGPoint)pos index:(int)index{
    CCSprite *zombieSprite = zombies[index].zombieSprite;
    zombies[index].position = pos;
    [zombieSprite setPosition: pos];
}

- (void)zombieSetRotation:(float)rot index:(int)index{
    CCSprite *zombieSprite = zombies[index].zombieSprite;
    zombies[index].rotation = rot;
    [zombieSprite setRotation: rot];
}

- (void)zombieTakeDamage:(int)damage index:(int)index{
    float rot = (CCRANDOM_0_1() * (2 * M_PI));
    CGPoint splatPos = CGPointMake(zombies[index].position.x + 8 * cosf(rot), zombies[index].position.y + 8 * sinf(rot));
    ccColor3B color;
    if(zombies[index].zombieType == 0){
        color = ccc3(136, 70, 20);
    }else if(zombies[index].zombieType == 1){
        color = ccORANGE;
    }else if(zombies[index].zombieType == 2){
        color = ccYELLOW;
    }else if(zombies[index].zombieType == 3){
        color = ccRED;
    }else if(zombies[index].zombieType == 4){
        color = ccBLUE;
    }else if(zombies[index].zombieType == 5){
        color = ccRED;
    }else if(zombies[index].zombieType == 6){
        color = ccWHITE;
    }
    
    [(GameScene *)parent_ addNewBloodSplatterAt:splatPos withRotation: 90.0f - CC_RADIANS_TO_DEGREES(rot) withColor:color];
    
    zombies[index].health -= damage;
    if(zombies[index].health <= 0){
        [self destroyZombie: index];
        [self addNewZombieAt: ccp(CCRANDOM_0_1() * 1024, CCRANDOM_0_1() * 1024)];
        [self addNewZombieAt: ccp(CCRANDOM_0_1() * 1024, CCRANDOM_0_1() * 1024)];
        [self addNewZombieAt: ccp(CCRANDOM_0_1() * 1024, CCRANDOM_0_1() * 1024)];
    }
}

- (void)setPlayerPosition:(CGPoint)pp{
    playerPosition = pp;
}

/* cpSegmentQueryInfo info;
 cpShape *firstHitShape = cpSpaceSegmentQueryFirst([smgr space], start, end, CP_ALL_LAYERS, CP_NO_GROUP, &info);
 
 if(firstHitShape != NULL){
 cpVect hitPoint = cpSegmentQueryHitPoint(start, end, info);
 float otherRotation = atan2f(start.y - end.y, start.x - end.x);
 
 if(firstHitShape->collision_type == -1){        // Hit Wall
 
 }else if(firstHitShape->collision_type == 0){   // Hit Zombie
 int whichZombie = -1;
 for(int x = 0; x < currentZombie; x++){
 if(zombies[x].zombieShape == firstHitShape){
 whichZombie = x;
 }
 }
 
 if(whichZombie == -1){
 NSLog(@"NO ZOMBIE CONNECTION.");return;
 }else{
 [self zombieTakeDamage:damage index:whichZombie];
 //cpBodyApplyImpulse(zombies[whichZombie].zombieShape->body, cpv(200.0f * cosf(M_PI + otherRotation), 200.0f * sinf(M_PI + otherRotation)), cpv(0,0));
 }
 
 CGFloat dx = hitPoint.x - start.x;
 CGFloat dy = hitPoint.y - start.y;
 
 float distancePlusABit = sqrt(dx*dx + dy*dy) + 16.0f;
 CGPoint splatterPos = ccpAdd(start, ccp(distancePlusABit * cosf(M_PI + otherRotation), distancePlusABit * sinf(M_PI + otherRotation)));
 
 CGPoint zombiePoint = zombies[whichZombie].zombieShape->body->p;
 float splatterRot = 90.0f - CC_RADIANS_TO_DEGREES(atan2f(splatterPos.y - zombiePoint.y, splatterPos.x - zombiePoint.x));
 
 [(GameScene *)parent_ addNewBloodSplatterAt: splatterPos withRotation:splatterRot withDistance:distancePlusABit];
 }
 
 
 CGFloat dx = hitPoint.x - start.x;
 CGFloat dy = hitPoint.y - start.y;
 
 float distanceMinusABit = sqrt(dx*dx + dy*dy) - 48.0f;
 CGPoint toPosition = ccpAdd(start, ccp(distanceMinusABit * cosf(M_PI + otherRotation), distanceMinusABit * sinf(M_PI + otherRotation)));
 
 [(GameScene *)parent_ addNewBulletPathAt:start toPosition:toPosition];
 }else{
 NSLog(@"Doesn't make any sense, not hitting any shapes.");return;
 }
 */

@end