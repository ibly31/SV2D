//
//  GameScene.h
//  Survival2D
//
//  Created by Billy Connolly on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Player.h"
#import "InputLayer.h"
#import "SpaceManagerCocos2d.h"
#import "ZombieBatch.h"
#import "BulletBatch.h"
#import "RocketBatch.h"

@interface GameScene : CCScene{
    Player *player;
    CCSprite *leftAnalogStick;
    CCSprite *rightAnalogStick;
    CCSprite *backgroundMap;
    
    InputLayer *inputLayer;
    ZombieBatch *zombieBatch;
    CCLayerColor *damageIndicator;
    
    CCLabelAtlas *ammoLabel;
    CCLabelAtlas *healthLabel;
    CCSprite *reloadingSprite;
    CCSprite *reloadButton;
    CCSprite *switchWeaponButton;
    
    CCSpriteBatchNode *casings;
    int currentCasingNumber;
    
    CCSpriteBatchNode *rocketTrails;
    
    CCSpriteBatchNode *bloodSplatters;
    BulletBatch *bulletBatch;
    RocketBatch *rocketBatch;
    
    CCParticleExplosion *explosionToRemove;
    
    SpaceManagerCocos2d *smgr;
}

@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) InputLayer *inputLayer;
@property (nonatomic, retain) ZombieBatch *zombieBatch;
@property (nonatomic, retain) BulletBatch *bulletBatch;
@property (nonatomic, retain) RocketBatch *rocketBatch;

@property (nonatomic, retain) CCSprite *backgroundMap;

@property (nonatomic, retain) CCSprite *leftAnalogStick;
@property (nonatomic, retain) CCSprite *rightAnalogStick;

@property (nonatomic, retain) CCLayerColor *damageIndicator;

@property (nonatomic, retain) CCLabelAtlas *ammoLabel;
@property (nonatomic, retain) CCLabelAtlas *healthLabel;
@property (nonatomic, retain) CCSprite *reloadingSprite;
@property (nonatomic, retain) CCSprite *reloadButton;
@property (nonatomic, retain) CCSprite *switchWeaponButton;

@property (nonatomic, retain) CCSpriteBatchNode *casings;
@property (nonatomic, retain) CCSpriteBatchNode *bloodSplatters;
@property (nonatomic, retain) CCSpriteBatchNode *rocketTrails;

@property (nonatomic, retain) CCParticleExplosion *explosionToRemove;

@property (nonatomic, retain) SpaceManagerCocos2d *smgr;

- (void)updateCameraToCenterOn:(CGPoint)centerOn;
- (void)addNewBulletCasingsAt:(CGPoint)startPos endPos:(CGPoint)endPos startRot:(float)startRot;

- (void)addNewBloodSplatterAt:(CGPoint)position withRotation:(float)rotation;
- (void)removeBloodSplatter;

- (void)startExplosionAt:(CGPoint)start;
- (void)endExplosion;

- (void)flashDamageIndicator:(int)health;

@end
