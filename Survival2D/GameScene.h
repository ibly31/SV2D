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

@interface GameScene : CCScene{
    Player *player;
    CCSprite *leftAnalogStick;
    CCSprite *rightAnalogStick;
    CCLayerColor *backgroundColor;
    CCLayerColor *secondBackgroundColor;
    
    InputLayer *inputLayer;
    ZombieBatch *zombieBatch;
    CCLayerColor *damageIndicator;
    
    CCLabelAtlas *ammoLabel;
    CCLabelAtlas *healthLabel;
    CCSprite *reloadingSprite;
    
    CCSpriteBatchNode *casings;
    int currentCasingNumber;
    
    CCSpriteBatchNode *bloodSplatters;
    BulletBatch *bulletBatch;
    
    SpaceManagerCocos2d *smgr;
}

@property (nonatomic, retain) Player *player;
@property (nonatomic, retain) InputLayer *inputLayer;
@property (nonatomic, retain) ZombieBatch *zombieBatch;
@property (nonatomic, retain) BulletBatch *bulletBatch;

@property (nonatomic, retain) CCLayerColor *backgroundColor;
@property (nonatomic, retain) CCLayerColor *secondBackgroundColor;

@property (nonatomic, retain) CCSprite *leftAnalogStick;
@property (nonatomic, retain) CCSprite *rightAnalogStick;

@property (nonatomic, retain) CCLayerColor *damageIndicator;

@property (nonatomic, retain) CCLabelAtlas *ammoLabel;
@property (nonatomic, retain) CCLabelAtlas *healthLabel;
@property (nonatomic, retain) CCSprite *reloadingSprite;

@property (nonatomic, retain) CCSpriteBatchNode *casings;
@property (nonatomic, retain) CCSpriteBatchNode *bloodSplatters;

@property (nonatomic, retain) SpaceManagerCocos2d *smgr;

- (void)updateCameraToCenterOn:(CGPoint)centerOn;
- (void)addNewBulletCasingsAt:(CGPoint)startPos endPos:(CGPoint)endPos startRot:(float)startRot;

- (void)addNewBloodSplatterAt:(CGPoint)position withRotation:(float)rotation withDistance:(float)distance;
- (void)removeBloodSplatter;

- (void)flashDamageIndicator:(int)health;

@end
