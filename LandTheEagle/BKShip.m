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
@property (nonatomic, retain) SKEffectNode *effect;
@end

@implementation BKShip

+ (instancetype)shipWithTheme:(BKTheme *)theme {
    return [[BKShip alloc] initWithTheme:theme];
}

- (instancetype)initWithTheme:(BKTheme *)theme {
    if (self = [super init]) {
        self.effect = [SKEffectNode node];
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setDefaults];
        self.effect.filter = filter;
        [self addChild:self.effect];

        self.flame = [SKSpriteNode spriteNodeWithImageNamed:[theme fileNameForImage:@"flame"]];
        self.flame.scale = 0.08;
        self.flame.position = CGPointMake(0, -20);
        [self.effect addChild:self.flame];

        SKNode *lander = [SKSpriteNode spriteNodeWithImageNamed:[theme fileNameForImage:@"lander"]];
        lander.scale = 0.18;
        [self.effect addChild:lander];

        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:13.0];
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.dynamic = YES;
        self.physicsBody.mass = 10.0;
        self.physicsBody.restitution = 0.01;
        self.physicsBody.friction = 10.0;
        self.physicsBody.angularDamping = 5.0;
        self.physicsBody.categoryBitMask = kCategoryShip;
        self.physicsBody.collisionBitMask = kCategoryLandFlat | kCategoryLandSloped;
        self.physicsBody.contactTestBitMask = kCategoryLandFlat | kCategoryLandSloped;

        self.playThrustSound = [SKAction playSoundFileNamed:@"thrust.mp3" waitForCompletion:NO];
    }
    return self;
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

- (void)blur:(float)radius {
    self.effect.shouldEnableEffects = YES;
    [self.effect.filter setValue:@(radius) forKey:@"inputRadius"];
}

- (void)unblur {
    self.effect.shouldEnableEffects = NO;
}

@end
