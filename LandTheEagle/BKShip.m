//
//  BKShip.m
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/14/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//

#import "BKShip.h"

#import "Constants.h"
#import "BKTheme.h"

@interface BKShip ()
@property (nonatomic, retain) SKNode *flame;
@property (nonatomic, retain) SKAction *playThrustSound;
@end

@implementation BKShip

+ (instancetype)shipWithTheme:(BKTheme *)theme {
    BKShip *ship = [[BKShip alloc] init];

    ship.flame = [SKSpriteNode spriteNodeWithImageNamed:[theme fileNameForImage:@"flame"]];
    ship.flame.scale = 0.08;
    ship.flame.position = CGPointMake(0, -20);
    [ship addChild:ship.flame];

    SKNode *lander = [SKSpriteNode spriteNodeWithImageNamed:[theme fileNameForImage:@"lander"]];
    lander.scale = 0.18;
    [ship addChild:lander];

    ship.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:13.0];
    ship.physicsBody.affectedByGravity = NO;
    ship.physicsBody.dynamic = YES;
    ship.physicsBody.mass = 10.0;
    ship.physicsBody.restitution = 0.01;
    ship.physicsBody.friction = 10.0;
    ship.physicsBody.angularDamping = 5.0;
    ship.physicsBody.categoryBitMask = kCategoryShip;
    ship.physicsBody.collisionBitMask = kCategoryLandFlat | kCategoryLandSloped;
    ship.physicsBody.contactTestBitMask = kCategoryLandFlat | kCategoryLandSloped;

    ship.playThrustSound = [SKAction playSoundFileNamed:@"thrust.mp3" waitForCompletion:NO];

    return ship;
}

- (void)startFalling {
    self.physicsBody.affectedByGravity = YES;
}

- (void)boost {
    [self.physicsBody applyImpulse:CGVectorMake(0, 400)];

    SKAction *flareOut = [SKAction scaleTo:0.15 duration:0.2];
    SKAction *flareIn = [SKAction scaleTo:0.08 duration:0.2];
    SKAction *flare = [SKAction sequence:@[flareOut, flareIn]];
    [self.flame runAction:flare withKey:@"flare"];

    [self runAction:self.playThrustSound];
}

- (void)turnOff {
    SKAction *flareOff = [SKAction scaleTo:0.01 duration:0.2];
    [self.flame runAction:flareOff withKey:@"flare"];
}

- (void)explode {
    SKAction *fallOver = [SKAction rotateToAngle:-M_PI_2 duration:1.0];
    [self runAction:fallOver];
}

@end
