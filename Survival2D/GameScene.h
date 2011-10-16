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
#import "PowerupBatch.h"
#import "PowerupHUD.h"

enum FOODTYPES{
    DONUT=0,
    PIZZA,
    FRIES,
    BURGER,
    BPIE,
    RPIE,
    CAKE
};

@interface GameScene : CCScene{
    Player *player;
    CCSprite *leftAnalogStick;
    CCSprite *rightAnalogStick;
    CCSprite *backgroundMap;
    PowerupHUD *powerupHUD;
    
    InputLayer *inputLayer;
    ZombieBatch *zombieBatch;
    PowerupBatch *powerupBatch;
    CCLayerColor *damageIndicator;
    
    CCSpriteBatchNode *guiBatch;
    CCLabelAtlas *ammoLabel;
    CCLabelAtlas *healthLabel;
    CCSprite *reloadingSprite;
    CCSprite *switchWeaponButton;
    CCSprite *pauseButton;
    
    CCSprite *waveIndicator;
    CCLabelAtlas *waveNumber;
    
    CCSpriteBatchNode *casings;
    int currentCasingNumber;
    
    CCSpriteBatchNode *rocketTrails;
    
    CCSpriteBatchNode *bloodSplatters;
    BulletBatch *bulletBatch;
    RocketBatch *rocketBatch;
    
    CCParticleExplosion *explosionToRemove;
    
    SpaceManagerCocos2d *smgr;
    
    BOOL gameModeWave;
    
    float timeRunning;
    int currentWave;
        
    int toSpawns[7];
}
@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) InputLayer *inputLayer;
@property (nonatomic, retain) ZombieBatch *zombieBatch;
@property (nonatomic, retain) PowerupBatch *powerupBatch;
@property (nonatomic, retain) BulletBatch *bulletBatch;
@property (nonatomic, retain) RocketBatch *rocketBatch;

@property (nonatomic, retain) CCSprite *backgroundMap;

@property (nonatomic, retain) CCSprite *leftAnalogStick;
@property (nonatomic, retain) CCSprite *rightAnalogStick;

@property (nonatomic, retain) PowerupHUD *powerupHUD;

@property (nonatomic, retain) CCLayerColor *damageIndicator;

@property (nonatomic, retain) CCSpriteBatchNode *guiBatch;
@property (nonatomic, retain) CCLabelAtlas *ammoLabel;
@property (nonatomic, retain) CCLabelAtlas *healthLabel;
@property (nonatomic, retain) CCSprite *reloadingSprite;
@property (nonatomic, retain) CCSprite *switchWeaponButton;
@property (nonatomic, retain) CCSprite *pauseButton;

@property (nonatomic, retain) CCSprite *waveIndicator;
@property (nonatomic, retain) CCLabelAtlas *waveNumber;

@property (nonatomic, retain) CCSpriteBatchNode *casings;
@property (nonatomic, retain) CCSpriteBatchNode *bloodSplatters;
@property (nonatomic, retain) CCSpriteBatchNode *rocketTrails;

@property (nonatomic, retain) CCParticleExplosion *explosionToRemove;

@property (nonatomic, retain) SpaceManagerCocos2d *smgr;

@property BOOL gameModeWave;

- (id)initWithGameModeWave:(BOOL)gmw;

- (void)startNewWave;
- (void)spawnLoop;

- (void)spawnZombieEndless;

- (void)updateCameraToCenterOn:(CGPoint)centerOn;
- (void)addNewBulletCasingsAt:(CGPoint)startPos endPos:(CGPoint)endPos startRot:(float)startRot;

- (void)addNewBloodSplatterAt:(CGPoint)position withRotation:(float)rotation withColor:(ccColor3B)color;
- (void)removeBloodSplatter;

- (void)startExplosionAt:(CGPoint)start;
- (void)endExplosion;

- (void)flashDamageIndicator:(int)health;

@end
