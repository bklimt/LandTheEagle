//
//  BKShip.h
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/14/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class BKTheme;

@interface BKShip : SKNode

+ (instancetype)shipWithTheme:(BKTheme *)theme;

- (void)startFalling;
- (void)boost;
- (void)turnOff;
- (void)explode;
- (void)blur:(float)radius;
- (void)unblur;

@end
