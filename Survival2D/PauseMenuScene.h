//
//  PauseMenuScene.h
//  Survival2D
//
//  Created by Billy Connolly on 8/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface PauseMenuScene : CCLayer {
    CCLabelTTF *pause;
    
    CCMenu *menu;
}

+ (id)scene;

@property (nonatomic, retain) CCLabelTTF *pause;
@property (nonatomic, retain) CCMenu *menu;

- (void)returnToGame;
- (void)options;
- (void)exitGame;

@end
