//
//  PowerupBatch.h
//  Survival2D
//
//  Created by Billy Connolly on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "SpaceManagerCocos2d.h"
#import "Player.h"

#define MAXPOWERUPS 30

typedef struct Powerup{
    CCSprite *powerupSprite;
    cpShape *powerupShape;
    
    float life;
    float lifeOrigin;
    
    int type;
    BOOL taken;
}Powerup;

@interface PowerupBatch : CCSpriteBatchNode {
    SpaceManagerCocos2d *smgr;
    Powerup powerups[MAXPOWERUPS];
    
    Player *player;
}

@property (nonatomic, retain) SpaceManagerCocos2d *smgr;
@property (nonatomic, retain) Player *player;

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)smanager withPlayer:(Player *)ply;

- (void)update:(ccTime)dt;

- (void)destroyPowerup:(int)index;

- (int)nextOpenPowerupSlot;
- (void)addNewPowerupAt:(CGPoint)pos;

- (BOOL)ignoreCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (BOOL)playerCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;

@end
