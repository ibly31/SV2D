//
//  PowerupHUD.h
//  Survival2D
//
//  Created by Billy Connolly on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Player.h"

@interface PowerupHUD : CCNode {
    CCSprite *pupBack;
    
    CCSprite *pup0;
    CCSprite *pup1;
    CCSprite *pup2;
    
}
@property (nonatomic, retain) CCSprite *pupBack;
@property (nonatomic, retain) CCSprite *pup0;
@property (nonatomic, retain) CCSprite *pup1;
@property (nonatomic, retain) CCSprite *pup2;

- (void)slotPup:(int)type withChangedIndex:(int)index withPositionOnScreen:(CGPoint)positionOnScreen withOpacity:(int)opa;
- (void)unslotPup:(int)type withChangedIndex:(int)index;

@end
