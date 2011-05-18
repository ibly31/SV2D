//
//  InputLayer.h
//  Survival2D
//
//  Created by Billy Connolly on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@class GameScene;

@interface InputLayer : CCLayer {
    CGPoint leftAnalogStickLocation;
    CGPoint rightAnalogStickLocation;

    CGPoint vel;
}

- (void)doTouch:(CGPoint)location;

- (void)setLoop;

@end