//
//  MainMenuScene.m
//  Survival2D
//
//  Created by Billy Connolly on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
#import "ChooseGameScene.h"
#import "TutorialScene.h"
#import "OptionsScene.h"

@implementation MainMenuScene
@synthesize background;
@synthesize menu;
@synthesize seb;

+(id) scene{
    CCScene *scene = [CCScene node];
    MainMenuScene *layer = [MainMenuScene node];
    [scene addChild: layer];
    return scene;
}

- (id)init{
    self = [super init];
    if(self){
        
        self.background = [[CCSprite alloc] initWithFile:@"Title.png"];
        [background setAnchorPoint: ccp(0.0f, 0.0f)];
        [self addChild: background];
        
        CCLabelTTF *chooseGame = [[CCLabelTTF alloc] initWithString:@"Play" fontName:@"Badseed.ttf" fontSize:24.0f];
        CCMenuItemLabel *chooseGameLabel = [[CCMenuItemLabel alloc] initWithLabel:chooseGame target:self selector:@selector(chooseGame)];
        [chooseGameLabel setPosition: ccp(10, 35)];
        
        CCLabelTTF *tutorial = [[CCLabelTTF alloc] initWithString:@"Tutorial" fontName:@"Badseed.ttf" fontSize:24.0f];
        CCMenuItemLabel *tutorialLabel = [[CCMenuItemLabel alloc] initWithLabel:tutorial target:self selector:@selector(tutorial)];
        [tutorialLabel setPosition: ccp(10, -38)];
        
        CCLabelTTF *options = [[CCLabelTTF alloc] initWithString:@"Options" fontName:@"Badseed.ttf" fontSize:24.0f];
        CCMenuItemLabel *optionsLabel = [[CCMenuItemLabel alloc] initWithLabel:options target:self selector:@selector(options)];
        [optionsLabel setPosition: ccp(10, -113)];
        
        self.menu = [CCMenu menuWithItems:chooseGameLabel, tutorialLabel, optionsLabel, nil];
        [self addChild: menu];
        [chooseGame release];
        [chooseGameLabel release];
        [tutorial release];
        [tutorialLabel release];
        [options release];
        [optionsLabel release];
        
        self.seb = [[SoundEffectButton alloc] initialize];
        [seb setPosition: ccp(460.0f, 20.0f)];
        [self addChild: seb];
    }
    return self;
}

- (void)chooseGame{
    CCScene *cgs = [ChooseGameScene scene];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:cgs]];
}

- (void)tutorial{
    CCScene *ts = [TutorialScene scene];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:ts]];
}

- (void)options{
    CCScene *os = [OptionsScene scene];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene: os]];
}
     
@end
