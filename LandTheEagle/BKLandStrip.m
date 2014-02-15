//
//  BKLandStrip.m
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/14/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//

#import "BKLandStrip.h"

#import "Constants.h"

@interface BKLandStrip ()
@end

@implementation BKLandStrip

+ (instancetype)landStripWithTopDelta:(int)delta
                                    X:(int)x
                                    Y:(int)y
                           tileHeight:(int)tileHeight
                                count:(int)count {
    BKLandStrip *strip = [[BKLandStrip alloc] init];
    for (int i = 0; i < count; ++ i) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, -kLandTileWidth/2, -kLandTileWidth/2);
        CGPathAddLineToPoint(path, NULL, kLandTileWidth/2, -kLandTileWidth/2);

        NSString *image;
        if (i) {
            image = @"surface_small.png";
            CGPathAddLineToPoint(path, NULL, kLandTileWidth/2, kLandTileWidth/2);
            CGPathAddLineToPoint(path, NULL, -kLandTileWidth/2, kLandTileWidth/2);
        } else if (delta < 0) {
            image = @"surface_top_bottom.png";
            CGPathAddLineToPoint(path, NULL, -kLandTileWidth/2, kLandTileWidth/2);
        } else if (delta > 0) {
            image = @"surface_bottom_top.png";
            CGPathAddLineToPoint(path, NULL, kLandTileWidth/2, kLandTileWidth/2);
        } else {
            image = @"surface_top_top.png";
            CGPathAddLineToPoint(path, NULL, kLandTileWidth/2, kLandTileWidth/2);
            CGPathAddLineToPoint(path, NULL, -kLandTileWidth/2, kLandTileWidth/2);
        }
        CGPathCloseSubpath(path);

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
