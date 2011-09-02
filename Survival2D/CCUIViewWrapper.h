//
//  CCUIViewWrapper.h
//  Survival2D
//
//  Created by Billy Connolly on 9/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface CCUIViewWrapper : CCSprite
{
	UIView *uiItem;
	float rotation;
}

@property (nonatomic, retain) UIView *uiItem;

+ (id) wrapperForUIView:(UIView*)ui;
- (id) initForUIView:(UIView*)ui;

- (void) updateUIViewTransform;

@end