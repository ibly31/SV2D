//
//  ZombieBatch.h
//  Survival2D
//
//  Created by Billy Connolly on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "SpaceManagerCocos2d.h"

#define MAXZOMBIES 3000

typedef struct Zombie{
    CGPoint position;
    float rotation;
    
    int health;
    float speed;
    CCSprite *zombieSprite;
    
    cpShape *zombieShape;
}Zombie;

@interface ZombieBatch : CCSpriteBatchNode {
    Zombie zombies[MAXZOMBIES];
    int currentZombie;
    
    CCTexture2D *zombieTexture;
    SpaceManagerCocos2d *smgr;
    
    CGPoint playerPosition;
}

@property (nonatomic, retain) CCTexture2D *zombieTexture;
@property (nonatomic, retain) SpaceManagerCocos2d *smgr;

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)spacemgr;

- (void)addNewZombieAt:(CGPoint)newZomb;
- (void)updateZombies;

- (void)zombieSetPosition:(CGPoint)pos index:(int)index;
- (void)zombieSetRotation:(float)rot index:(int)index;

- (void)detectHitsWithShot:(CGPoint)start end:(CGPoint)end;

- (void)setPlayerPosition:(CGPoint)pp;

@end