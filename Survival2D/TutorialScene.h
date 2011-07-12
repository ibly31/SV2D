//
//  TutorialScene.h
//  Survival2D
//
//  Created by Billy Connolly on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "PowerupHUD.h"
#import "Weapon.h"

@interface TutorialScene : CCLayer {
    
    CCSprite *player;
    Weapon *weapon;
    CCSprite *laser;
    
    CCSprite *enemy;
    CCSprite *powerup;
    
    CCSprite *leftAnalogStick;
    CCSprite *rightAnalogStick;
    
    CCLabelAtlas *ammoLabel;
    CCLabelAtlas *healthLabel;
    
    CCSprite *reloadButton;
    PowerupHUD *powerupHUD;
    CCSprite *tutorialText;
    
    CCLayer *touchLayer;
    
    CCLabelTTF *currentText;
    
    NSArray *slideTexts;
    int currentSlide;
    
    BOOL ableToContinue;
}

+ (id)scene;

- (void)resetAbleToContinue;
- (void)rotatePlayer;

@property (nonatomic, retain) CCSprite *player;
@property (nonatomic, retain) Weapon *weapon;
@property (nonatomic, retain) CCSprite *laser;

@property (nonatomic, retain) CCSprite *enemy;
@property (nonatomic, retain) CCSprite *powerup;

@property (nonatomic, retain) CCSprite *leftAnalogStick;
@property (nonatomic, retain) CCSprite *rightAnalogStick;

@property (nonatomic, retain) CCLabelAtlas *ammoLabel;
@property (nonatomic, retain) CCLabelAtlas *healthLabel;

@property (nonatomic, retain) CCSprite *reloadButton;
@property (nonatomic, retain) PowerupHUD *powerupHUD;
@property (nonatomic, retain) CCSprite *tutorialText;

@property (nonatomic, retain) CCLabelTTF *currentText;

@property (nonatomic, retain) NSArray *slideTexts;

- (void)offsetCurrentSlide:(int)offset;

@end
