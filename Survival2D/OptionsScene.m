//
//  OptionsScene.m
//  Survival2D
//
//  Created by Billy Connolly on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OptionsScene.h"
#import "MainMenuScene.h"
#import "UIKit/UIKit.h"

@implementation OptionsScene
@synthesize seb;
@synthesize endArrow;
@synthesize slider;

+(id) scene{
    CCScene *scene = [CCScene node];
    OptionsScene *layer = [OptionsScene node];
    [scene addChild: layer];
    return scene;
}

- (id)init{
    self = [super init];
    [self setIsTouchEnabled: YES];
    if(self){
        self.seb = [[SoundEffectButton alloc] initialize];
        [seb setPosition: ccp(460.0f, 20.0f)];
        [self addChild: seb];
        
        self.endArrow = [[CCSprite alloc] initWithFile:@"GuiSheet.png" rect:CGRectMake(128, 64, 64, 64)];
        [endArrow setPosition: ccp(240.0f, 32.0f)];
        [endArrow setAnchorPoint: ccp(0.5f, 0.5f)];
        [self addChild: endArrow];
        
        UISlider *uiSlider = [[[UISlider alloc] init] autorelease];
        [uiSlider setMinimumValue:0.0f];
        [uiSlider setMaximumValue:2.0f];
        
        self.slider = [[CCUIViewWrapper alloc] initForUIView: uiSlider];
        [slider setContentSize: CGSizeMake(200, 23)];
        [slider setPosition: ccp(0, 0)];
        [slider setAnchorPoint: ccp(1.0f, 0.5f)];
        [slider setRotation: 90];
        [self addChild: slider];
    }
    return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView: touch.view]];
    if(CGRectContainsPoint(CGRectMake([endArrow position].x - 32.0f, [endArrow position].y - 32.0f, 64.0f, 64.0f), location)){
        CCScene *mms = [MainMenuScene scene];
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:mms]];
    }
}

@end
