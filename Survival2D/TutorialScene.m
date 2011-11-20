//
//  TutorialScene.m
//  Survival2D
//
//  Created by Billy Connolly on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TutorialScene.h"
#import "MainMenuScene.h"
#import "AppDelegate.h"

@implementation TutorialScene
@synthesize player;
@synthesize weapon;
@synthesize laser;
@synthesize enemy;
@synthesize powerup;
@synthesize rightArrow;
@synthesize endArrow;
@synthesize pauseButton;
@synthesize switchButton;
@synthesize leftAnalogStick;
@synthesize rightAnalogStick;
@synthesize ammoLabel;
@synthesize healthLabel;
@synthesize powerupHUD;
@synthesize tutorialText;
@synthesize currentText;
@synthesize slideTexts;

+(id) scene{
    CCScene *scene = [CCScene node];
    TutorialScene *layer = [TutorialScene node];
    [scene addChild: layer];
    return scene;
}

- (id)init{
    self = [super init];
    [self setIsTouchEnabled: YES];
    if(self){
        
        CCLayerColor *backgroundColor = [CCLayerColor layerWithColor:ccc4(125, 125, 125, 255)];
        [self addChild: backgroundColor];
        
        self.player = [[CCSprite alloc] initWithFile:@"Playersheet.png" rect: CGRectMake(0, 0, 64, 64)];
        [player setPosition: ccp(240.0f, 160.0f)];
        [player setOpacity: 0];
        [self addChild: player];
        
        self.weapon = [[Weapon alloc] initWithName: @"Assault Rifle"];
        [weapon setPosition: [player position]];
        [weapon setOpacity: 0];
        [self addChild: weapon];
        
        self.laser = [[CCSprite alloc] initWithFile: @"LaserAnimated.png"];
        [laser setAnchorPoint: ccp(0.5f, 0.0f)];
        [laser setPosition: [weapon convertToWorldSpace: ccp(weapon.contentSize.width / 2, weapon.contentSize.height - [weapon getFlashPos])]];
        [laser setScaleY: 6.25f];
        [laser setOpacity: 0];
        [self addChild: laser];
        
        self.enemy = [[CCSprite alloc] initWithFile:@"Foodsheet.png" rect: CGRectMake(0, 0, 32, 32)];
        [enemy setPosition: ccp(160.0f, 160.0f)];
        [enemy setOpacity: 0];
        [self addChild: enemy];
        
        self.powerup = [[CCSprite alloc] initWithFile:@"Foodsheet.png" rect: CGRectMake(224, 0, 160, 32)];
        [powerup setPosition: ccp(240.0f, 100.0f)];
        [powerup setOpacity: 0];
        [self addChild: powerup];
                
        self.leftAnalogStick = [[CCSprite alloc] initWithFile:@"GuiSheet.png" rect:CGRectMake(0, 0, 128, 128)];
        [leftAnalogStick setPosition: ccp(84.0f, 84.0f)];
        [leftAnalogStick setOpacity: 0];
        [self addChild: leftAnalogStick];
        
        self.rightAnalogStick = [[CCSprite alloc] initWithFile:@"GuiSheet.png" rect:CGRectMake(0, 0, 128, 128)];
        [rightAnalogStick setPosition: ccp(396.0f, 84.0f)];
        [rightAnalogStick setOpacity: 0];
        [self addChild: rightAnalogStick];
        
        self.powerupHUD = [[PowerupHUD alloc] init];
        [powerupHUD setPosition: ccp(8.0f, 192.0f)];
        [[powerupHUD pupBack] setOpacity: 0];
        [self addChild: powerupHUD];
        
        self.ammoLabel = [[[CCLabelAtlas alloc] initWithString:@"30/120" charMapFile:@"Font.png" itemWidth:16 itemHeight:24 startCharMap:','] retain];
        [ammoLabel setAnchorPoint: ccp(0.0f, 1.0f)];
        [ammoLabel setPosition: ccp(0.0f, 320.0f)];
        [ammoLabel setOpacity: 0];
        [self addChild: ammoLabel];
        
        self.healthLabel = [[[CCLabelAtlas alloc] initWithString:@"-100" charMapFile:@"Font.png" itemWidth:16 itemHeight:24 startCharMap:','] retain];
        [healthLabel setAnchorPoint: ccp(1.0f, 1.0f)];
        [healthLabel setPosition: ccp(480.0f, 320.0f)];
        [healthLabel setOpacity: 0];
        [self addChild: healthLabel];
        
        self.tutorialText = [[CCSprite alloc] initWithFile: @"TutorialText.png"];
        [tutorialText setPosition: ccp(240.0f, 240.0f)];
        [self addChild: tutorialText];
        
        self.currentText = [[CCLabelTTF alloc] initWithString:@"" dimensions:CGSizeMake(256.0f, 60.0f) alignment:UITextAlignmentCenter fontName:@"Arial" fontSize:16.0f];
        [currentText setColor: ccc3(0, 0, 0)];
        [currentText setAnchorPoint:ccp(0.5f, 1.0f)];
        [currentText setPosition: ccp(240.0f, 270.0f)];
        [self addChild: currentText];
        
        self.rightArrow = [[CCSprite alloc] initWithFile:@"GuiSheet.png" rect:CGRectMake(128, 0, 64, 64)];
        [rightArrow setPosition: ccp(476.0f, 170.0f)];
        [rightArrow setAnchorPoint: ccp(1.0f, 0.5f)];
        [self addChild: rightArrow];
        
        self.endArrow = [[CCSprite alloc] initWithFile:@"GuiSheet.png" rect:CGRectMake(128, 64, 64, 64)];
        [endArrow setPosition: ccp(240.0f, 4.0f)];
        [endArrow setAnchorPoint: ccp(0.5f, 0.0f)];
        [self addChild: endArrow];
        
        self.pauseButton = [[CCSprite alloc] initWithFile: @"GuiSheet.png" rect:CGRectMake(192, 0, 64, 24)];
        [pauseButton setAnchorPoint: ccp(0.5f, 1.0f)];
        [pauseButton setPosition: ccp(192.0f, 320.0f)];
        [pauseButton setOpacity: 0];
        [self addChild: pauseButton];
        
        self.switchButton = [[CCSprite alloc] initWithFile: @"GuiSheet.png" rect:CGRectMake(192, 24, 64, 24)];
        [switchButton setAnchorPoint: ccp(0.5f, 1.0f)];
        [switchButton setPosition: ccp(288.0f, 320.0f)];
        [switchButton setOpacity: 0];
        [self addChild: switchButton];
        
        NSString *string00 = @"Welcome to the Food Zombies\ntutorial. To advance, tap the right\nbutton. Bottom button exits.";
        NSString *string01 = @"Playing Food Zombies is simple.\nYour character is in the center\nof the screen. Keep him alive!";
        NSString *string02 = @"There are various unhealthy foods\nthat can harm you. Try to\navoid touching them.";
        NSString *string03 = @"If an enemy or enemies touches\nyou, you will lose health. Your\nhealth is displayed right here.";
        NSString *string04 = @"To move around the map and\navoid enemies, use the left\nanalog stick.";
        NSString *string05 = @"The direction of your finger\nrelative to the center of the stick\nis the direction you move.";
        NSString *string06 = @"You can move faster by moving\nyour finger farther from the center\nof the analog stick.";
        NSString *string07 = @"To aim your weapon, use the\nright analog stick. The laser\nwill help you aim accurately.";
        NSString *string08 = @"To shoot your weapon, keep your\nfinger on the right analog\nstick for a short time.";
        NSString *string09 = @"This feature makes it easy\nto adjust aim before firing and\nconserve ammo.";
        NSString *string10 = @"To disable or tweak\nthis feature, please go to the\n options in the main menu.";
        NSString *string11 = @"Speaking of ammo, your current\nammo counter is displayed\nright here.";
        NSString *string12 = @"These are powerups. Powerups\ncome in the form of\nhealthy foods.";
        NSString *string13 = @"Powerups allow you to\ncombat the food zombies\nin special ways.";
        NSString *string14 = @"You can have 3 active powerups\n at a time. The oldest powerup is\nreplaced by new ones.";
        NSString *string15 = @"The Strawberry freezes all the\nzombies in place for\nten seconds.";
        NSString *string16 = @"The Apple gives a health boost\nof twenty. This is the most\ncommon powerup.";
        NSString *string17 = @"The Orange gives max ammo to\nthe weapon currently being\nheld.";
        NSString *string18 = @"The Banana gives a speed boost\nfor 10 seconds. This will\nmake you harder to kill.";
        NSString *string19 = @"The Grapes give unlimited ammo\nfor 10 seconds. It also makes your\nbullets hit harder.";
        NSString *string20 = @"While using the grape powerup,\ntry using the flamethrower.\nYou'll be in for a surprise.";
        NSString *string21 = @"If you want to pause the game\npress the pause button in the\nupper left of the screen.";
        NSString *string22 = @"This is the switch weapon\nbutton. Tap it to cycle through\nthe available weapons.";
        NSString *string23 = @"Thank you for watching the\ntutorial! To exit to the menu, tap\nthe bottom exit button.";
        
        slideTexts = [[NSArray alloc] initWithObjects:string00, string01, string02, string03, string04, string05, string06, string07, string08,
                      string09, string10, string11, string12, string13, string14, string15, string16, string17, string18, string19, string20, string21, string22, string23, nil];
        
        [currentText setString: [slideTexts objectAtIndex: currentSlide]];
        
        ableToContinue = YES;
    }
    return self;
}

- (void)rotatePlayer{
    [player setRotation: [player rotation] + 1.0f];
    [weapon setRotation: [player rotation]];
    [laser setRotation: [player rotation]];
    [laser setPosition: [weapon convertToWorldSpace: ccp(weapon.contentSize.width / 2, weapon.contentSize.height - [weapon getFlashPos])]];
}

- (void)resetAbleToContinue{
    [self unschedule: @selector(resetAbleToContinue)];
    ableToContinue = YES;
}

- (void)exitToMenu{
    CCScene *mms = [MainMenuScene scene];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene:mms]];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(ableToContinue){
        UITouch *touch = [touches anyObject];
        CGPoint location = [[CCDirector sharedDirector] convertToGL: [touch locationInView: touch.view]];
        if(location.x > 304){
            [self offsetCurrentSlide: 1];
        }else if(location.x > 176.0f && location.y < 74.0f){
            [self exitToMenu];
        }
    }
}

- (void)offsetCurrentSlide:(int)offset{
    currentSlide += offset;
    if(currentSlide < 0){
        currentSlide = 0;
    }
    if(currentSlide > [slideTexts count] - 1){
        currentSlide = [slideTexts count] - 1;
    }else{
        [currentText setString: [slideTexts objectAtIndex: currentSlide]];
        [currentText runAction: [CCSequence actions:[CCScaleTo actionWithDuration:0.1f scale:0.8f], [CCScaleTo actionWithDuration:0.1f scale:1.0f], nil]];
        ableToContinue = NO;
        [self schedule:@selector(resetAbleToContinue) interval:0.1f];
        
        switch(currentSlide){
            case 1:
                [player runAction: [CCFadeTo actionWithDuration:0.5f opacity:255]];
                [weapon runAction: [CCFadeTo actionWithDuration:0.5f opacity:255]];
                break;
            case 2:
                [enemy runAction: [CCFadeTo actionWithDuration:0.5f opacity:255]];
                CCAnimation *enemyAnimation = [CCAnimation animationWithFrames:nil delay:0.75f];
                for(int x = 0; x < 7; x++){
                    CGRect frame = CGRectMake(x * 32, 0, 32, 32);
                    [enemyAnimation addFrame:[CCSpriteFrame frameWithTexture:[enemy texture] rect:frame]];
                }
                [enemy runAction: [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:enemyAnimation restoreOriginalFrame:NO]]];
                break;
            case 3:
                [healthLabel runAction: [CCFadeTo actionWithDuration:0.5f opacity:255]];
                [healthLabel runAction: [CCSequence actions: [CCScaleTo actionWithDuration:0.25f scale:3.0f], [CCScaleTo actionWithDuration:0.25f scale:1.0f], nil]];
                break;
            case 4:
                [leftAnalogStick runAction: [CCFadeTo actionWithDuration:0.5f opacity:255]];
                break;
            case 7:
                [self schedule:@selector(rotatePlayer) interval:0.01f];
                [rightAnalogStick runAction: [CCFadeTo actionWithDuration:0.5f opacity:255]];
                [laser setOpacity: 255];
                CCAnimation *laserAnimation = [CCAnimation animationWithFrames: nil delay: .05f];
                for(int x = 0; x < 8; x++){
                    CGRect frame = CGRectMake(x, 0.0f, 1.0f, 64.0f);
                    [laserAnimation addFrame: [CCSpriteFrame frameWithTexture:[laser texture] rect: frame]];
                }
                [laser runAction: [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation: laserAnimation]]];
                break;
            case 11:
                [ammoLabel runAction: [CCFadeTo actionWithDuration:0.5f opacity:255]];
                [ammoLabel runAction: [CCSequence actions: [CCScaleTo actionWithDuration:0.25f scale:3.0f], [CCScaleTo actionWithDuration:0.25f scale:1.0f], nil]];
                break;
            case 12:
                [powerup runAction: [CCFadeTo actionWithDuration:0.5f opacity:255]];
                break;
            case 14:
                [[powerupHUD pupBack] runAction: [CCFadeTo actionWithDuration:0.5f opacity:255]];
                break;
            case 15:
                [powerupHUD slotPup:0 withChangedIndex:0 withPositionOnScreen:ccp(176.0f, 100.0f) withOpacity:255];
                break;
            case 16:
                [powerupHUD slotPup:1 withChangedIndex:1 withPositionOnScreen:ccp(208.0f, 100.0f) withOpacity:255];
                break;
            case 17:
                [powerupHUD slotPup:2 withChangedIndex:2 withPositionOnScreen:ccp(240.0f, 100.0f) withOpacity:255];
                break;
            case 18:
                [powerupHUD slotPup:3 withChangedIndex:0 withPositionOnScreen:ccp(272.0f, 100.0f) withOpacity:255];
                break;
            case 19:
                [powerupHUD slotPup:4 withChangedIndex:1 withPositionOnScreen:ccp(304.0f, 100.0f) withOpacity:255];
                break;
            case 21:
                [pauseButton runAction: [CCFadeTo actionWithDuration:0.5f opacity:255]];
                [pauseButton runAction: [CCSequence actions: [CCScaleTo actionWithDuration:0.25f scale:2.0f], [CCScaleTo actionWithDuration:0.25f scale:1.0f], nil]];
                break;
            case 22:
                [switchButton runAction: [CCFadeTo actionWithDuration:0.5f opacity:255]];
                [switchButton runAction: [CCSequence actions: [CCScaleTo actionWithDuration:0.25f scale:2.0f], [CCScaleTo actionWithDuration:0.25f scale:1.0f], nil]];
                break;
        }
    }
}

@end
