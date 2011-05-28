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

@implementation InputLayer

- (id)init{
    self = [super init];
    if(self){
        self.isTouchEnabled = YES;
        leftAnalogStickLocation = ccp(74.0f, 74.0f);
        rightAnalogStickLocation = ccp(404.0f, 74.0f);
                
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
                [player setShooting: YES];
                [player schedule:@selector(startShooting) interval:1.0f];
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
        
        [self doTouch: location];
        
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
