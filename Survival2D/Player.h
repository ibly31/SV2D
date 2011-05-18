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
        
    int health;
    int armor;
    float speed;
    
    BOOL shooting;
    BOOL reloading;
}

@property (nonatomic, retain) CCSprite *playerSprite;
@property (nonatomic, retain) Weapon *weapon;
@property (nonatomic, retain) CCSprite *muzzleFlash;
@property (nonatomic, retain) SpaceManagerCocos2d *smgr;

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)spacemgr;

- (void)startShooting;
- (void)shoot;
- (void)stopShooting;
- (void)reload;

- (void)updateHealth;
- (void)updateAmmo;

- (void)takeDamage:(int)damage;

- (void)syncPosition;
- (void)setVelocity:(CGPoint)vel;
- (void)setRotation:(float)rot;

@end
