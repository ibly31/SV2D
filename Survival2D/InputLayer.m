//
//  InputLayer.m
//  Survival2D
//
//  Created by Billy Connolly on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InputLayer.h"
#import "GameScene.h"
#import "Player.h"
#import "PauseMenuScene.h"
#import "AppDelegate.h"

@implementation InputLayer

- (id)init{
    self = [super init];
    if(self){
        self.isTouchEnabled = YES;
        vel = ccp(0,0);
        [self schedule: @selector(setLoop)];
    }
    return self;
}

- (void)setLoop{
    Player *player = [(GameScene *)parent_ player];
    [player setVelocity: vel];
}

- (void)doTouch:(CGPoint)location{
    Player *player = [(GameScene *)parent_ player];
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    leftAnalogStickLocation = ccp((float)[del analogStickPixelOffsetX], (float)[del analogStickPixelOffsetY]);
    rightAnalogStickLocation = ccp(480.0f - (float)[del analogStickPixelOffsetX], (float)[del analogStickPixelOffsetY]);
    
	float distance = ccpDistance(location, leftAnalogStickLocation);
	if(distance < 96){
		float angle = CC_RADIANS_TO_DEGREES(atan2f(location.y - leftAnalogStickLocation.y, location.x - leftAnalogStickLocation.x));
		angle = 90 + 0 - angle;
		if(angle < 0)
			angle = 360 + angle;
		
		float velX = (3 * (distance / 80)) * cosf(CC_DEGREES_TO_RADIANS(90 + 0 - angle));
		float velY = (3 * (distance / 80)) * sinf(CC_DEGREES_TO_RADIANS(90 + 0 - angle));
		
        vel = ccp(velX, velY);
	}else{
		distance = ccpDistance(location, rightAnalogStickLocation);
		if(distance < 96){
			float angle = CC_RADIANS_TO_DEGREES(atan2f(location.y - rightAnalogStickLocation.y, location.x - rightAnalogStickLocation.x));
			angle = 90 + 0 - angle;
			if(angle < 0)
				angle = 360 + angle;
			[player setRotation: angle];
            
            if(![player shooting]){
                AppDelegate *del = [[UIApplication sharedApplication] delegate];
                [player setShooting: YES];
                [player schedule:@selector(startShooting) interval:[del shootTime]];
            }
		}else{
            [player unschedule: @selector(startShooting)];
			[player stopShooting];
		}
	}
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	NSArray *touchArray = [touches allObjects];
	for(int x = 0; x < [touchArray count]; x++){
		UITouch *touch = [touchArray objectAtIndex: x];
		CGPoint location = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];
                
        if(CGRectContainsPoint(CGRectMake(256,296,64,24), location)){
            [[(GameScene *)parent_ player] switchWeapons];
        }else if(CGRectContainsPoint(CGRectMake(160,296,64,24), location)){
            [[(GameScene*)parent_ zombieBatch] freezeZombies];
            CCScene *pms = [PauseMenuScene scene];
            [[CCDirector sharedDirector] pushScene: pms];
        }else{
            [self doTouch: location];
        }
	}
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	NSArray *touchArray = [touches allObjects];
	for(int x = 0; x < [touchArray count]; x++){
		UITouch *touch = [touchArray objectAtIndex: x];
		CGPoint location = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];
		[self doTouch: location];
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSArray *touchArray = [touches allObjects];
	for(int x = 0; x < [touchArray count]; x++){
		UITouch *touch = [touchArray objectAtIndex: x];
		CGPoint location = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];
		float distance = ccpDistance(location, rightAnalogStickLocation);
        if(distance > 96 && location.y < 160){
            vel = ccp(0,0);
        }else{
            [[(GameScene *)parent_ player] unschedule: @selector(startShooting)];
            [[(GameScene *)parent_ player] stopShooting];
        }
	}
}

@end
