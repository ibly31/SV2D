//
//  AnalogLocator.m
//  Survival2D
//
//  Created by Billy Connolly on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AnalogLocator.h"
#import "AppDelegate.h"

@implementation AnalogLocator
@synthesize analogStick;

- (id)initWithWidth:(int)w height:(int)h{
    width = w;
    height = h;
    [self initWithColor:ccc4(255, 255, 255, 255) width:width height:height];
    if(self){
        [self setIsTouchEnabled: YES];
        CCLayerColor *inside = [[CCLayerColor alloc] initWithColor:ccc4(0, 0, 0, 255) width:width - 2 height:height - 2];
        [inside setPosition: ccp(1.0f, 1.0f)];
        [self addChild: inside];
        
        AppDelegate *del = [[UIApplication sharedApplication] delegate];
        
        self.analogStick = [[CCSprite alloc] initWithFile: @"GuiSheet.png" rect:CGRectMake(0, 0, 128, 128)];
        [analogStick setPosition: ccp((float)[del analogStickPixelOffsetX], (float)[del analogStickPixelOffsetY])];
        [self addChild: analogStick];
    }
    return self;
}

- (void)doTouch:(CGPoint)location{
    CGPoint clampedLocation = location;
    if(location.x < 64)
        clampedLocation.x = 64;
    else if(location.x > width - 64)
        clampedLocation.x = width - 64;
    
    if(location.y < 64)
        clampedLocation.y = 64;
    else if(location.y > height - 64)
        clampedLocation.y = height - 64;
    
    [analogStick setPosition: clampedLocation];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	if (![self containsTouchLocation:touch])
        return NO;
    [self doTouch: [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]]];
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
	[self doTouch: [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]]];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    [del setAnalogStickPixelOffsetX: (int)[analogStick position].x];
    [del setAnalogStickPixelOffsetY: (int)[analogStick position].y];
}

- (BOOL)containsTouchLocation:(UITouch *)touch{
    CGPoint p = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];
	return CGRectContainsPoint(CGRectMake([self position].x, [self position].y, width, height), p);
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
