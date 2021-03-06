//
//  SoundEffectButton.m
//  Survival2D
//
//  Created by Billy Connolly on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SoundEffectButton.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"

@implementation SoundEffectButton

- (id)initialize{
    self = [super initWithFile:@"GuiSheet.png" rect:CGRectMake(192, 48, 24, 24)];
    if(self){
        stateOn = [(AppDelegate *)[[UIApplication sharedApplication] delegate] soundEffects];
        [self setDisplayFrame: [CCSpriteFrame frameWithTexture:self.texture rect:CGRectMake(216 - (stateOn * 24), 48, 24, 24)]];
    }
    return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	if (![self containsTouchLocation:touch])
        return NO;
    
    if(stateOn){
        stateOn = NO;
        [[SimpleAudioEngine sharedEngine] unloadEffect:@"Shot.caf"];
        [[SimpleAudioEngine sharedEngine] unloadEffect:@"Reload.caf"];
        [[SimpleAudioEngine sharedEngine] unloadEffect:@"ShotgunShot.caf"];
        [[SimpleAudioEngine sharedEngine] unloadEffect:@"ShotgunPump.caf"];
        [[SimpleAudioEngine sharedEngine] unloadEffect:@"FlameStart.caf"];
        [[SimpleAudioEngine sharedEngine] unloadEffect:@"FlameLoop.caf"];
        [[SimpleAudioEngine sharedEngine] unloadEffect:@"FlameReload.caf"];
        [[SimpleAudioEngine sharedEngine] unloadEffect:@"Rocket.caf"];
        [[SimpleAudioEngine sharedEngine] unloadEffect:@"Splat.caf"];
    }else{
        stateOn = YES;
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
    
    [self setDisplayFrame: [CCSpriteFrame frameWithTexture:self.texture rect:CGRectMake(216 - (stateOn * 24), 48, 24, 24)]];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setSoundEffects: stateOn];
    
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (BOOL)containsTouchLocation:(UITouch *)touch{
    CGPoint p = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];
	return CGRectContainsPoint(CGRectMake([self position].x - 12.0f, [self position].y - 12.0f, 24.0f, 24.0f), p);
}

- (void)onEnter{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}

- (void)onExit{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate: self];
    [super onExit];
}

@end
