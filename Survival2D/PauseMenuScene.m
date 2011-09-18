//
//  PauseMenuScene.m
//  Survival2D
//
//  Created by Billy Connolly on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PauseMenuScene.h"
#import "MainMenuScene.h"
#import "OptionsScene.h"

@implementation PauseMenuScene
@synthesize pause;
@synthesize menu;

+ (id)scene{
    CCScene *scene = [CCScene node];
    PauseMenuScene *layer = [PauseMenuScene node];
    [scene addChild: layer];
    return scene;
}

- (id)init{
    self = [super init];
    if(self){
        self.isTouchEnabled = YES;
        
        CCLayerColor *backgroundColor = [CCLayerColor layerWithColor:ccc4(125, 125, 125, 255)];
        [self addChild: backgroundColor];
        
        self.pause = [[CCLabelTTF alloc] initWithString:@"Pause" fontName:@"Badseed.ttf" fontSize:36.0f];
        [pause setPosition: ccp(240.0f, 280.0f)];
        [self addChild: pause];
        
        CCLabelTTF *returnToGame = [[CCLabelTTF alloc] initWithString:@"Return to Game" fontName:@"Badseed" fontSize:36.0f];
        CCMenuItemLabel *returnToGameLabel = [[CCMenuItemLabel alloc] initWithLabel:returnToGame target:self selector:@selector(returnToGame)];
        
        CCLabelTTF *options = [[CCLabelTTF alloc] initWithString:@"Options" fontName:@"Badseed" fontSize:36.0f];
        CCMenuItemLabel *optionsLabel = [[CCMenuItemLabel alloc] initWithLabel:options target:self selector:@selector(options)];
        [optionsLabel setPosition: ccp(0, -50)];
        
        CCLabelTTF *exitGame = [[CCLabelTTF alloc] initWithString:@"Exit Game" fontName:@"Badseed" fontSize:36.0f];
        CCMenuItemLabel *exitGameLabel = [[CCMenuItemLabel alloc] initWithLabel:exitGame target:self selector:@selector(exitGame)];
        [exitGameLabel setPosition: ccp(0, -100)];
        
        self.menu = [CCMenu menuWithItems:returnToGameLabel, optionsLabel, exitGameLabel, nil];
        [self addChild: menu];
        [returnToGame release];
        [returnToGameLabel release];
        [options release];
        [optionsLabel release];
        [exitGame release];
        [exitGameLabel release];
        
        /*self.toGame = [[CCSprite alloc] initWithFile:@"GuiSheet.png" rect:CGRectMake(128, 0, 64, 64)];
        [toGame setPosition: ccp(368.0f, 160.0f)];
        [self addChild: toGame];
        
        self.toMainMenu = [[CCSprite alloc] initWithFile:@"GuiSheet.png" rect:CGRectMake(128, 0, 64, 64)];
        [toMainMenu setPosition: ccp(112.0f, 160.0f)];
        [self addChild: toMainMenu];*/
    }
    return self;
}

/*- (void)onEnter{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}*/

- (void)onEnterTransitionDidFinish{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)returnToGame{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5f];
}

- (void)options{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    CCScene *os = [OptionsScene scene];
    [(OptionsScene *)[os getChildByTag: 31] setFlagForFromMenu: NO];
    [[CCDirector sharedDirector] pushScene: [CCTransitionFade transitionWithDuration:0.5f scene: os]];
}

- (void)exitGame{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [[CCDirector sharedDirector] popScene];
    CCScene *mms = [MainMenuScene scene];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:mms]];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    /*UITouch *touch = [touches anyObject];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView: touch.view]];
    if(CGRectContainsPoint(CGRectMake([toGame position].x - 32.0f, [toGame position].y - 32.0f, 64.0f, 64.0f), location)){
        [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5f];
    }else if(CGRectContainsPoint(CGRectMake([toMainMenu position].x - 32.0f, [toMainMenu position].y - 32.0f, 64.0f, 64.0f), location)){
        [[CCDirector sharedDirector] popScene];
        CCScene *mms = [MainMenuScene scene];
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:mms]];
    }*/
}

@end
