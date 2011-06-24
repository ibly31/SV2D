//
//  PowerupHUD.m
//  Survival2D
//
//  Created by Billy Connolly on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PowerupHUD.h"

@implementation PowerupHUD
@synthesize pupBack;
@synthesize pup0;
@synthesize pup1;
@synthesize pup2;

- (id)init{
    self = [super init];
    if(self){
        self.pupBack = [[CCSprite alloc] initWithFile:@"PowerupBack.png"];
        [pupBack setAnchorPoint: ccp(0.0f, 0.5f)];
        [self addChild: pupBack];
        
        self.pup0 = [[CCSprite alloc] initWithFile:@"Foodsheet.png" rect:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        self.pup1 = [[CCSprite alloc] initWithFile:@"Foodsheet.png" rect:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        self.pup2 = [[CCSprite alloc] initWithFile:@"Foodsheet.png" rect:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
        [pup0 setOpacity: 0];
        [pup1 setOpacity: 0];
        [pup2 setOpacity: 0];
        [pup0 setPosition: ccp(17.0f, 33.0f)];
        [pup1 setPosition: ccp(17.0f, 0.0f)];
        [pup2 setPosition: ccp(17.0f, -33.0f)];
        [self addChild: pup0];
        [self addChild: pup1];
        [self addChild: pup2];
        
    }
    return self;
}

- (void)slotPup:(int)type withChangedIndex:(int)index withPositionOnScreen:(CGPoint)positionOnScreen withOpacity:(int)opa{
    positionOnScreen = [self convertToNodeSpace: positionOnScreen];
    switch(index){
        case 0:
            [pup0 stopAllActions];
            [pup0 setOpacity: opa];
            [pup0 setPosition: positionOnScreen];
            [pup0 runAction: [CCMoveTo actionWithDuration:0.5f position: ccp(17.0f, 33.0f)]];
            [pup0 runAction: [CCFadeTo actionWithDuration:0.5f opacity: 255]];
            [pup0 setDisplayFrame: [CCSpriteFrame frameWithTexture:[pup0 texture] rect:CGRectMake((type + 7) * 32, 0, 32, 32)]];
            break;
        case 1:
            [pup1 stopAllActions];
            [pup1 setOpacity: opa];
            [pup1 setPosition: positionOnScreen];
            [pup1 runAction: [CCMoveTo actionWithDuration:0.5f position: ccp(17.0f, 0.0f)]];
            [pup1 runAction: [CCFadeTo actionWithDuration:0.5f opacity: 255]];
            [pup1 setDisplayFrame: [CCSpriteFrame frameWithTexture:[pup1 texture] rect:CGRectMake((type + 7) * 32, 0, 32, 32)]];
            break;
        case 2:
            [pup2 stopAllActions];
            [pup2 setOpacity: opa];
            [pup2 setPosition: positionOnScreen];
            [pup2 runAction: [CCMoveTo actionWithDuration:0.5f position: ccp(17.0f, -33.0f)]];
            [pup2 runAction: [CCFadeTo actionWithDuration:0.5f opacity: 255]];
            [pup2 setDisplayFrame: [CCSpriteFrame frameWithTexture:[pup2 texture] rect:CGRectMake((type + 7) * 32, 0, 32, 32)]];
            break;
        default:
            NSAssert(YES, @"PupDefault1!");
            break;
    }
}

- (void)unslotPup:(int)type withChangedIndex:(int)index{
    switch(index){
        case 0:
            [pup0 stopAllActions];
            [pup0 setOpacity: 255];
            [pup0 runAction: [CCFadeTo actionWithDuration:0.3f opacity:0]];
            break;
        case 1:
            [pup1 stopAllActions];
            [pup1 setOpacity: 255];
            [pup1 runAction: [CCFadeTo actionWithDuration:0.3f opacity:0]];
            break;
        case 2:
            [pup2 stopAllActions];
            [pup2 setOpacity: 255];
            [pup2 runAction: [CCFadeTo actionWithDuration:0.3f opacity:0]];
            break;
        default:
            NSAssert(YES, @"PupDefault2!");
            break;
    }
}

@end
