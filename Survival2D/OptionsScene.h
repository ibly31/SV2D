//
//  OptionsScene.h
//  Survival2D
//
//  Created by Billy Connolly on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "SoundEffectButton.h"
#import "AnalogLocator.h"

@interface OptionsScene : CCLayer{
    SoundEffectButton *seb;
    CCSprite *endArrow;
    CCUIViewWrapper *slider;
    
    CCLabelTTF *shootTimeLabel;
    
    AnalogLocator *analogLocator;
    
    CCLabelTTF *howToUseLabel;
    
    BOOL flagForFromMenu;
}

+(id) scene;

@property (nonatomic, retain) SoundEffectButton *seb;
@property (nonatomic, retain) CCSprite *endArrow;
@property (nonatomic, retain) CCUIViewWrapper *slider;
@property (nonatomic, retain) CCLabelTTF *shootTimeLabel;
@property (nonatomic, retain) AnalogLocator *analogLocator;
@property (nonatomic, retain) CCLabelTTF *howToUseLabel;

@property BOOL flagForFromMenu;

-(IBAction)sliderChange:(UISlider*)sender;

@end
