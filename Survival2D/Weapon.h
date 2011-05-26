//
//  Weapon.h
//  Survival2D
//
//  Created by Billy Connolly on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface Weapon : CCSprite {
    
    NSString *name;
    
    int maxAmmo;
    int currentMagazine;
    int magazineCount;
    int damage;
    int shots;
    int penetration;
    float reloadTime;
    float delay;
    float recoil;
    
    int offset;
    int flashPos;
}

@property (nonatomic, retain) NSString *name;

- (id)initWithName:(NSString *)w_name;

- (int)shoot;

- (int)getMaxAmmo;
- (void)setMagazineCount:(int)mc;
- (int)getCurrentMagazine;
- (void)setCurrentMagazine:(int)cm;
- (int)getMagazineCount;
- (int)getDamage;
- (int)getShots;
- (int)getPenetration;
- (float)getReloadTime;
- (float)getDelay;
- (float)getRecoil;
- (CGPoint)getOffset;
- (int)getFlashPos;

@end
