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
#import "AppDelegate.h"

@implementation OptionsScene
@synthesize seb;
@synthesize endArrow;
@synthesize slider;
@synthesize shootTimeLabel;
@synthesize analogLocator;
@synthesize flagForFromMenu;

+(id) scene{
    CCScene *scene = [CCScene node];
    OptionsScene *layer = [OptionsScene node];
    [scene addChild: layer z:0 tag:31];
    return scene;
}

- (id)init{
    self = [super init];
    [self setIsTouchEnabled: YES];
    if(self){
        
        CCLayerColor *backgroundColor = [[CCLayerColor alloc] initWithColor: ccc4(125, 125, 125, 255)];
        [self addChild: backgroundColor];
        
        CCLabelTTF *options = [[CCLabelTTF alloc] initWithString:@"Options" fontName:@"Badseed" fontSize:50.0f];
        [options setAnchorPoint: ccp(0.5f, 1.0f)];
        [options setPosition: ccp(240, 310)];
        [self addChild:options];
        
        self.shootTimeLabel = [[CCLabelTTF alloc] initWithString:@"Shoot Time: " fontName:@"Badseed" fontSize:18.0f];
        [shootTimeLabel setPosition: ccp(310.0f, 240.0f)];
        [shootTimeLabel setAnchorPoint: ccp(0.0f, 0.5f)];
        [self addChild: shootTimeLabel];
        
        AppDelegate *del = [[UIApplication sharedApplication] delegate];
        
        UISlider *uiSlider = [[[UISlider alloc] initWithFrame:CGRectMake(0, 0, 150, 23)] autorelease];
        [uiSlider setMinimumValue:0.0f];
        [uiSlider setMaximumValue:2.0f];
        [uiSlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
        [uiSlider setValue: [del shootTime]];
        [self sliderChange: uiSlider];
        
        self.slider = [[CCUIViewWrapper alloc] initForUIView: uiSlider];
        if(![[CCDirector sharedDirector] enableRetinaDisplay:YES]){
            [slider setContentSize: CGSizeMake(150, 23)];
            [slider setPosition: ccp(110, -110)];
        }else{
            [slider setContentSize: CGSizeMake(150, 23)];
            [slider setPosition: ccp(90, -330)];
        }
        
        [slider setAnchorPoint: ccp(1.5f, 1.0f)]; // Don't bother fixing - confusing.
        [slider setRotation: 90];
        [slider setOpacity: 0];
        [self addChild: slider];
        
        CCLabelTTF *sound = [[CCLabelTTF alloc] initWithString:@"Sound:" fontName:@"Badseed" fontSize:18.0f];
        [sound setPosition: ccp(24.0f, 240.0f)];
        [sound setAnchorPoint: ccp(0.0f, 0.5f)];
        [self addChild: sound];
        
        self.seb = [[SoundEffectButton alloc] initialize];
        [seb setPosition: ccp(100.0f, 240.0f)];
        [self addChild: seb];
        
        self.endArrow = [[CCSprite alloc] initWithFile:@"GuiSheet.png" rect:CGRectMake(128, 64, 64, 64)];
        [endArrow setPosition: ccp(360.0f, 32.0f)];
        [endArrow setAnchorPoint: ccp(0.5f, 0.5f)];
        [self addChild: endArrow];
        
        self.analogLocator = [[AnalogLocator alloc] initWithWidth:220 height:200];
        [self addChild: analogLocator];
        
        flagForFromMenu = YES;
        
    }
    return self;
}

- (void)onEnter{
    [super onEnter];
    [slider runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.5f], [CCFadeTo actionWithDuration: 0.0f opacity: 255], nil]];
}

-(IBAction)sliderChange:(UISlider*)sender {
    NSString *newText = [NSString stringWithFormat:@"Shoot Time: %f",(float)sender.value];
    int cutLen = [newText length];
    if(cutLen > 15){
        cutLen = 15;
    }
    newText = [newText substringToIndex: cutLen];
    [shootTimeLabel setString: newText];
    
    AppDelegate *del = [[UIApplication sharedApplication] delegate];
    float value = ((int)((float)sender.value * 10.0f)) / 10.0f;
    if(value != [del shootTime])
        [del setShootTime: value];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView: touch.view]];
    if(CGRectContainsPoint(CGRectMake([endArrow position].x - 32.0f, [endArrow position].y - 32.0f, 64.0f, 64.0f), location)){
        if(flagForFromMenu){
            CCScene *mms = [MainMenuScene scene];
            [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:mms]];
            [slider runAction: [CCFadeTo actionWithDuration:0.1f opacity:0]];
        }else{
            [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5f];
            [slider runAction: [CCFadeTo actionWithDuration:0.1f opacity:0]];

        }
    }
}

@end
