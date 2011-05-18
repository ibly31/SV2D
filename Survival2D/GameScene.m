//
//  GameScene.m
//  Survival2D
//
//  Created by Billy Connolly on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"

#define CASINGOVERWRITE 1000

@implementation GameScene
@synthesize player;
@synthesize inputLayer;
@synthesize zombieBatch;

@synthesize backgroundColor;

@synthesize leftAnalogStick;
@synthesize rightAnalogStick;

@synthesize ammoLabel;
@synthesize healthLabel;
@synthesize reloadingSprite;

@synthesize casings;

@synthesize smgr;

-(id)init{
    self = [super init];
	if(self){
        
        self.smgr = [[SpaceManagerCocos2d alloc] init];
        [smgr addWindowContainmentWithFriction:0.8f elasticity:0.2f size:CGSizeMake(480.0f, 320.0f) inset:cpvzero radius: 1];
        [smgr setGravity: cpv(0.0f, 0.0f)];
        [smgr start: 1.0f/60.0f];
        
        self.backgroundColor = [[CCLayerColor alloc] initWithColor: ccc4(100, 100, 100, 255)];
        [self addChild: backgroundColor];
        
        self.casings = [[CCSpriteBatchNode alloc] initWithFile:@"Shell.png" capacity: CASINGOVERWRITE];
        [self addChild: casings];
        
        self.zombieBatch = [[ZombieBatch alloc] initWithSpaceManager: smgr];
        [self addChild: zombieBatch];
        
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
            self.healthLabel = [[[CCLabelAtlas alloc] initWithString:@"100" charMapFile:@"Font.png" itemWidth:16 itemHeight:24 startCharMap:','] retain];
        }else{
            self.healthLabel = [[[CCLabelAtlas alloc] initWithString:@"100" charMapFile:@"Font-hd.png" itemWidth:32 itemHeight:48 startCharMap:','] retain];
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
        
        /// Input Layer LAST !!! ///
        self.inputLayer = [[InputLayer alloc] init];
        [self addChild: inputLayer];
        
        [zombieBatch addNewZombieAt: ccp(CCRANDOM_0_1() * 480.0f, CCRANDOM_0_1() * 320.0f)];
        [zombieBatch addNewZombieAt: ccp(CCRANDOM_0_1() * 480.0f, CCRANDOM_0_1() * 320.0f)];
        [zombieBatch addNewZombieAt: ccp(CCRANDOM_0_1() * 480.0f, CCRANDOM_0_1() * 320.0f)];
        [zombieBatch addNewZombieAt: ccp(CCRANDOM_0_1() * 480.0f, CCRANDOM_0_1() * 320.0f)];
        [zombieBatch addNewZombieAt: ccp(CCRANDOM_0_1() * 480.0f, CCRANDOM_0_1() * 320.0f)];
        [zombieBatch addNewZombieAt: ccp(CCRANDOM_0_1() * 480.0f, CCRANDOM_0_1() * 320.0f)];
        [zombieBatch addNewZombieAt: ccp(CCRANDOM_0_1() * 480.0f, CCRANDOM_0_1() * 320.0f)];
        [zombieBatch addNewZombieAt: ccp(CCRANDOM_0_1() * 480.0f, CCRANDOM_0_1() * 320.0f)];
        [zombieBatch addNewZombieAt: ccp(CCRANDOM_0_1() * 480.0f, CCRANDOM_0_1() * 320.0f)];
        
        
    }
	return self;
}

- (void)updateCameraToCenterOn:(CGPoint)centerOn{
    [self.camera setCenterX:centerOn.x - 240.0f centerY:centerOn.y - 160.0f centerZ:0];
    [self.camera setEyeX:centerOn.x - 240.0f eyeY:centerOn.y - 160.0f eyeZ:1.0f];
    
    [ammoLabel setPosition: ccpSub(centerOn, ccp(240.0f, -160.0f))];
    [healthLabel setPosition: ccpSub(centerOn, ccp(-240.0f, -160.0f))];
    [reloadingSprite setPosition: ccpSub(centerOn, ccp(240.0f, -160.0f))];
    [rightAnalogStick setPosition: ccpAdd(centerOn, ccp(166.0f, -86.0f))];
    [leftAnalogStick setPosition: ccpAdd(centerOn, ccp(-166.0f, -86.f))];
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

- (void)dealloc{
	
	[super dealloc];
}
@end
