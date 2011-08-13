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
    
    CCSprite *toGame;
    CCSprite *toMainMenu;
}

@property (nonatomic, retain) CCLabelTTF *pause;
@property (nonatomic, retain) CCSprite *toGame;
@property (nonatomic, retain) CCSprite *toMainMenu;

+ (id)scene;

@end
