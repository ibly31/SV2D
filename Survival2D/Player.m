//
//  Player.m
//  Survival2D
//
//  Created by Billy Connolly on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "GameScene.h"

@implementation Player
@synthesize playerSprite;
@synthesize weapon;
@synthesize muzzleFlash;
@synthesize smgr;

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)spacemgr{
    self = [super init];
    if(self){
        
        self.smgr = spacemgr;
        
        playerShape = [smgr addCircleAt:cpv(240.0f, 160.0f) mass:2.0f radius:16.0f];
        
        self.playerSprite = [[CCSprite alloc] initWithFile:@"PlayerSheet.png" rect:CGRectMake(0, 0, 64, 64)];
        self.weapon = [[Weapon alloc] initWithName:@"M4A1"];
        self.muzzleFlash = [[CCSprite alloc] initWithFile:@"MuzzleFlash.png"];
        [muzzleFlash setOpacity: 0];
        [muzzleFlash setAnchorPoint: ccp(0.5f, 0.0f)];
        
        [self addChild: weapon];
        [self addChild: muzzleFlash];
        [self addChild: playerSprite];
        
        health = 100;
        armor = 100;
        speed = 40.0f;
        
        [self syncPosition];
        [self schedule:@selector(syncPosition) interval:1.0f / 60.0f];
    }
    return self;
}

- (void)startShooting{
    if(!shooting){
        [self schedule:@selector(shoot) interval: [weapon getDelay]];
        shooting = YES;
        [self shoot];
    }
}

- (void)shoot{
    
    int result = [weapon shoot];
    if(result == 0){        
        
    }else if(result == 1){
        
        CGPoint startPos = [weapon convertToWorldSpace: ccp(weapon.contentSize.width / 2, weapon.contentSize.height / 2)];
        CGPoint endPos = [weapon convertToWorldSpace: ccp(weapon.contentSize.width * (CCRANDOM_0_1() * 3 + 2), weapon.contentSize.height / 2)];
        
        [(GameScene *)parent_ addNewBulletCasingsAt:startPos endPos:endPos startRot:[playerSprite rotation]];
        
        [muzzleFlash stopAllActions];
        [muzzleFlash setOpacity: 255];
        [muzzleFlash setPosition: [weapon convertToWorldSpace: ccp(weapon.contentSize.width / 2, weapon.contentSize.height - [weapon getFlashPos])]];
        [muzzleFlash setRotation: [playerSprite rotation] + CCRANDOM_0_1() * 30.0f - 15.0f];
        if(CCRANDOM_0_1() > 0.5f){
            [muzzleFlash setScaleX: -1.0f];
        }else{
            [muzzleFlash setScaleX: 1.0f];
        }
        [muzzleFlash setScaleY: CCRANDOM_0_1() * 0.5f + 0.75f];
        [muzzleFlash runAction: [CCFadeTo actionWithDuration:0.02f opacity: 0]];
        
        //CGPoint shootFrom = [weapon convertToWorldSpace: ccp(weapon.contentSize.width / 2, weapon.contentSize.height)];
        //CGPoint shootTo = ccp(576.0f * cosf(CC_DEGREES_TO_RADIANS(90 - [playerSprite rotation])), 576.0f * sinf(CC_DEGREES_TO_RADIANS(90 - [playerSprite rotation])));
        
        float delay = .05f;
        CCScaleTo *kickBack = [CCScaleTo actionWithDuration: delay scaleX: 1.0f scaleY:0.85f];
        CCScaleTo *kickForw = [CCScaleTo actionWithDuration: delay scaleX: 1.0f scaleY:1.0f];
        [weapon runAction: [CCSequence actions:kickBack, kickForw, nil]];
        
    }else if(result == 2 && !reloading){
        reloading = YES;
        CCSprite *rel = [(GameScene *)parent_ reloadingSprite];
        CCLabelAtlas *amm = [(GameScene *)parent_ ammoLabel];
        
        [rel setOpacity: 255];
        [amm setOpacity: 0];
        
        [self schedule:@selector(reload) interval:[weapon getReloadTime]];
    }
    
    [self updateAmmo];
}

- (void)stopShooting{
    if(shooting){
        [self unschedule: @selector(shoot)];
        shooting = NO;
    }
}

- (void)syncPosition{
    [playerSprite setPosition: playerShape->body->p];
    [weapon setPosition: playerShape->body->p];
    [[(GameScene *)parent_ zombieBatch] setPlayerPosition: playerShape->body->p];
    [(GameScene *)parent_ updateCameraToCenterOn: playerShape->body->p];
}

- (void)setVelocity:(CGPoint)vel{
    cpBodyActivate(playerShape->body);
    playerShape->body->v = cpv(vel.x * speed, vel.y * speed);
}

- (void)setRotation:(float)rot{
    [playerSprite setRotation: rot];
    [weapon setRotation: rot];
}

- (void)reload{
    if(reloading){
        reloading = NO;
        [self unschedule: @selector(reload)];
        [weapon setMagazineCount: [weapon getMagazineCount] - 1];
        [weapon setCurrentMagazine: [weapon getMaxAmmo]];
        CCSprite *rel = [(GameScene *)parent_ reloadingSprite];
        CCLabelAtlas *amm = [(GameScene *)parent_ ammoLabel];
        
        [self updateAmmo];
        
        [rel setOpacity: 0];
        [amm setOpacity: 255];
    }
}

- (void)takeDamage:(int)damage{
    health -= damage;
    [self updateHealth];
}

- (void)updateHealth{
    CCLabelAtlas *healthLabel = [(GameScene *)parent_ healthLabel];
    [healthLabel setString: [NSString stringWithFormat: @",%i -%i", armor, health]];
}

- (void)updateAmmo{
    CCLabelAtlas *ammoLabel = [(GameScene *)parent_ ammoLabel];
    [ammoLabel setString: [NSString stringWithFormat: @"%i/%i", [weapon getCurrentMagazine], [weapon getMagazineCount] * [weapon getMaxAmmo]]];
}

@end
