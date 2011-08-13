//
//  PauseMenuScene.m
//  Survival2D
//
//  Created by Billy Connolly on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PauseMenuScene.h"
#import "MainMenuScene.h"

@implementation PauseMenuScene
@synthesize pause;
@synthesize toGame;
@synthesize toMainMenu;

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
        
        self.toGame = [[CCSprite alloc] initWithFile:@"GuiSheet.png" rect:CGRectMake(128, 0, 64, 64)];
        [toGame setPosition: ccp(368.0f, 160.0f)];
        [self addChild: toGame];
        
        self.toMainMenu = [[CCSprite alloc] initWithFile:@"GuiSheet.png" rect:CGRectMake(128, 0, 64, 64)];
        [toMainMenu setPosition: ccp(112.0f, 160.0f)];
        [self addChild: toMainMenu];
    }
    return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView: touch.view]];
    if(CGRectContainsPoint(CGRectMake([toGame position].x - 32.0f, [toGame position].y - 32.0f, 64.0f, 64.0f), location)){
        [[CCDirector sharedDirector] popSceneWithTransition:[CCTransitionFade class] duration:0.5f];
    }else if(CGRectContainsPoint(CGRectMake([toMainMenu position].x - 32.0f, [toMainMenu position].y - 32.0f, 64.0f, 64.0f), location)){
        [[CCDirector sharedDirector] popScene];
        CCScene *mms = [MainMenuScene scene];
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:mms]];
    }
}

@end
