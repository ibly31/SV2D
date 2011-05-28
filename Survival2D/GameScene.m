//
//  GameScene.m
//  Survival2D
//
//  Created by Billy Connolly on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

#define CASINGOVERWRITE 1000
#define BULLETSPEED 1000.0f

@implementation GameScene
@synthesize player;
@synthesize inputLayer;
@synthesize zombieBatch;
@synthesize bulletBatch;
@synthesize rocketBatch;

@synthesize backgroundColor;
@synthesize secondBackgroundColor;

@synthesize leftAnalogStick;
@synthesize rightAnalogStick;

@synthesize damageIndicator;

@synthesize ammoLabel;
@synthesize healthLabel;
@synthesize reloadingSprite;

@synthesize casings;
@synthesize bloodSplatters;

@synthesize smgr;

-(id)init{
    self = [super init];
	if(self){
        
        self.smgr = [[SpaceManagerCocos2d alloc] init];
        [smgr addWindowContainmentWithFriction:0.8f elasticity:0.2f size:CGSizeMake(1024.0f, 1024.0f) inset:cpvzero radius: 1];
        [smgr setGravity: cpv(0.0f, 0.0f)];
        [smgr start: 1.0f/60.0f];
        
        self.secondBackgroundColor = [[CCLayerColor alloc] initWithColor: ccc4(50, 50, 50, 255) width: 1344 height: 1344];
        [secondBackgroundColor setPosition: ccp(-240.0f, -160.0f)];
        [self addChild: secondBackgroundColor];
        
        self.backgroundColor = [[CCLayerColor alloc] initWithColor: ccc4(100, 100, 100, 255) width:1024 height:1024];
        [self addChild: backgroundColor];
        
        self.casings = [[CCSpriteBatchNode alloc] initWithFile:@"Shell.png" capacity: CASINGOVERWRITE];
        [self addChild: casings];
        
        self.bulletBatch = [[BulletBatch alloc] initWithSpaceManager: smgr];
        [self addChild: bulletBatch];
        
        self.rocketBatch = [[RocketBatch alloc] initWithSpaceManager: smgr];
        [self addChild: rocketBatch];
        
        self.zombieBatch = [[ZombieBatch alloc] initWithSpaceManager: smgr];
        [self addChild: zombieBatch];
                
        self.bloodSplatters = [[CCSpriteBatchNode alloc] initWithFile:@"Bloodsplatter.png" capacity: 100];
        [self addChild: bloodSplatters];
        
		self.player = [[Player alloc] initWithSpaceManager:smgr];
        [self addChild: player];
        
        self.leftAnalogStick = [[CCSprite alloc] initWithFile: @"Analog.png"];
        [leftAnalogStick setPosition: ccp(74.0f, 74.0f)];
        [self addChild: leftAnalogStick];
        
        self.rightAnalogStick = [[CCSprite alloc] initWithFile: @"Analog.png"];
        [rightAnalogStick setPosition: ccp(404.0f, 74.0f)];
        [self addChild: rightAnalogStick];
        
        self.ammoLabel = [[[CCLabelAtlas alloc] initWithString:@"0/0" charMapFile:@"Font.png" itemWidth:16 itemHeight:24 startCharMap:','] retain];
        [ammoLabel setAnchorPoint: ccp(0.0f, 1.0f)];
        [ammoLabel setPosition: ccp(0.0f, 320.0f)];
        [self addChild: ammoLabel];
        [player updateAmmo];
        
        if([[CCDirector sharedDirector] contentScaleFactor] > 1){
            self.healthLabel = [[[CCLabelAtlas alloc] initWithString:@"-100" charMapFile:@"Font.png" itemWidth:16 itemHeight:24 startCharMap:','] retain];
        }else{
            self.healthLabel = [[[CCLabelAtlas alloc] initWithString:@"-100" charMapFile:@"Font-hd.png" itemWidth:32 itemHeight:48 startCharMap:','] retain];
            [healthLabel setScale:0.5f];
        }
        
        [healthLabel setAnchorPoint: ccp(1.0f, 1.0f)];
        [healthLabel setPosition: ccp(480.0f, 360.0f)];
        [self addChild: healthLabel];
        [player updateHealth];
        
        self.reloadingSprite = [[CCSprite alloc] initWithFile: @"Reloading.png"];
        [reloadingSprite setAnchorPoint: ccp(0.0f, 1.0f)];
        [reloadingSprite setPosition: ccp(0.0f, 320.0f)];
        [reloadingSprite setOpacity: 0];
        [self addChild: reloadingSprite];
        
        self.damageIndicator = [[CCLayerColor alloc] initWithColor: ccc4(155, 0, 0, 50)];
        [damageIndicator setOpacity: 0];
        [damageIndicator setAnchorPoint: ccp(0.5f, 0.5f)];
        [self addChild: damageIndicator];
        
        self.inputLayer = [[InputLayer alloc] init];
        [self addChild: inputLayer];
        
        [zombieBatch addNewZombieAt: ccp(560, 560)];
    }
	return self;
}

- (void)updateCameraToCenterOn:(CGPoint)centerOn{
    [self.camera setCenterX:centerOn.x - 240.0f centerY:centerOn.y - 160.0f centerZ:0];
    [self.camera setEyeX:centerOn.x - 240.0f eyeY:centerOn.y - 160.0f eyeZ:1.0f];
    
    [ammoLabel setPosition: ccpAdd(centerOn, ccp(-240.0f, 160.0f))];
    [healthLabel setPosition: ccpAdd(centerOn, ccp(240.0f, 160.0f))];
    [reloadingSprite setPosition: ccpAdd(centerOn, ccp(-240.0f, 160.0f))];
    [rightAnalogStick setPosition: ccpAdd(centerOn, ccp(166.0f, -86.0f))];
    [leftAnalogStick setPosition: ccpAdd(centerOn, ccp(-166.0f, -86.f))];
    [damageIndicator setPosition: ccpAdd(centerOn, ccp(-240.0f, -160.0f))];
}

- (void)addNewBulletCasingsAt:(CGPoint)startPos endPos:(CGPoint)endPos startRot:(float)startRot{
    endPos = ccp(endPos.x + (CCRANDOM_0_1() * 10.0f) - 5.0f, endPos.y + (CCRANDOM_0_1() * 10.0f) - 5.0f);
    float endRot = startRot + (CCRANDOM_0_1() * 360.0f);
    if(currentCasingNumber < CASINGOVERWRITE){
        CCSprite *newCasing = [[CCSprite alloc] initWithFile: @"Shell.png"];
        [newCasing setPosition: startPos];
        [newCasing setRotation: startRot];
        [newCasing runAction: [CCMoveTo actionWithDuration:0.15f position:endPos]];
        [newCasing runAction: [CCRotateTo actionWithDuration:0.15f angle:endRot]];
        [casings addChild: newCasing];
        [newCasing release];
        currentCasingNumber++;
    }else{
        int caseIndex = currentCasingNumber % CASINGOVERWRITE;
        CCSprite *caseToChange = [[casings children] objectAtIndex: caseIndex];
        [caseToChange setPosition: startPos];
        [caseToChange setRotation: startRot];
        [caseToChange runAction: [CCMoveTo actionWithDuration:0.15f position:endPos]];
        [caseToChange runAction: [CCRotateTo actionWithDuration:0.15f angle:endRot]];
        currentCasingNumber++;
    }
}

float distance(CGPoint point1,CGPoint point2){
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrt(dx*dx + dy*dy);
};

- (void)addNewBloodSplatterAt:(CGPoint)position withRotation:(float)rotation withDistance:(float)distance{ 
    CCSprite *newSplatter = [[CCSprite alloc] initWithFile: @"Bloodsplatter.png"];
    [newSplatter setPosition: position];
    [newSplatter setAnchorPoint: ccp(0.5f, 0.0f)];
    [newSplatter setRotation: rotation];
    [newSplatter runAction: [CCSequence actions:[CCFadeTo actionWithDuration:distance / BULLETSPEED opacity:100], [CCFadeTo actionWithDuration:0 opacity:0], [CCCallFunc actionWithTarget:self selector:@selector(removeBloodSplatter)], nil]];
    [bloodSplatters addChild: newSplatter];
    [newSplatter release];
}

- (void)removeBloodSplatter{
    [bloodSplatters removeChildAtIndex:0 cleanup:YES];
}

- (void)flashDamageIndicator:(int)health{
    CCFadeTo *fadeTo = [CCFadeTo actionWithDuration:0.1f opacity:255];
    CCFadeTo *fadeFrom = [CCFadeTo actionWithDuration:0.1f opacity:0];
    [damageIndicator runAction: [CCSequence actions:fadeTo, fadeFrom, nil]];
}

- (void)dealloc{
	
	[super dealloc];
}

/*CGPoint midPoint = ccp((position.x + position2.x) / 2, (position.y + position2.y) / 2);
 [newBullet setPosition: midPoint];
 [newBullet setRotation: rotation];
 [newBullet setScaleY: (distance(position, position2) / 2)];
 [newBullet runAction: [CCSequence actions:[CCFadeTo actionWithDuration:0.1f opacity:0], [CCCallFunc actionWithTarget:self selector:@selector(removeBulletPath)], nil]];
 [bulletPaths addChild: newBullet];
 [newBullet release];*/

@end
