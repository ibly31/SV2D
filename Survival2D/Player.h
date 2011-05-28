//
//  Player.h
//  Survival2D
//
//  Created by Billy Connolly on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "SpaceManagerCocos2d.h"
#import "Weapon.h"
#import "ZombieBatch.h"

@interface Player : CCNode{
    CCSprite *playerSprite;
    cpShape *playerShape;
    
    SpaceManagerCocos2d *smgr;
    
    Weapon *weapon;
    CCSprite *muzzleFlash;
    
    CCSprite *laser;
    
    CCParticleFire *flameThrower;

    int health;
    int armor;
    float speed;
        
    float currentRecoil;
    
    BOOL shooting;
    BOOL reloading;
    
    int numberOfZombiesTouchingPlayer;
}

@property (nonatomic, retain) CCSprite *playerSprite;
@property (nonatomic, retain) Weapon *weapon;
@property (nonatomic, retain) CCSprite *muzzleFlash;
@property (nonatomic, retain) CCSprite *laser;
@property (nonatomic, retain) SpaceManagerCocos2d *smgr;

@property (nonatomic, retain) CCParticleFire *flameThrower;

@property BOOL shooting;

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)spacemgr;

- (void)laserSetOn:(BOOL)onoff;

- (void)startShooting;
- (void)shoot;
- (void)stopShooting;
- (void)reload;

- (BOOL)handleCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (void)processZombieHits;

- (void)lowerRecoil;

- (void)updateHealth;
- (void)updateAmmo;

- (void)takeDamage:(int)damage;

- (void)syncPosition;
- (void)setVelocity:(CGPoint)vel;
- (void)setRotation:(float)rot;

@end
