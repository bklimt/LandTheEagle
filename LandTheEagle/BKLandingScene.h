//
//  BKMyScene.h
//  LandTheEagle
//
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//
//  This source code is licensed as described in the LICENSE file in the root directory of this
//  source tree.
//

#import <SpriteKit/SpriteKit.h>

@class BKTheme;

@interface BKLandingScene : SKScene<SKPhysicsContactDelegate>

+ (instancetype)landingSceneWithSize:(CGSize)size level:(int)level theme:(BKTheme *)theme;

@end
