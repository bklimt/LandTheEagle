//
//  BKLandStrip.m
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/14/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//
//  This source code is licensed as described in the LICENSE file in the root directory of this
//  source tree.
//

#import "BKLandStrip.h"

#import "BKTheme.h"
#import "Constants.h"

@interface BKLandStrip ()
@end

@implementation BKLandStrip

+ (instancetype)landStripWithTopDelta:(int)delta
                                    X:(int)x
                                    Y:(int)y
                           tileHeight:(int)tileHeight
                                count:(int)count
                                theme:(BKTheme *)theme {
    BKLandStrip *strip = [[BKLandStrip alloc] init];
    for (int i = 0; i < count; ++ i) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, -kLandTileWidth/2, -kLandTileWidth/2);
        CGPathAddLineToPoint(path, NULL, kLandTileWidth/2, -kLandTileWidth/2);

        NSString *image;
        if (i) {
            image = @"surface_small";
            CGPathAddLineToPoint(path, NULL, kLandTileWidth/2, kLandTileWidth/2);
            CGPathAddLineToPoint(path, NULL, -kLandTileWidth/2, kLandTileWidth/2);
        } else if (delta < 0) {
            image = @"surface_top_bottom";
            CGPathAddLineToPoint(path, NULL, -kLandTileWidth/2, kLandTileWidth/2);
        } else if (delta > 0) {
            image = @"surface_bottom_top";
            CGPathAddLineToPoint(path, NULL, kLandTileWidth/2, kLandTileWidth/2);
        } else {
            image = @"surface_top_top";
            CGPathAddLineToPoint(path, NULL, kLandTileWidth/2, kLandTileWidth/2);
            CGPathAddLineToPoint(path, NULL, -kLandTileWidth/2, kLandTileWidth/2);
        }
        CGPathCloseSubpath(path);
        image = [theme fileNameForImage:image];

        SKNode *tile = [SKSpriteNode spriteNodeWithImageNamed:image];
        tile.scale = 0.375;
        tile.position = CGPointMake(x, y - i * tileHeight);
        tile.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        tile.physicsBody.affectedByGravity = NO;
        tile.physicsBody.dynamic = NO;
        tile.physicsBody.friction = 10;
        tile.physicsBody.categoryBitMask = (delta ? kCategoryLandSloped : kCategoryLandFlat);
        [strip addChild:tile];

        CGPathRelease(path);
    }
    return strip;
}

@end
