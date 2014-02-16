//
//  BKMyScene.h
//  LandTheEagle
//

//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class BKTheme;

@interface BKSplashScene : SKScene

+ (instancetype)splashSceneWithSize:(CGSize)size theme:(BKTheme *)theme;

@end
