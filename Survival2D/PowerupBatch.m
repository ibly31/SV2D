//
//  PowerupBatch.m
//  Survival2D
//
//  Created by Billy Connolly on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PowerupBatch.h"
#import "GameScene.h"

@implementation PowerupBatch
@synthesize smgr;
@synthesize player;

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)smanager withPlayer:(Player *)ply{
    self = [super initWithFile:@"Foodsheet.png" capacity:MAXPOWERUPS];
    if(self){
        self.smgr = smanager;
        self.player = ply;
        [smgr addCollisionCallbackBetweenType:4 otherType:-1 target:self selector:@selector(ignoreCollision:arbiter:space:) moments:COLLISION_BEGIN, nil];
        //[smgr addCollisionCallbackBetweenType:4 otherType:0 target:self selector:@selector(ignoreCollision:arbiter:space:) moments:COLLISION_BEGIN, nil];
        [smgr addCollisionCallbackBetweenType:4 otherType:1 target:self selector:@selector(playerCollision:arbiter:space:) moments:COLLISION_BEGIN, nil];
        [smgr addCollisionCallbackBetweenType:4 otherType:2 target:self selector:@selector(ignoreCollision:arbiter:space:) moments:COLLISION_BEGIN, nil];
        [smgr addCollisionCallbackBetweenType:4 otherType:3 target:self selector:@selector(ignoreCollision:arbiter:space:) moments:COLLISION_BEGIN, nil];
        
        for(int x = 0; x < MAXPOWERUPS; x++){
            powerups[x].taken = NO;
            powerups[x].type = 0;
            powerups[x].life = 0.0f;
            powerups[x].lifeOrigin = 0.0f;
            CCSprite *powerupSprite = [[CCSprite alloc] initWithFile:@"Foodsheet.png" rect:CGRectMake(0, 0, 32, 32)];
            powerups[x].powerupSprite = powerupSprite;
            [powerups[x].powerupSprite setOpacity: 0];
            [self addChild: powerupSprite];
            [powerupSprite release];
        }
        [self scheduleUpdate];
    }
    return self;
}

- (void)update:(ccTime)dt{
    for(int x = 0; x < MAXPOWERUPS; x++){
        if(powerups[x].taken){
            powerups[x].life -= dt;
            [powerups[x].powerupSprite setOpacity: (powerups[x].life / powerups[x].lifeOrigin) * 255];
            
            if(powerups[x].life < 0){
                [self destroyPowerup: x];
            }
        }
    }
}

- (void)destroyPowerup:(int)index{
    [powerups[index].powerupSprite stopAllActions];
    [powerups[index].powerupSprite setOpacity: 0];
    [powerups[index].powerupSprite setScaleY: 1.0f];
    [smgr removeAndFreeShape: powerups[index].powerupShape];
    powerups[index].powerupShape = NULL;
    powerups[index].taken = NO;
}

- (BOOL)playerCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space{
    cpShape *a, *b;
    cpArbiterGetShapes(arb, &a, &b);
        
    for(int x = 0; x < MAXPOWERUPS; x++){
        if(powerups[x].powerupShape == a){
            [player usePup: powerups[x].type - 7 withPosition:powerups[x].powerupShape->body->p withOpacity:[powerups[x].powerupSprite opacity]];
            [self destroyPowerup: x];
            return NO;
        }
    }
    
    return NO;
}

- (BOOL)ignoreCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space{
    return NO;
}

- (int)nextOpenPowerupSlot{
    for(int x = 0; x < MAXPOWERUPS; x++){
        if(powerups[x].taken == NO){
            return x;
        }
    }
    return -1;
}

- (void)addNewPowerupAt:(CGPoint)pos{
    int index = [self nextOpenPowerupSlot];
    if(index != -1){
        powerups[index].taken = YES;
        powerups[index].type = (int)(CCRANDOM_0_1() * 6) + 7;
        powerups[index].life = 25.0f;
        powerups[index].lifeOrigin = powerups[index].life;
        powerups[index].powerupShape = [smgr addCircleAt:pos mass:STATIC_MASS radius:16.0f];
        powerups[index].powerupShape->collision_type = 4;
        [powerups[index].powerupSprite setDisplayFrame: [CCSpriteFrame frameWithTexture:self.texture rect:CGRectMake(powerups[index].type * 32, 0, 32, 32)]];
        [powerups[index].powerupSprite setPosition: pos];
        [powerups[index].powerupSprite setOpacity: 255];
        [powerups[index].powerupSprite runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCScaleTo actionWithDuration: 1.0f scale: 1.2f], [CCScaleTo actionWithDuration: 1.0f scale: 1.0f], nil]]];
    }
}

@end
