//
//  GameScene.m
//  Survival2D
//
//  Created by Billy Connolly on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"

#define CASINGOVERWRITE 1000

@implementation GameScene
@synthesize player;
@synthesize inputLayer;
@synthesize zombieBatch;
@synthesize powerupBatch;
@synthesize bulletBatch;
@synthesize rocketBatch;

@synthesize backgroundMap;

@synthesize leftAnalogStick;
@synthesize rightAnalogStick;

@synthesize powerupHUD;

@synthesize damageIndicator;

@synthesize guiBatch;
@synthesize ammoLabel;
@synthesize healthLabel;
@synthesize reloadingSprite;
@synthesize switchWeaponButton;
@synthesize pauseButton;

@synthesize waveIndicator;
@synthesize waveNumber;

@synthesize numberZombiesKilled;
@synthesize deathBackground;

@synthesize casings;
@synthesize bloodSplatters;
@synthesize rocketTrails;

@synthesize explosionToRemove;

@synthesize smgr;

@synthesize gameModeWave;
@synthesize dead;

-(id)initWithGameModeWave:(BOOL)gmw{
    self = [super init];
	if(self){
        self.smgr = [[SpaceManagerCocos2d alloc] init];
        self.gameModeWave = gmw;
        
        [smgr addRectAt:ccp(-32, 512) mass:STATIC_MASS width:64.0f height:1024.0f rotation:0];
        [smgr addRectAt:ccp(1056, 512) mass:STATIC_MASS width:64.0f height:1024.0f rotation:0];
        [smgr addRectAt:ccp(512, -32) mass:STATIC_MASS width:1024.0f height:64.0f rotation:0];
        [smgr addRectAt:ccp(512, 1056) mass:STATIC_MASS width:1024.0f height:64.0f rotation:0];
        
        [smgr setGravity: cpv(0.0f, 0.0f)];
        [smgr start: 1.0f/60.0f];
        
        [smgr addCircleAt:ccp(280,462) mass:STATIC_MASS radius:20];
        [smgr addCircleAt:ccp(730, 462) mass:STATIC_MASS radius:20];
        [smgr addRectAt:ccp(319,166) mass:STATIC_MASS width:184 height:134 rotation:0];
        [smgr addRectAt:ccp(730,166) mass:STATIC_MASS width:184 height:134 rotation:0];
        self.backgroundMap = [[CCSprite alloc] initWithFile: @"Map_ParkingLot.png"];
        
        [backgroundMap setPosition: ccp(512,512)];
        [self addChild: backgroundMap z:-1];
        
        self.casings = [[CCSpriteBatchNode alloc] initWithFile:@"Shell.png" capacity: CASINGOVERWRITE];
        [self addChild: casings z:0];
        
        self.bulletBatch = [[BulletBatch alloc] initWithSpaceManager: smgr];
        [self addChild: bulletBatch z:1];
        
        self.rocketTrails = [[CCSpriteBatchNode alloc] initWithFile:@"RocketTrail.png" capacity:MAXROCKETS];
        [self addChild: rocketTrails z:2];

        self.rocketBatch = [[RocketBatch alloc] initWithSpaceManager: smgr trailBatch: rocketTrails];
        [self addChild: rocketBatch z:3];
        
        self.bloodSplatters = [[CCSpriteBatchNode alloc] initWithFile:@"Bloodsplatter.png" capacity: 500];
        [self addChild: bloodSplatters z:4];
        
        self.zombieBatch = [[ZombieBatch alloc] initWithSpaceManager: smgr];
        [self addChild: zombieBatch z:5];
        
		self.player = [[Player alloc] initWithSpaceManager:smgr];
        self.powerupBatch = [[PowerupBatch alloc] initWithSpaceManager: smgr withPlayer: player];

        [self addChild: powerupBatch z:6];
        [self addChild: player z:7];
        
        self.powerupHUD = [[PowerupHUD alloc] init];
        [self addChild: powerupHUD z:8];
        
        self.guiBatch = [[CCSpriteBatchNode alloc] initWithFile:@"GuiSheet.png" capacity:10];
        [self addChild: guiBatch z:9];
        
        AppDelegate *del = [[UIApplication sharedApplication] delegate];
        
        self.leftAnalogStick = [[CCSprite alloc] initWithFile: @"GuiSheet.png" rect:CGRectMake(0, 0, 128, 128)];
        [leftAnalogStick setPosition: ccp((float)[del analogStickPixelOffsetX], (float)[del analogStickPixelOffsetY])];
        [guiBatch addChild: leftAnalogStick];
        
        self.rightAnalogStick = [[CCSprite alloc] initWithFile: @"GuiSheet.png" rect:CGRectMake(0, 0, 128, 128)];
        [rightAnalogStick setPosition: ccp(480.0f - (float)[del analogStickPixelOffsetX], (float)[del analogStickPixelOffsetY])];
        [guiBatch addChild: rightAnalogStick];
        
        self.ammoLabel = [[[CCLabelAtlas alloc] initWithString:@"0/0" charMapFile:@"Font.png" itemWidth:16 itemHeight:24 startCharMap:','] retain];
        [ammoLabel setAnchorPoint: ccp(0.0f, 1.0f)];
        [ammoLabel setPosition: ccp(0.0f, 320.0f)];
        [self addChild: ammoLabel z:10];
        [player updateAmmo];
        
        self.healthLabel = [[[CCLabelAtlas alloc] initWithString:@"-100" charMapFile:@"Font.png" itemWidth:16 itemHeight:24 startCharMap:','] retain];
        [healthLabel setAnchorPoint: ccp(1.0f, 1.0f)];
        [healthLabel setPosition: ccp(480.0f, 360.0f)];
        [self addChild: healthLabel z:11];
        [player updateHealth];
        
        self.reloadingSprite = [[CCSprite alloc] initWithFile: @"GuiSheet.png" rect:CGRectMake(0, 128, 128, 32)];
        [reloadingSprite setAnchorPoint: ccp(0.0f, 1.0f)];
        [reloadingSprite setPosition: ccp(0.0f, 320.0f)];
        [reloadingSprite setOpacity: 0];
        [guiBatch addChild: reloadingSprite];
        
        self.switchWeaponButton = [[CCSprite alloc] initWithFile: @"GuiSheet.png" rect:CGRectMake(192, 24, 64, 24)];
        [switchWeaponButton setAnchorPoint: ccp(0.5f, 1.0f)];
        [switchWeaponButton setPosition: ccp(288.0f, 320.0f)];
        [guiBatch addChild: switchWeaponButton];
        
        self.pauseButton = [[CCSprite alloc] initWithFile: @"GuiSheet.png" rect:CGRectMake(192, 0, 64, 24)];
        [pauseButton setAnchorPoint: ccp(0.5f, 1.0f)];
        [pauseButton setPosition: ccp(192.0f, 320.0f)];
        [guiBatch addChild: pauseButton];
        
        if(gameModeWave){
            currentWave = 0;
            for(int x = 0; x < 7; x++){
                toSpawns[x] = 0;
            }
            
            [self startNewWave];
                    
            self.waveIndicator = [[CCSprite alloc] initWithFile:@"GuiSheet.png" rect:CGRectMake(128, 128, 128, 40)];
            [waveIndicator setOpacity: 0];
            [waveIndicator setPosition:ccp(240.0f, 240.0f)];
            [guiBatch addChild: waveIndicator];
            
            self.waveNumber = [[[CCLabelAtlas alloc] initWithString:[NSString stringWithFormat:@"%i", currentWave] charMapFile:@"Font.png" itemWidth:16 itemHeight:24 startCharMap:','] retain];
            [waveNumber setAnchorPoint: ccp(0.0f, 0.5f)];
            [waveNumber setPosition: ccpAdd([waveIndicator position], ccp(15.0f, -3.0f))];
            [waveNumber setOpacity: 0];
            [self addChild: waveNumber z: 12];
        }else{
            [self schedule:@selector(spawnZombieEndless) interval:1.0f];
        }
        
        self.damageIndicator = [[CCLayerColor alloc] initWithColor: ccc4(155, 0, 0, 0) width:480 height:320];;

        [damageIndicator setOpacity: 0];
        [damageIndicator setAnchorPoint: ccp(0.5f, 0.5f)];
        [self addChild: damageIndicator z:13];
        
        self.deathBackground = [[CCSprite alloc] initWithFile:@"GuiSheet.png" rect:CGRectMake(0, 170, 300, 150)];
        [deathBackground setPosition: ccp(240.0f, 160.0f)];
        [deathBackground setVisible: NO];
        [deathBackground setOpacity: 0];
        [self addChild: deathBackground z:14];
        
        self.numberZombiesKilled = [[CCLabelTTF alloc] initWithString:@"" fontName:@"Badseed" fontSize:24.0f];
        [numberZombiesKilled setPosition: ccp(240.0f, 160.0f)];
        [numberZombiesKilled setVisible: NO];
        [numberZombiesKilled setOpacity: 0];
        [numberZombiesKilled setColor: ccc3(255, 0, 0)];
        [self addChild: numberZombiesKilled z:15];
        
        self.inputLayer = [[InputLayer alloc] init];
        [self addChild: inputLayer z:16];
        
        zombiesKilled = 999;
        dead = NO;
        
        if([(AppDelegate *)[[UIApplication sharedApplication] delegate] soundEffects]){
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"Shot.caf"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"Reload.caf"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"ShotgunShot.caf"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"ShotgunPump.caf"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"FlameStart.caf"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"FlameLoop.caf"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"FlameReload.caf"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"Rocket.caf"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"Splat.caf"];
        }
        
    }
	return self;
}

- (void)startNewWave{
    currentWave++;
    [waveIndicator setOpacity: 0];
    [waveIndicator runAction: [CCFadeTo actionWithDuration:0.25f opacity:255]];
    [waveIndicator runAction: [CCSequence actions: [CCDelayTime actionWithDuration:2.0f], [CCFadeTo actionWithDuration:0.5f opacity:0], nil]];

    [waveNumber setString:[NSString stringWithFormat:@"%i", currentWave]];
    [waveNumber setOpacity: 0];
    [waveNumber runAction: [CCFadeTo actionWithDuration:0.25f opacity:255]];
    [waveNumber runAction: [CCSequence actions: [CCDelayTime actionWithDuration:2.0f], [CCFadeTo actionWithDuration:0.5f opacity:0], nil]];
    
    switch(currentWave){
        case 1:
            toSpawns[DONUT] =  2;
            toSpawns[PIZZA] =  1;
            break;
        case 2:
            toSpawns[DONUT] =  4;
            toSpawns[PIZZA] =  3;
            break;
        case 3:
            toSpawns[DONUT] =  5;
            toSpawns[PIZZA] =  5;
            toSpawns[FRIES] =  2;
            break;
        case 4:
            toSpawns[DONUT] =  5;
            toSpawns[PIZZA] =  5;
            toSpawns[FRIES] =  5;
            break;
        case 5:
            toSpawns[BURGER] = 12;
            break;
        case 6:
            toSpawns[DONUT] =  5;
            toSpawns[PIZZA] =  5;
            toSpawns[FRIES] =  5;
            toSpawns[BURGER] = 12;
            break;
        case 7:
            toSpawns[DONUT] =  3;
            toSpawns[PIZZA] =  3;
            toSpawns[FRIES] =  4;
            toSpawns[BURGER] = 15;
            break;
        case 8:
            toSpawns[DONUT] =  10;
            toSpawns[PIZZA] =  10;
            toSpawns[FRIES] =  10;
            toSpawns[BURGER] = 10;
            break;
        case 9:
            toSpawns[DONUT] =  12;
            toSpawns[PIZZA] =  15;
            toSpawns[FRIES] =  12;
            toSpawns[BURGER] = 12;
            break;
        case 10:
            toSpawns[BPIE] =   10;
            toSpawns[RPIE] =   10;
            break;
        case 11:
            toSpawns[DONUT] =  2;
            toSpawns[PIZZA] =  3;
            toSpawns[FRIES] =  4;
            toSpawns[BURGER] = 5;
            toSpawns[BPIE] =   12;
            toSpawns[RPIE] =   12;
            break;
        case 12:
            toSpawns[DONUT] =  7;
            toSpawns[PIZZA] =  8;
            toSpawns[FRIES] = 9;
            toSpawns[BURGER] = 10;
            toSpawns[BPIE] = 11;
            toSpawns[RPIE] = 12;
            break;
        case 13:
            toSpawns[DONUT] =  11;
            toSpawns[PIZZA] =  11;
            toSpawns[FRIES] = 11;
            toSpawns[BURGER] = 11;
            toSpawns[BPIE] = 11;
            toSpawns[RPIE] = 11;
            break;
        case 14:
            toSpawns[CAKE] = 1;
            break;
        case 15:
            toSpawns[DONUT] = 7;
            toSpawns[PIZZA] = 8;
            toSpawns[FRIES] = 9;
            toSpawns[BURGER] = 10;
            toSpawns[BPIE] = 11;
            toSpawns[RPIE] = 12;
            break;
        case 16:
            toSpawns[DONUT] = 6;
            toSpawns[PIZZA] = 5;
            toSpawns[FRIES] = 4;
            toSpawns[BURGER] = 3;
            toSpawns[BPIE] = 4;
            toSpawns[RPIE] = 5;
            toSpawns[CAKE] = 1;
            break;
        case 17:
            toSpawns[DONUT] = 5;
            toSpawns[PIZZA] = 5;
            toSpawns[FRIES] = 5;
            toSpawns[BURGER] = 5;
            toSpawns[BPIE] = 5;
            toSpawns[RPIE] = 5;
            toSpawns[CAKE] = 2;
            break;
        case 18:
            toSpawns[DONUT] = 10;
            toSpawns[PIZZA] = 10;
            toSpawns[FRIES] = 10;
            toSpawns[BURGER] = 10;
            toSpawns[BPIE] = 10;
            toSpawns[RPIE] = 10;
            toSpawns[CAKE] = 3;
            break;
        case 19: 
            toSpawns[DONUT] = 4;
            toSpawns[PIZZA] = 4;
            toSpawns[FRIES] = 4;
            toSpawns[BURGER] = 4;
            toSpawns[BPIE] = 4;
            toSpawns[RPIE] = 4;
            toSpawns[CAKE] = 4;
            break;
        case 20:
            toSpawns[DONUT] = 5;
            toSpawns[PIZZA] = 5;
            toSpawns[FRIES] = 5;
            toSpawns[BURGER] = 5;
            toSpawns[BPIE] = 5;
            toSpawns[RPIE] = 5;
            toSpawns[CAKE] = 5;
            break;
        case 21:
            toSpawns[DONUT] = 6;
            toSpawns[PIZZA] = 6;
            toSpawns[FRIES] = 6;
            toSpawns[BURGER] = 6;
            toSpawns[BPIE] = 6;
            toSpawns[RPIE] = 6;
            toSpawns[CAKE] = 6;
            break;
        case 22:
            toSpawns[DONUT] = 7;
            toSpawns[PIZZA] = 7;
            toSpawns[FRIES] = 7;
            toSpawns[BURGER] = 7;
            toSpawns[BPIE] = 7;
            toSpawns[RPIE] = 7;
            toSpawns[CAKE] = 7;
            break;
        case 23:
            toSpawns[DONUT] = 8;
            toSpawns[PIZZA] = 8;
            toSpawns[FRIES] = 8;
            toSpawns[BURGER] = 8;
            toSpawns[BPIE] = 8;
            toSpawns[RPIE] = 8;
            toSpawns[CAKE] = 8;
            break;
        case 24:
            toSpawns[CAKE] = 10;
            break;
        default:
            toSpawns[CAKE] = currentWave - 14; // Every level after 25 is an added cake
            break;
    }
    
    [self schedule: @selector(spawnLoop) interval:.0f];
    
}

- (void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    [zombieBatch unfreezeZombies];
}

- (void)spawnZombieEndless{
    [zombieBatch addNewZombieAt:ccp(CCRANDOM_0_1() * 1024, CCRANDOM_0_1() * 1024) withType:CCRANDOM_0_1() * 6.1f];
}

- (void)spawnLoop{
    BOOL spawnedAZombie = NO;
    CGPoint playerPosition = [[player playerSprite] position];
    for(int x = 0; x < 7; x++){
        if(toSpawns[x] != 0){
            while(1){
                CGPoint spawnPosition = ccp(CCRANDOM_0_1() * 1024, CCRANDOM_0_1() * 1024);
                float absDiffX = fabsf(playerPosition.x - spawnPosition.x);
                float absDiffY = fabsf(playerPosition.y - spawnPosition.y);
                
                if(absDiffX > 100 && absDiffY > 100){
                    [zombieBatch addNewZombieAt:spawnPosition withType: x];
                     toSpawns[x]--;
                    spawnedAZombie = YES;
                    break;
                }
            }
        }
    }
    if(!spawnedAZombie)
        [self unschedule: @selector(spawnLoop)];
}

- (void)playerDeath{
    dead = YES;
    [deathBackground setVisible: YES];
    [deathBackground runAction: [CCFadeTo actionWithDuration:0.5f opacity:255]];
    [numberZombiesKilled setVisible: YES];
    [numberZombiesKilled runAction: [CCFadeTo actionWithDuration:0.5f opacity:255]];
    [numberZombiesKilled setString: [NSString stringWithFormat: @"Zombies Killed: %i", zombiesKilled]];
    [self unscheduleAllSelectors];
    [player unscheduleAllSelectors];
    [[player laser] stopAllActions];
    [rocketBatch unscheduleAllSelectors];
    [bulletBatch unscheduleAllSelectors];       // Clean up all running updaters.
    [zombieBatch unscheduleAllSelectors];
    [powerupBatch unscheduleAllSelectors];
    
    [smgr stop];
    [inputLayer setVel: ccp(0.0f, 0.0f)];
    [player setVelocity: ccp(0.0f, 0.0f)];
}

- (void)incrementZombiesKilled{
    zombiesKilled++;
}

- (void)startExplosionAt:(CGPoint)start{
    if(explosionToRemove != nil){
        [self endExplosion];
    }
    CCParticleExplosion *explosion = [[CCParticleExplosion alloc] init];
    [explosion setPosition: start];
    [self addChild: explosion z:7];
    self.explosionToRemove = explosion;
    
    [self schedule:@selector(endExplosion) interval:2.5f];
}

- (void)endExplosion{
    [self unschedule: @selector(endExplosion)];
    [explosionToRemove release];
    explosionToRemove = nil;
}

- (void)updateCameraToCenterOn:(CGPoint)centerOn{
    [self.camera setCenterX:centerOn.x - 240.0f centerY:centerOn.y - 160.0f centerZ:0];
    [self.camera setEyeX:centerOn.x - 240.0f eyeY:centerOn.y - 160.0f eyeZ:1.0f];
    
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    
    [ammoLabel setPosition: ccpAdd(centerOn, ccp(-240.0f, 160.0f))];
    [healthLabel setPosition: ccpAdd(centerOn, ccp(240.0f, 160.0f))];
    [reloadingSprite setPosition: ccpAdd(centerOn, ccp(-240.0f, 160.0f))];
    [rightAnalogStick setPosition: ccpAdd(centerOn, ccp(240.0f - (float)[del analogStickPixelOffsetX], -160.0f + (float)[del analogStickPixelOffsetY]))];
    [leftAnalogStick setPosition: ccpAdd(centerOn, ccp(-240.0f + (float)[del analogStickPixelOffsetX], -160.0f + (float)[del analogStickPixelOffsetY]))];
    [damageIndicator setPosition: ccpAdd(centerOn, ccp(-240.0f, -160.0f))];
    [switchWeaponButton setPosition: ccpAdd(centerOn, ccp(48.0f, 160.0f))];
    [pauseButton setPosition: ccpAdd(centerOn, ccp(-48.0f, 160.0f))];
    [waveIndicator setPosition: ccpAdd(centerOn, ccp(0.0f, 80.0f))];
    [waveNumber setPosition: ccpAdd([waveIndicator position], ccp(15.0f, -3.0f))];
    [numberZombiesKilled setPosition: ccpAdd(centerOn, ccp(0.0f, 0.0f))];
    [deathBackground setPosition: centerOn];
    [powerupHUD setPosition: ccpAdd(centerOn, ccp(-232.0f, 32.0f))];
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

- (void)addNewBloodSplatterAt:(CGPoint)position withRotation:(float)rotation withColor:(ccColor3B)color{
    CCSprite *newSplatter = [[CCSprite alloc] initWithFile: @"Bloodsplatter.png"];
    [newSplatter setPosition: position];
    [newSplatter setAnchorPoint: ccp(0.5f, 0.0f)];
    [newSplatter setRotation: rotation];
    [newSplatter setColor: color];
    [newSplatter setScaleY: CCRANDOM_MINUS1_1() * 0.5f + 1.0f];
    [newSplatter setDisplayFrame: [CCSpriteFrame frameWithTexture: [newSplatter texture] rect:CGRectMake(0, 0, 16, 32)]];
    CCAnimation *splat = [CCAnimation animationWithFrames:nil delay:CCRANDOM_0_1() * .015f + .03f];
    for(int x = 0; x < 8; x++){
        [splat addFrame: [CCSpriteFrame frameWithTexture:[newSplatter texture] rect:CGRectMake(x * 16, 0, 16, 32)]];
    }
    [newSplatter runAction: [CCSequence actions:[CCAnimate actionWithAnimation: splat restoreOriginalFrame:NO],[CCFadeTo actionWithDuration:2.5f opacity:0] ,[CCCallFunc actionWithTarget:self selector:@selector(removeBloodSplatter)], nil]];
    [bloodSplatters addChild: newSplatter];
    [newSplatter release];
}

- (void)removeBloodSplatter{
    [bloodSplatters removeChildAtIndex:0 cleanup:YES];
}

- (void)flashDamageIndicator{
    CCFadeTo *fadeTo = [CCFadeTo actionWithDuration:0.1f opacity:255];
    CCFadeTo *fadeFrom = [CCFadeTo actionWithDuration:0.1f opacity:0];
    [damageIndicator runAction: [CCSequence actions:fadeTo, fadeFrom, nil]];
}

- (void)dealloc{
    [self removeChild:player cleanup:YES];
    [self removeChild:inputLayer cleanup:YES];
    [self removeChild:zombieBatch cleanup:YES];
    [self removeChild:bulletBatch cleanup:YES];
    [self removeChild:rocketBatch cleanup:YES];
    [self removeChild:backgroundMap cleanup:YES];
    [self removeChild:leftAnalogStick cleanup:YES];
    [self removeChild:rightAnalogStick cleanup:YES];
    [self removeChild:damageIndicator cleanup:YES];
    [self removeChild:ammoLabel cleanup:YES];
    [self removeChild:healthLabel cleanup:YES];
    [self removeChild:reloadingSprite cleanup:YES];
    [self removeChild:switchWeaponButton cleanup:YES];
    [self removeChild:casings cleanup:YES];
    [self removeChild:bloodSplatters cleanup:YES];
    [self removeChild:rocketTrails cleanup:YES];
    
    if(explosionToRemove != nil && [[self children] containsObject: explosionToRemove]){
        [self removeChild:explosionToRemove cleanup:YES];
    }

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
