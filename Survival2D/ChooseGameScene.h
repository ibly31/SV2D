//
//  ChooseGameScene.h
//  Survival2D
//
//  Created by Billy Connolly on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface ChooseGameScene : CCLayer {
    CCLabelTTF *titleLabel;
    CCLayerColor *backgroundColor;
    
    CCSprite *endArrow;
        
    CCMenu *menu;
}

+ (id)scene;

- (void)wave;
- (void)other;

@property (nonatomic, retain) CCLabelTTF *titleLabel;
@property (nonatomic, retain) CCSprite *endArrow;
@property (nonatomic, retain) CCMenu *menu;

@end
