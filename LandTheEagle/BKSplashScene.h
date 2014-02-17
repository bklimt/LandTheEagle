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

@interface BKSplashScene : SKScene

+ (instancetype)splashSceneWithSize:(CGSize)size theme:(BKTheme *)theme;

@end
