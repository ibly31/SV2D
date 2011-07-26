//
//  SoundEffectButton.h
//  Survival2D
//
//  Created by Billy Connolly on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface SoundEffectButton : CCSprite <CCTargetedTouchDelegate>{
    BOOL stateOn;
}

- (id)initialize;
- (BOOL)containsTouchLocation:(UITouch *)touch;

@end
