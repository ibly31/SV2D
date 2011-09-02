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
@synthesize titleLabel;
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
        backgroundColor = [[CCLayerColor alloc] initWithColor: ccc4(125, 125, 125, 255)];
        [self addChild: backgroundColor];
                
        self.titleLabel = [[CCLabelTTF alloc] initWithString:@"Food Zombies" fontName:@"Badseed.ttf" fontSize: 50.0f];
        [titleLabel setAnchorPoint: ccp(0.5f, 1.0f)];
        [titleLabel setPosition: ccp(240.0f, 310.0f)];
        [self addChild: titleLabel];
        
        CCLabelTTF *chooseGame = [[CCLabelTTF alloc] initWithString:@"Play" fontName:@"Badseed.ttf" fontSize:36.0f];
        CCMenuItemLabel *chooseGameLabel = [[CCMenuItemLabel alloc] initWithLabel:chooseGame target:self selector:@selector(chooseGame)];
        
        CCLabelTTF *tutorial = [[CCLabelTTF alloc] initWithString:@"Tutorial" fontName:@"Badseed.ttf" fontSize:36.0f];
        CCMenuItemLabel *tutorialLabel = [[CCMenuItemLabel alloc] initWithLabel:tutorial target:self selector:@selector(tutorial)];
        [tutorialLabel setPosition: ccp(0, -50)];
        
        CCLabelTTF *options = [[CCLabelTTF alloc] initWithString:@"Options" fontName:@"Badseed.ttf" fontSize:36.0f];
        CCMenuItemLabel *optionsLabel = [[CCMenuItemLabel alloc] initWithLabel:options target:self selector:@selector(options)];
        [optionsLabel setPosition: ccp(0, -100)];
        
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
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:cgs]];
}

- (void)tutorial{
    CCScene *ts = [TutorialScene scene];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:ts]];
}

- (void)options{
    CCScene *os = [OptionsScene scene];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene: os]];
}
     
@end
