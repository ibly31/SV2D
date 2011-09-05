//
//  AnalogLocator.h
//  Survival2D
//
//  Created by Billy Connolly on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface AnalogLocator : CCLayerColor {
    CCSprite *analogStick;
    
    int width,height;
}

@property (nonatomic, retain) CCSprite *analogStick;

- (id)initWithWidth:(int)w height:(int)h;
- (BOOL)containsTouchLocation:(UITouch *)touch;

-(void)doTouch:(CGPoint)location;

@end
