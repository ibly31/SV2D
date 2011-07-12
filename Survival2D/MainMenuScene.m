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

@implementation MainMenuScene
@synthesize titleLabel;
@synthesize menu;

- (id)init{
    self = [super init];
    if(self){
        backgroundColor = [[CCLayerColor alloc] initWithColor: ccc4(125, 125, 125, 255)];
        [self addChild: backgroundColor];
                
        self.titleLabel = [[CCLabelTTF alloc] initWithString:@"Food Zombies" fontName:@"Splatz.ttf" fontSize: 50.0f];
        [titleLabel setAnchorPoint: ccp(0.5f, 1.0f)];
        [titleLabel setPosition: ccp(240.0f, 310.0f)];
        [self addChild: titleLabel];
        
        CCLabelTTF *chooseGame = [[CCLabelTTF alloc] initWithString:@"Play" fontName:@"Splatz.ttf" fontSize:36.0f];
        CCMenuItemLabel *chooseGameLabel = [[CCMenuItemLabel alloc] initWithLabel:chooseGame target:self selector:@selector(chooseGame)];
        
        CCLabelTTF *options = [[CCLabelTTF alloc] initWithString:@"Options" fontName:@"Splatz.ttf" fontSize:36.0f];
        CCMenuItemLabel *optionsLabel = [[CCMenuItemLabel alloc] initWithLabel:options target:self selector:@selector(options)];
        [optionsLabel setAnchorPoint: ccp(0.5f, 0.5f)];
        [optionsLabel setPosition: ccp(0, -50)];
        
        self.menu = [CCMenu menuWithItems:chooseGameLabel, optionsLabel, nil];
        [self addChild: menu];
        [chooseGame release];
        [chooseGameLabel release];
    }
    return self;
}

- (void)chooseGame{
    ChooseGameScene *cgs = [[ChooseGameScene alloc] init];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:cgs]];
    [cgs release];
}

- (void)options{
    CCScene *ts = [TutorialScene scene];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:ts]];
}
     
@end
