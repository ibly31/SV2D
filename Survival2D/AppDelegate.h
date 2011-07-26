//
//  AppDelegate.h
//  Survival2D
//
//  Created by Billy Connolly on 5/15/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    BOOL soundEffects;
}

@property (nonatomic, retain) UIWindow *window;

- (BOOL)soundEffects;
- (void)setSoundEffects:(BOOL)se;

@end
