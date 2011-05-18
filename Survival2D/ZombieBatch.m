//
//  ZombieBatch.m
//  Survival2D
//
//  Created by Billy Connolly on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZombieBatch.h"
#import "chipmunk.h"

@implementation ZombieBatch
@synthesize zombieTexture;
@synthesize smgr;

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)spacemgr{
    self.zombieTexture = [[CCTextureCache sharedTextureCache] addImage: @"PlayerSheet.png"];
    self = [super initWithTexture:zombieTexture capacity:MAXZOMBIES];
    if(self){
        
        self.smgr = spacemgr;
        
        currentZombie = 0;
        playerPosition = ccp(240.0f, 160.0f);
        
        [self schedule:@selector(updateZombies) interval:1.0f/60.0f];
    }
    return self;
}

- (void)updateZombies{
    for(int x = 0; x < currentZombie; x++){
        
        cpShape *zombieShape = zombies[x].zombieShape;
        cpBody *shapeBody = zombieShape->body;
        
        CGPoint zombiePosition = CGPointMake(shapeBody->p.x, shapeBody->p.y);
        float angleTowardsPlayer = atan2f(zombiePosition.y - playerPosition.y, playerPosition.x - zombiePosition.x);
        CGPoint force = CGPointMake(zombies[x].speed * cosf(angleTowardsPlayer), -zombies[x].speed * sinf(angleTowardsPlayer));
        
        //cpBodyResetForces(shapeBody);
        //cpBodyApplyForce(shapeBody, cpv(force.x, force.y), cpv(0.0f, 0.0f));
        shapeBody->v = cpv(force.x, force.y);
        
        [self zombieSetPosition:zombiePosition index:x];
        [self zombieSetRotation:90.0f + CC_RADIANS_TO_DEGREES(angleTowardsPlayer) index:x];
    }
}

/*typedef struct cpSegmentQueryInfo {
 struct cpShape *shape; // shape that was hit, NULL if no collision
 cpFloat t; // Distance along query segment, will always be in the range [0, 1].
 cpVect n; // normal of hit surface
 } cpSegmentQueryInfo;*/

float distance(CGPoint point1,CGPoint point2){
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy);
};

- (void)detectHitsWithShot:(CGPoint)start end:(CGPoint)end{
/*    int collisionIndices[20];
    int collisionIndex = 0;
    for(int x = 0; x < currentZombie; x++){
        cpSegmentQueryInfo info;
        cpShapeSegmentQuery(zombies[x].zombieShape, cpv(start.x, start.y), cpv(end.x, end.y), &info);
        if(info.shape != NULL){
            collisionIndices[collisionIndex] = x;
            collisionIndex++;
        }
    }
    
    if(collisionIndex > 0){
        cpShape *farthestShapeAway;
        float lastFarthest = 0;
        
        for(int x = 0; x < collisionIndex; x++){
            float dist = distance(start, zombies[collisionIndices[x]].position);
            if(dist > lastFarthest){
                lastFarthest = dist;
                farthestShapeAway = zombies[collisionIndices[x]].zombieShape;
            }
        }
        
        
    }*/
}

- (void)addNewZombieAt:(CGPoint)newZomb{
    CCSprite *zombieSprite = [[CCSprite alloc] initWithTexture:zombieTexture rect:CGRectMake(0.0f, 0.0f, 64.0f, 64.0f)];
    
    Zombie newZombie;
    newZombie.health = 100;
    newZombie.speed = 15.0f;
    newZombie.zombieSprite = zombieSprite;
    newZombie.zombieShape = [smgr addCircleAt:newZomb mass:1.0f radius:16.0f];
    zombies[currentZombie] = newZombie;
    
    [self zombieSetPosition:newZomb index:currentZombie];
    [self zombieSetRotation:0.0f index:currentZombie];
    [self addChild: zombieSprite];
    [zombieSprite release];
    currentZombie++;
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

- (void)setPlayerPosition:(CGPoint)pp{
    playerPosition = pp;
}

@end