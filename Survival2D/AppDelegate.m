//
//  AppDelegate.m
//  Survival2D
//
//  Created by Billy Connolly on 5/15/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "MainMenuScene.h"
#import "RootViewController.h"

@implementation AppDelegate
@synthesize window;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"SoundEffects"] == nil){
        [self setSoundEffects: YES];
    }
    soundEffects = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SoundEffects"] boolValue];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"ShootTime"] == nil){
        [self setShootTime: 1.0f];
    }
    shootTime = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ShootTime"] floatValue];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"ASPOX"] == nil){
        [self setAnalogStickPixelOffsetX: 84];
    }
    analogStickPixelOffsetX = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ASPOX"] intValue];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"ASPOY"] == nil){
        [self setAnalogStickPixelOffsetY: 84];
    }
    analogStickPixelOffsetY = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ASPOY"] intValue];
  
	if(![CCDirector setDirectorType:kCCDirectorTypeDisplayLink])
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
    [director setDisplayFPS: NO]; ///
	
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;

	EAGLView *glView = [EAGLView viewWithFrame:[window bounds] pixelFormat:kEAGLColorFormatRGB565 depthFormat:0];
	
	[director setOpenGLView:glView];
    [glView setMultipleTouchEnabled: YES];
	
	if(![director enableRetinaDisplay:YES])
		CCLOG(@"Retina Display Not supported");
	
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval: 1/60];
	[director setDisplayFPS:YES];
	
    [viewController setView:glView];
	
	[window addSubview: viewController.view];	
	[window makeKeyAndVisible];
	
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	[self removeStartupFlicker];
	
    CCScene *mms = [MainMenuScene scene];
	[[CCDirector sharedDirector] runWithScene: mms];
}

- (BOOL)soundEffects{
    return soundEffects;
}

- (float)shootTime{
    return shootTime;
}

- (int)analogStickPixelOffsetX{
    return analogStickPixelOffsetX;
}

- (int)analogStickPixelOffsetY{
    return analogStickPixelOffsetY;
}

- (void)setSoundEffects:(BOOL)se{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:se] forKey:@"SoundEffects"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    soundEffects = se;
    NSLog(@"Sound Effects: %@", se ? @"YES" : @"NO");
}

- (void)setShootTime:(float)st{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:st] forKey:@"ShootTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    shootTime = st;
    NSLog(@"Shoot Time: %f", st);
}

- (void)setAnalogStickPixelOffsetX:(int)aspo{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:aspo] forKey:@"ASPOX"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    analogStickPixelOffsetX = aspo;
    NSLog(@"Analog Stick Pixel Offset X: %i", aspo);
}

- (void)setAnalogStickPixelOffsetY:(int)aspo{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:aspo] forKey:@"ASPOY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    analogStickPixelOffsetY = aspo;
    NSLog(@"Analog Stick Pixel Offset Y: %i", aspo);
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	[[director openGLView] removeFromSuperview];
	[viewController release];
	[window release];
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
