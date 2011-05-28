//
//  Weapon.m
//  Survival2D
//
//  Created by Billy Connolly on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Weapon.h"
#import "WeaponList.h"

@implementation Weapon
@synthesize name;

- (id)initWithName:(NSString *)w_name{
    
    NSDictionary *weaponData = [[WeaponList instance] getDataForWeapon: w_name];
    int weaponNumber = [[WeaponList instance] getNumberForWeapon: w_name];
    CGRect textureRect = CGRectMake((weaponNumber % 32) * 8, (int)(weaponNumber / 32), 8, 48);
    
    self = [super initWithFile:@"WeaponSpritesheet.png" rect:textureRect];
    if(self){
        offset = [[weaponData objectForKey: @"OffsetY"] intValue];
        [self setAnchorPoint: ccp(0.5f - (8 / self.contentSize.width), 0.5f - (offset / self.contentSize.height))];
        
        name = w_name;
        maxAmmo = [[weaponData objectForKey: @"MaxAmmo"] intValue];
        damage = [[weaponData objectForKey: @"Damage"] intValue];
        penetration = [[weaponData objectForKey: @"Penetration"] intValue];
        weaponType = [[weaponData objectForKey: @"WeaponType"] intValue];
        currentMagazine = maxAmmo;
        magazineCount = 4;
        reloadTime = [[weaponData objectForKey: @"ReloadTime"] floatValue];
        delay = 60.0f / [[weaponData objectForKey: @"RPM"] floatValue];
        recoil = [[weaponData objectForKey: @"Recoil"] floatValue];
        flashPos = [[weaponData objectForKey: @"FlashPos"] intValue];
    }
    return self;
}

- (int)shoot{
    if(magazineCount == 0 && currentMagazine == 0){
        return 0;                                           /// Completely empty
    }else{
        if(currentMagazine > 0){
            currentMagazine--;                              /// Fired properly
            return 1;
        }else if(currentMagazine == 0){
            return 2;                                       /// Time to reload
        }
    }
    return 0;
}

- (int)getMaxAmmo{
    return maxAmmo;
}
- (void)setMagazineCount:(int)mc{
    magazineCount = mc;
}
- (int)getMagazineCount{
    return magazineCount;
}
- (void)setCurrentMagazine:(int)cm{
    currentMagazine = cm;
}
- (int)getCurrentMagazine{
    return currentMagazine;
}
- (int)getWeaponType{
    return weaponType;
}
- (int)getDamage{
    return damage;
}
- (int)getPenetration{
    return penetration;
}
- (float)getReloadTime{
    return reloadTime;
}
- (float)getDelay{
    return delay;
}
- (float)getRecoil{
    return recoil;
}
- (CGPoint)getOffset{
    return ccp(8, offset);
}
- (int)getFlashPos{
    return flashPos;
}

@end