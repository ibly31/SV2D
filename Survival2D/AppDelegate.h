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
    BOOL gameModeWave;
    float shootTime;
    int analogStickPixelOffsetX;
    int analogStickPixelOffsetY;
}

@property (nonatomic, retain) UIWindow *window;
@property BOOL gameModeWave;

- (BOOL)soundEffects;
- (float)shootTime;
- (int)analogStickPixelOffsetX;
- (int)analogStickPixelOffsetY;
- (void)setSoundEffects:(BOOL)se;
- (void)setShootTime:(float)st;
- (void)setAnalogStickPixelOffsetX:(int)aspo;
- (void)setAnalogStickPixelOffsetY:(int)aspo;

@end
