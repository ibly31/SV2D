//
//  WeaponList.m
//  Survival2D
//
//  Created by Billy Connolly on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WeaponList.h"


@implementation WeaponList
@synthesize masterList;

static WeaponList *w_instance = nil;

+ (WeaponList *)instance{
    @synchronized(self){
        if(w_instance == nil){
            w_instance = [[self alloc] init];
        }
    }
    return w_instance;
}

- (id)init{
    self = [super init];
    if(self){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"WeaponList" ofType:@"plist"];
        masterList = [[NSArray alloc] initWithContentsOfFile: path];
    }
    return self;
}

- (NSDictionary *)getDataForWeapon:(NSString *)weapon{
    for(int x = 0; x < [masterList count]; x++){
        NSDictionary *weaponData = [masterList objectAtIndex: x];
        if([weapon compare:[weaponData objectForKey: @"Name"]] == NSOrderedSame){
            return weaponData;
        }
    }
    return [masterList objectAtIndex: 0];
}

- (int)getNumberForWeapon:(NSString *)weapon{
    for(int x = 0; x < [masterList count]; x++){
        NSDictionary *weaponData = [masterList objectAtIndex: x];
        if([weapon compare:[weaponData objectForKey: @"Name"]] == NSOrderedSame){
            return x;
        }
    }
    return 0;
}

@end
