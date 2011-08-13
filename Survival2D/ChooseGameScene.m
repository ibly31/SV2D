//
//  ChooseGameScene.m
//  Survival2D
//
//  Created by Billy Connolly on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChooseGameScene.h"
#import "MainMenuScene.h"
#import "GameScene.h"

@implementation ChooseGameScene
@synthesize titleLabel;
@synthesize endArrow;
@synthesize menu;

+(id) scene{
    CCScene *scene = [CCScene node];
    ChooseGameScene *layer = [ChooseGameScene node];
    [scene addChild: layer];
    return scene;
}

- (id)init{
    self = [super init];
    [self setIsTouchEnabled: YES];
    if(self){
        backgroundColor = [[CCLayerColor alloc] initWithColor: ccc4(125, 125, 125, 255)];
        [self addChild: backgroundColor];
        
        self.titleLabel = [[CCLabelTTF alloc] initWithString:@"Choose Map" fontName:@"Badseed.ttf" fontSize:50.0f];
        [titleLabel setAnchorPoint: ccp(0.5f, 1.0f)];
        [titleLabel setPosition: ccp(240, 310)];
        [self addChild:titleLabel];
        
        CCSprite *parkingLot = [[CCSprite alloc] initWithFile:@"MapThumbs.png" rect:CGRectMake(0, 0, 128, 128)];
        CCSprite *otherMap = [[CCSprite alloc] initWithFile:@"MapThumbs.png" rect:CGRectMake(128, 0, 128, 128)];
        
        CCMenuItemSprite *parkingLotItem = [CCMenuItemSprite itemFromNormalSprite:parkingLot selectedSprite:nil target:self selector:@selector(parkingLot)];
        CCMenuItemSprite *otherMapItem = [CCMenuItemSprite itemFromNormalSprite:otherMap selectedSprite:nil target:self selector:@selector(otherMap)];
        
        [parkingLotItem setPosition: ccp(-128, 0)];
        [otherMapItem setPosition: ccp(128, 0)];
        
        self.menu = [CCMenu menuWithItems:parkingLotItem, otherMapItem, nil];
        [self addChild: menu];
        
        self.endArrow = [[CCSprite alloc] initWithFile:@"GuiSheet.png" rect:CGRectMake(128, 64, 64, 64)];
        [endArrow setPosition: ccp(240.0f, 32.0f)];
        [endArrow setAnchorPoint: ccp(0.5f, 0.5f)];
        [self addChild: endArrow];
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

- (void)parkingLot{
    GameScene *gs = [[GameScene alloc] initWithMap: 0];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:gs]];
    [gs release];
}

- (void)otherMap{
    GameScene *gs = [[GameScene alloc] initWithMap: 0];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1.0f scene:gs]];
    [gs release];
}

@end
