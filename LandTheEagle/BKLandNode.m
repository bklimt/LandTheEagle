//
//  BKLandNode.m
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/10/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//

#import "BKLandNode.h"

#import "BKLandStrip.h"
#import "Constants.h"

@interface BKLandNode ()
@property (nonatomic) int level;
@property (nonatomic) float flatProbability;
@end

@implementation BKLandNode

+ (instancetype)landNodeWithLevel:(int)level {
    return [[BKLandNode alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(int)level {
    if (self = [super init]) {
        self.level = level;

        self.flatProbability = 1.0 - (self.level / (float)kLevels);
        if (self.flatProbability > 0.9) {
            self.flatProbability = 0.9;
        }
        NSLog(@"Probability of flat ground is %f.", self.flatProbability);

        currentRow = kLandMaxHeight / 2;
        for (int i = 0; i < kLandTotalTiles; ++i) {
            [self appendTile:i];
        }

        [self startMoving];
    }
    return self;
}

- (void)startMoving {
    if (moving) {
        return;
    }
    moving = YES;

    float speed = 0.3 + ((1.0 - (self.level / (float)kLevels)) * 0.4);
    NSLog(@"Ground is moving at %f Hz.", speed);

    SKAction *moveLeft = [SKAction moveToX:(-kLandTileWidth) duration:speed];
    SKAction *addTile = [SKAction runBlock:^{
        [self addNewTile];
    }];
    SKAction *moveLeftAndAddTile = [SKAction sequence:@[moveLeft, addTile]];
    SKAction *moveLeftForever = [SKAction repeatActionForever:moveLeftAndAddTile];

    [self runAction:moveLeftForever withKey:@"runLeftForever"];
}

- (void)stopMoving {
    [self removeActionForKey:@"runLeftForever"];
    moving = NO;
}

- (void)addNewTile {
    CGPoint point = self.position;
    point.x += kLandTileWidth;
    self.position = point;
    [strips[0] removeFromParent];
    for (int i = 0; i < (kLandTotalTiles - 1); ++i) {
        strips[i] = strips[i + 1];
        point = strips[i].position;
        point.x -= kLandTileWidth;
        strips[i].position = point;
    }
    [self appendTile:(kLandTotalTiles - 1)];
}

- (void)appendTile:(int)position {
    int delta;
    if ((rand() % 100) < (int)(self.flatProbability * 100)) {
        delta = 0;
    } else {
        if (rand() % 2) {
            delta = -1;
        } else {
            delta = 1;
        }
    }

    if (currentRow < 1 && delta < 0) {
        delta = 0;
    }
    if (currentRow > kLandMaxHeight && delta > 0) {
        delta = 0;
    }
    if (delta > 0) {
        currentRow++;
    }
    int y = kLandYMin + currentRow * kLandTileWidth;

    int x = kLandTileWidth / 2 + position * kLandTileWidth;

    BKLandStrip *strip = [BKLandStrip landStripWithTopDelta:delta
                                                          X:x
                                                          Y:y
                                                 tileHeight:kLandTileWidth
                                                      count:(currentRow + 1)];
    strips[position] = strip;
    [self addChild:strip];

    if (delta < 0) {
        currentRow--;
    }
}

@end
