//
//  ChooseGameScene.h
//  Survival2D
//
//  Created by Billy Connolly on 6/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface ChooseGameScene : CCScene {
    CCLabelTTF *titleLabel;
    CCLayerColor *backgroundColor;
        
    CCMenu *menu;
}

- (void)parkingLot;
- (void)otherMap;

@property (nonatomic, retain) CCLabelTTF *titleLabel;
@property (nonatomic, retain) CCMenu *menu;

@end
