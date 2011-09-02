//
//  ZombieBatch.m
//  Survival2D
//
//  Created by Billy Connolly on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZombieBatch.h"
#import "chipmunk.h"
#import "GameScene.h"
#import "BulletBatch.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"

@implementation ZombieBatch
@synthesize zombieTexture;
@synthesize smgr;

- (id)initWithSpaceManager:(SpaceManagerCocos2d *)spacemgr{
    self.zombieTexture = [[CCTextureCache sharedTextureCache] addImage: @"Foodsheet.png"];
    self = [super initWithTexture:zombieTexture capacity:MAXZOMBIES];
    if(self){
        self.smgr = spacemgr;
        for(int x = 0; x < MAXZOMBIES; x++){
            CCSprite *zombieSprite = [[CCSprite alloc] initWithTexture:zombieTexture];
            [zombieSprite setOpacity: 0];
            
            Zombie newZombie;
            newZombie.health = 0;
            newZombie.alive = NO;
            newZombie.speed = 0.0f;
            newZombie.damage = 0;
            newZombie.zombieSprite = zombieSprite;
            newZombie.zombieShape = NULL;
            newZombie.zombieType = 0;
            zombies[x] = newZombie;
            
            [zombieSprite setDisplayFrame: [CCSpriteFrame frameWithTexture:zombieTexture rect:CGRectMake(0, 0, 32, 32)]];
        }
        
        frozen = NO;
        
        playerPosition = ccp(512.0f, 512.0f);
        [self schedule:@selector(updateZombies) interval:1.0f/60.0f];
    }
    return self;
}

- (void)flamePath:(CGPoint)start withRotation:(float)rotation withVariance:(float)variance withDamage:(int)damage{
    rotation = CC_DEGREES_TO_RADIANS(rotation);
    variance = CC_DEGREES_TO_RADIANS(variance);
    
    for(int x = 0; x < MAXZOMBIES; x++){
        if(zombies[x].alive){
            CGPoint zombiePos = zombies[x].position;
            float angleToStart = atan2f(zombiePos.x - start.x, zombiePos.y - start.y);
            if(angleToStart < 0)
                angleToStart += 2.0f * M_PI;
            
            if(angleToStart > (rotation - variance) && angleToStart < (rotation + variance)){
                float distanceToZombie = distance(start, zombiePos);
                if(distanceToZombie < 200)
                    [self zombieTakeDamage:damage index: x];
            }
        }
    }
}

- (void)freezeZombies{
    frozen = YES;
}
- (void)unfreezeZombies{
    frozen = NO;
}

- (void)explosionAt:(CGPoint)start withRadius:(float)radius withDamage:(int)damage{
    for(int x = 0; x < MAXZOMBIES; x++){
        if(zombies[x].alive == YES){
            float dist = distance(start, zombies[x].position);
            if(dist < radius){
                [self zombieTakeDamage: ((radius - dist) / radius) * damage index:x];
            }
        }
    }
    
    int numberOfShrapnels = (int)(CCRANDOM_0_1() * 10);
    float initialAngle = (CCRANDOM_0_1() * (360.0f / (float)numberOfShrapnels));
    
    for(int x = 0; x < numberOfShrapnels; x++){
        [[(GameScene *)parent_ bulletBatch] fireBulletFrom:start withRotation:initialAngle + (x * (360.0f / numberOfShrapnels)) withDamage:damage / numberOfShrapnels withPenetration:1];
    }
    
    [(GameScene *)parent_ startExplosionAt: start];
}

- (int)nextOpenZombieSlot{
    for(int x = 0; x < MAXZOMBIES; x++){
        if(zombies[x].alive == NO){
            return x;
        }
    }
    return 0;
}

- (int)numberZombiesAlive{
    int number = 0;
    for(int x = 0; x < MAXZOMBIES; x++){
        if(zombies[x].alive){
            number++;
        }
    }
    return number;
}

- (void)destroyZombie:(int)index{
    if([(AppDelegate *)[[UIApplication sharedApplication] delegate] soundEffects]){
        [[SimpleAudioEngine sharedEngine] playEffect:@"Splat.caf"];
    }
    
    [zombies[index].zombieSprite stopAllActions];
    [zombies[index].zombieSprite setOpacity: 0];
    zombies[index].alive = NO;
    
    int damageToUndo = zombies[index].damage;
    [[(GameScene *)parent_ player] recentZombieDamage: damageToUndo];
    
    [(NSNumber *)zombies[index].zombieShape->data release];
    zombies[index].zombieShape->data = nil;
    [smgr removeAndFreeShape: zombies[index].zombieShape];
    zombies[index].zombieShape = NULL;
    [self removeChild:zombies[index].zombieSprite cleanup:NO];
    
    int numZomb = 0;
    for(int x = 0; x < MAXZOMBIES; x++){
        if(zombies[x].alive){
            numZomb++;
        }
    }
    if(numZomb == 0){
        [(GameScene *)parent_ startNewWave];
    }
}

- (void)updateZombies{
    for(int x = 0; x < MAXZOMBIES; x++){
        if(zombies[x].alive){
            cpShape *zombieShape = zombies[x].zombieShape;
            cpBody *shapeBody = zombieShape->body;
            
            CGPoint zombiePosition = CGPointMake(shapeBody->p.x, shapeBody->p.y);
            float angleTowardsPlayer = atan2f(zombiePosition.y - playerPosition.y, playerPosition.x - zombiePosition.x);
            CGPoint force = CGPointMake(zombies[x].speed * cosf(angleTowardsPlayer), -zombies[x].speed * sinf(angleTowardsPlayer));
            
            if(!frozen){
                shapeBody->v = cpv(force.x, force.y);
            }else{
                shapeBody->v = cpv(0,0);
            }
            
            [self zombieSetPosition:zombiePosition index:x];
            [self zombieSetRotation:0 index:x];
            
            cpBodyActivate(shapeBody);
            
        }
    }
}

- (void)addNewZombieAt:(CGPoint)newZomb withType:(int)type{
    int numberAlive = [self numberZombiesAlive];
    if(numberAlive < MAXZOMBIES){        
        if(numberAlive <= MAXZOMBIES){
            int x = [self nextOpenZombieSlot];
            [self addChild: zombies[x].zombieSprite];
            zombies[x].alive = YES;
            zombies[x].zombieType = type;
            zombies[x].zombieShape = [smgr addCircleAt:newZomb mass:1.0f radius:16.0f];
            zombies[x].zombieShape->collision_type = 0;
            [zombies[x].zombieSprite setOpacity: 255];
            [zombies[x].zombieSprite setDisplayFrame: [CCSpriteFrame frameWithTexture:self.zombieTexture rect:CGRectMake(zombies[x].zombieType * 32, 0, 32, 32)]];
            
            switch(type){
                case 0:
                    zombies[x].speed = 45.0f;
                    zombies[x].health = 100;
                    zombies[x].damage = 2;
                    break;
                case 1:
                    zombies[x].speed = 60.0f;
                    zombies[x].health = 85;
                    zombies[x].damage = 1;
                    break;
                case 2:
                    zombies[x].speed = 55.0f;
                    zombies[x].health = 85;
                    zombies[x].damage = 1;
                case 3:
                    zombies[x].speed = 35.0f;
                    zombies[x].health = 200;
                    zombies[x].damage = 2;
                    break;
                case 4:
                    zombies[x].speed = 65.0f;
                    zombies[x].health = 100;
                    zombies[x].damage = 1;
                    break;
                case 5:
                    zombies[x].speed = 65.0f;
                    zombies[x].health = 85;
                    zombies[x].damage = 2;
                    break;
                case 6:
                    zombies[x].speed = 15.0f;
                    zombies[x].health = 10000;
                    zombies[x].damage = 250;
                    break;
                default:
                    NSLog(@"Default'd on Zombie Spawn");
                    break;
            }
            
            NSNumber *indNum = [[NSNumber alloc] initWithInt: x];
            zombies[x].zombieShape->data = indNum;
            
            [self zombieSetPosition:newZomb index:x];
            [self zombieSetRotation:0.0f index:x];
        }
    }
}

- (int)whichZombie:(cpShape *)zombieShape{
    int whichZombie = -1;
    for(int x = 0; x < MAXZOMBIES; x++){
        if(zombies[x].zombieShape == zombieShape){
            whichZombie = x;
        }
    }
    
    if(whichZombie == -1){
        NSLog(@"NO ZOMBIE CONNECTION.");return -1;
    }else{
        return whichZombie;
    }
}

- (void)zombieSetPosition:(CGPoint)pos index:(int)index{
    CCSprite *zombieSprite = zombies[index].zombieSprite;
    zombies[index].position = pos;
    [zombieSprite setPosition: pos];
}

- (void)zombieSetRotation:(float)rot index:(int)index{
    CCSprite *zombieSprite = zombies[index].zombieSprite;
    zombies[index].rotation = rot;
    [zombieSprite setRotation: rot];
}

- (void)zombieTakeDamage:(int)damage index:(int)index{
    if(zombies[index].alive == YES){
        float rot = (CCRANDOM_0_1() * (2 * M_PI));
        CGPoint splatPos = CGPointMake(zombies[index].position.x + 8 * cosf(rot), zombies[index].position.y + 8 * sinf(rot));
        ccColor3B color;
        if(zombies[index].zombieType == 0){
            color = ccc3(136, 70, 20);
        }else if(zombies[index].zombieType == 1){
            color = ccORANGE;
        }else if(zombies[index].zombieType == 2){
            color = ccYELLOW;
        }else if(zombies[index].zombieType == 3){
            color = ccRED;
        }else if(zombies[index].zombieType == 4){
            color = ccBLUE;
        }else if(zombies[index].zombieType == 5){
            color = ccRED;
        }else if(zombies[index].zombieType == 6){
            color = ccWHITE;
        }
        
        [(GameScene *)parent_ addNewBloodSplatterAt:splatPos withRotation: 90.0f - CC_RADIANS_TO_DEGREES(rot) withColor:color];
        
        zombies[index].health -= damage;
        if(zombies[index].health <= 0){
            [self destroyZombie: index];
        }
    }
}

- (int)getZombieDamage:(int)index{
    if(zombies[index].alive){
        return zombies[index].damage;
    }
    return 0;
}

- (void)setPlayerPosition:(CGPoint)pp{
    playerPosition = pp;
}

@end