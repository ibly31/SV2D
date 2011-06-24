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

#define MAXPUPS 3

typedef struct Pup{
    int type;
    float life;
    
    BOOL active;
}Pup;

enum {
    PUP_STRAWBERRY = 0,
    PUP_APPLE,
    PUP_ORANGE,
    PUP_BANANA,
    PUP_GRAPES
};

@interface Player : CCNode{
    CCSprite *feetSprite;
    CCSprite *playerSprite;
    cpShape *playerShape;
    
    SpaceManagerCocos2d *smgr;
    
    int currentWeapon;
    Weapon *weapon;
    CCSprite *muzzleFlash;
    
    CCSprite *laser;
    
    CCParticleFire *flameThrower;

    int health;
    float speed;
    
    Pup pups[MAXPUPS];
        
    float currentRecoil;
    
    BOOL shooting;
    BOOL reloading;
    
    BOOL unlimitedAmmo;
    
    int numberOfZombiesTouchingPlayer;
}

@property (nonatomic, retain) CCSprite *feetSprite;
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
- (void)scheduleToReload;
- (void)reload;

- (void)switchWeapons;

- (BOOL)handleCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
- (void)processZombieHits;

- (void)lowerRecoil;

- (void)updateHealth;
- (void)updateAmmo;

- (void)takeDamage:(int)damage;

- (void)usePup:(int)ptype withPosition:(CGPoint)pos withOpacity:(int)opa;
- (void)undoPup:(int)index;

- (void)update:(ccTime)dt;

- (void)syncPosition;
- (void)setVelocity:(CGPoint)vel;
- (void)setRotation:(float)rot;

@end
