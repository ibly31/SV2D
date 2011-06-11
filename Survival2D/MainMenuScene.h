//
//  MainMenuScene.h
//  Survival2D
//
//  Created by Billy Connolly on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface MainMenuScene : CCScene {
    CCLayerColor *backgroundColor;
    CCLabelTTF *titleLabel;
    
    CCMenu *menu;
}

@property (nonatomic, retain) CCLabelTTF *titleLabel;
@property (nonatomic, retain) CCMenu *menu;

- (void)chooseGame;
- (void)options;

@end