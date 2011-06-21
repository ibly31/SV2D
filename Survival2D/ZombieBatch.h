//
//  ZombieBatch.h
//  Survival2D
//
//  Created by Billy Connolly on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "SpaceManagerCocos2d.h"

#define MAXZOMBIES 100

typedef struct Zombie{
    CGPoint position;
    float rotation;
    
    int health;
    float speed;
    CCSprite *zombieSprite;
    
    cpShape *zombieShape;
    BOOL alive;
    
    int zombieType;
}Zombie;

@interface ZombieBatch : CCSpriteBatchNode {
    Zombie zombies[MAXZOMBIES];
    
    CCTexture2D *zombieTexture;
    SpaceManagerCocos2d *smgr;
    
    BOOL frozen;
    
    CGPoint playerPosition;
}

@property (nonatomic, retain) CCTexture2D *zombieTexture;
@property (nonatomic, retain) SpaceManagerCocos2d *smgr;

float distance(CGPoint point1,CGPoint point2);

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)spacemgr;

- (int)numberZombiesAlive;

- (void)freezeZombies;
- (void)unfreezeZombies;

- (void)addNewZombieAt:(CGPoint)newZomb;
- (void)updateZombies;

- (int)nextOpenZombieSlot;
- (void)destroyZombie:(int)index;

- (void)flamePath:(CGPoint)start withRotation:(float)rotation withVariance:(float)variance withDamage:(int)damage;
- (void)explosionAt:(CGPoint)start withRadius:(float)radius withDamage:(int)damage;

- (void)zombieSetPosition:(CGPoint)pos index:(int)index;
- (void)zombieSetRotation:(float)rot index:(int)index;
- (void)zombieTakeDamage:(int)damage index:(int)index;

- (void)setPlayerPosition:(CGPoint)pp;

- (int)whichZombie:(cpShape *)zombieShape;

@end