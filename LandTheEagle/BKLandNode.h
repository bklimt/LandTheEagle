//
//  BKLandNode.h
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/10/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//
//  This source code is licensed as described in the LICENSE file in the root directory of this
//  source tree.
//

#import <SpriteKit/SpriteKit.h>

#import "Constants.h"

@class BKLandStrip;
@class BKTheme;

@interface BKLandNode : SKNode {
    BOOL moving;
    int currentRow;
    BKLandStrip *strips[kLandTotalTiles];
}

+ (instancetype)landNodeWithLevel:(int)level theme:(BKTheme *)theme;

- (void)startMoving;
- (void)stopMoving;

@end
