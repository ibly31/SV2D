//
//  WeaponList.h
//  Survival2D
//
//  Created by Billy Connolly on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface WeaponList : NSObject {
    NSArray *masterList;
}

@property (nonatomic, retain) NSArray *masterList;

+ (WeaponList *)instance;

- (id)init;
- (NSDictionary *)getDataForWeapon:(NSString *)weapon;
- (int)getNumberForWeapon:(NSString *)weapon;

@end
