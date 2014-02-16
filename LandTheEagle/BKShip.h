//
//  BKShip.h
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/14/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BKShip : SKNode

+ (instancetype)ship;

- (void)startFalling;
- (void)boost;
- (void)turnOff;
- (void)explode;

@end
