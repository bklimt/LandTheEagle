//
//  BKShip.m
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/14/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//

#import "BKShip.h"

#import "Constants.h"

@interface BKShip ()
@property (nonatomic, retain) SKNode *flame;
//@property (nonatomic, retain) SKNode *explosion;
@end

@implementation BKShip

+ (instancetype)ship {
    BKShip *ship = [[BKShip alloc] init];

    ship.flame = [SKSpriteNode spriteNodeWithImageNamed:@"flame.png"];
    ship.flame.scale = 0.08;
    ship.flame.position = CGPointMake(0, -20);
    [ship addChild:ship.flame];

    SKNode *lander = [SKSpriteNode spriteNodeWithImageNamed:@"lander.png"];
    lander.scale = 0.18;
    [ship addChild:lander];

    ship.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:13.0];
    ship.physicsBody.affectedByGravity = YES;
    ship.physicsBody.dynamic = YES;
    ship.physicsBody.mass = 10.0;
    ship.physicsBody.restitution = 0.01;
    ship.physicsBody.friction = 10.0;
    ship.physicsBody.angularDamping = 5.0;
    ship.physicsBody.categoryBitMask = kCategoryShip;
    ship.physicsBody.collisionBitMask = kCategoryLandFlat | kCategoryLandSloped;
    ship.physicsBody.contactTestBitMask = kCategoryLandFlat | kCategoryLandSloped;

    //ship.explosion = [SKSpriteNode spriteNodeWithImageNamed:@"flame.png"];
    //ship.explosion.scale = 0.001;
    //ship.explosion.position = CGPointMake(0, -20);

    return ship;
}

- (void)boost {
    [self.physicsBody applyImpulse:CGVectorMake(0, 400)];

    SKAction *flareOut = [SKAction scaleTo:0.15 duration:0.2];
    SKAction *flareIn = [SKAction scaleTo:0.08 duration:0.2];
    SKAction *flare = [SKAction sequence:@[flareOut, flareIn]];
    [self.flame runAction:flare withKey:@"flare"];
}

- (void)turnOff {
    SKAction *flareOff = [SKAction scaleTo:0.01 duration:0.2];
    [self.flame runAction:flareOff withKey:@"flare"];
}

- (void)explode {
    /*if (!self.explosion.parent) {
        [self addChild:self.explosion];
    }
    SKAction *engulf = [SKAction scaleTo:0.4 duration:1.0];
    [self.explosion runAction:engulf];
    */

    SKAction *fallOver = [SKAction rotateToAngle:-M_PI_2 duration:1.0];
    [self runAction:fallOver];
}

@end
