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
@synthesize laser;
@synthesize smgr;
@synthesize shooting;

@synthesize flameThrower;

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)spacemgr{
    self = [super init];
    if(self){
        self.smgr = spacemgr;
        playerShape = [smgr addCircleAt:cpv(512.0f, 512.0f) mass:2.0f radius:24.0f];
        playerShape->collision_type = 1; //PLAYER_TYPE
        [smgr addCollisionCallbackBetweenType:1 otherType:0 target:self selector:@selector(handleCollision:arbiter:space:) moments:COLLISION_BEGIN, COLLISION_SEPARATE, nil];
        
        self.playerSprite = [[CCSprite alloc] initWithFile:@"PlayerSheet.png" rect:CGRectMake(0, 0, 64, 64)];
        self.weapon = [[Weapon alloc] initWithName:@"Rocket Launcher"];
        self.muzzleFlash = [[CCSprite alloc] initWithFile:@"MuzzleFlash.png"];
        [muzzleFlash setOpacity: 0];
        [muzzleFlash setAnchorPoint: ccp(0.5f, 0.0f)];
        
        self.flameThrower = [[CCParticleFire alloc] init];
        [flameThrower setEmissionRate: 0.0f];
        
        self.laser = [[CCSprite alloc] initWithFile: @"LaserAnimated.png"];
        [laser setAnchorPoint: ccp(0.5f, 0.0f)];
        [laser setScaleY: 6.25f];
        
        [self laserSetOn: NO];
        
        [self addChild: weapon];
        [self addChild: laser];
        [self addChild: muzzleFlash];
        [self addChild: playerSprite];
        [self addChild: flameThrower];
                
        health = 100;
        armor = 100;
        speed = 40.0f;
        currentRecoil = 0.0f;
        
        [self syncPosition];
        [self schedule:@selector(syncPosition) interval:1.0f / 60.0f];
        
        [self schedule:@selector(lowerRecoil) interval:1.0f / 20.0f];
        [self schedule:@selector(processZombieHits) interval: 1.0f / 2.0f];
    }
    return self;
}

- (void)laserSetOn:(BOOL)onoff{
    if(onoff){
        [laser setOpacity: 255];
        CCAnimation *laserAnimation = [CCAnimation animationWithFrames: nil delay: .05f];
        for(int x = 0; x < 8; x++){
            CGRect frame = CGRectMake(x, 0.0f, 1.0f, 64.0f);
            [laserAnimation addFrame: [CCSpriteFrame frameWithTexture:[laser texture] rect: frame]];
        }
        [laser runAction: [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation: laserAnimation]]];

    }else{
        [laser setOpacity: 0];
        [laser stopAllActions];
    }
}

- (void)lowerRecoil{
    if(shooting){
        currentRecoil -= 0.1f;
    }else{
        currentRecoil -= 2.0f;
    }
    if(currentRecoil < 0){
        currentRecoil = 0;
    }
}

- (BOOL)handleCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space{
    if(moment == COLLISION_BEGIN){
        numberOfZombiesTouchingPlayer++;
    }else if(moment == COLLISION_SEPARATE){
        numberOfZombiesTouchingPlayer--;
    }
    return YES;
}

- (void)processZombieHits{
    if(numberOfZombiesTouchingPlayer > 0){
        [self takeDamage: numberOfZombiesTouchingPlayer * 2];
    }
}

- (void)startShooting{
    [self unschedule: @selector(startShooting)];
    [self schedule:@selector(shoot) interval: [weapon getDelay]];
    shooting = YES;
    [self shoot];
}

- (void)shoot{
    int result = [weapon shoot];
    if(result == 0){        
        
    }else if(result == 1){
        
        CGPoint startPos = [weapon convertToWorldSpace: ccp(weapon.contentSize.width / 2, weapon.contentSize.height / 2)];
        CGPoint endPos = [weapon convertToWorldSpace: ccp(weapon.contentSize.width * (CCRANDOM_0_1() * 3 + 2), weapon.contentSize.height / 2)];
        
        if([weapon getWeaponType] != 3 && [weapon getWeaponType] != 4){
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
        }
        
        float sOffs = ([playerSprite rotation] + (CCRANDOM_MINUS1_1() * currentRecoil));
        CGPoint sFrom = [weapon convertToWorldSpace: ccp(weapon.contentSize.width / 2, weapon.contentSize.height)];
        
        int t = [weapon getWeaponType];
        int d = [weapon getDamage];
        int p = [weapon getPenetration];
        
        if(t == 1){
            [[(GameScene *)parent_ bulletBatch] fireBulletFrom:sFrom withRotation:sOffs withDamage:d withPenetration:p];
        }else if(t == 2){
            for(int x = -2; x < 2; x++){
                [[(GameScene *)parent_ bulletBatch] fireBulletFrom:sFrom withRotation:sOffs - (2*x) withDamage:d withPenetration:p];
            }
        }else if(t == 3){
            [flameThrower setEmissionRate: [flameThrower totalParticles] / [flameThrower life]];
            [[(GameScene *)parent_ zombieBatch] flamePath: sFrom withRotation: sOffs withVariance: [flameThrower angleVar] withDamage: [weapon getDamage]];
        }else if(t == 4){
            [[(GameScene *)parent_ rocketBatch] fireRocketFrom: sFrom withRotation:sOffs withDamage:[weapon getDamage]];
        }
        
        if(t != 3){
            if(currentRecoil < 15)
                currentRecoil += [weapon getRecoil];
                    
            float delay = .05f;
            CCScaleTo *kickBack = [CCScaleTo actionWithDuration: delay scaleX: 1.0f scaleY:0.85f];
            CCScaleTo *kickForw = [CCScaleTo actionWithDuration: delay scaleX: 1.0f scaleY:1.0f];
            [weapon runAction: [CCSequence actions:kickBack, kickForw, nil]];
        }
    }else if(result == 2 && !reloading){
        reloading = YES;
        [flameThrower setEmissionRate: 0.0f];
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
        [flameThrower setEmissionRate: 0.0f];
    }
}

- (void)syncPosition{
    [playerSprite setPosition: playerShape->body->p];
    [weapon setPosition: playerShape->body->p];
    [laser setPosition: [weapon convertToWorldSpace: ccp(weapon.contentSize.width / 2, weapon.contentSize.height - [weapon getFlashPos])]];
    [flameThrower setPosition: [weapon convertToWorldSpace: ccp(weapon.contentSize.width / 2, weapon.contentSize.height)]];
    [[(GameScene *)parent_ zombieBatch] setPlayerPosition: playerShape->body->p];
    [(GameScene *)parent_ updateCameraToCenterOn: playerShape->body->p];
}

- (void)setVelocity:(CGPoint)vel{
    cpBodyActivate(playerShape->body);
    playerShape->body->v = cpv(vel.x * speed, vel.y * speed);
}

- (void)setRotation:(float)rot{
    [laser setRotation: rot];
    [playerSprite setRotation: rot];
    [weapon setRotation: rot];
    [flameThrower setAngle: 90 - rot];
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
    if(health > 0 || armor > 0){
        if(armor > 0){
            health -= damage * .25f;
            armor -= damage * .75f;
            [(GameScene *)parent_ flashDamageIndicator:health];
        }else{
            health -= damage;
            if(health > 0){
                [(GameScene *)parent_ flashDamageIndicator:health];
            }else{
                health = 0;
            }
        }
    }
    [self updateHealth];
}

- (void)updateHealth{
    CCLabelAtlas *healthLabel = [(GameScene *)parent_ healthLabel];
    if(armor > 0){
        [healthLabel setString: [NSString stringWithFormat: @",%i -%i", armor, health]];
    }else{
        [healthLabel setString: [NSString stringWithFormat: @"-%i", health]];
    }
    
}

- (void)updateAmmo{
    CCLabelAtlas *ammoLabel = [(GameScene *)parent_ ammoLabel];
    [ammoLabel setString: [NSString stringWithFormat: @"%i/%i", [weapon getCurrentMagazine], [weapon getMagazineCount] * [weapon getMaxAmmo]]];
}

@end
