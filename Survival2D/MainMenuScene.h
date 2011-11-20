//
//  MainMenuScene.h
//  Survival2D
//
//  Created by Billy Connolly on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "SoundEffectButton.h"

@interface MainMenuScene : CCLayer {
    CCSprite *background;
    
    CCMenu *menu;
    
    SoundEffectButton *seb;
}

+ (id)scene;

@property (nonatomic, retain) CCSprite *background;
@property (nonatomic, retain) CCMenu *menu;
@property (nonatomic, retain) SoundEffectButton *seb;

- (void)chooseGame;
- (void)tutorial;
- (void)options;

@end