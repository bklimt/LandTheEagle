//
//  BKLandingScene.m
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/10/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//

#import "BKLandingScene.h"

#import "BKButton.h"
#import "BKLandNode.h"
#import "BKShip.h"
#import "BKSplashScene.h"
#import "BKViewController.h"
#import "Constants.h"

static const int kStateLanding = 1;
static const int kStateWon = 2;
static const int kStateLost = 3;

@interface BKLandingScene ()
@property (nonatomic, retain) BKShip *ship;
@property (nonatomic, retain) BKLandNode *land;

@property (nonatomic, retain) SKLabelNode *levelLabel;
@property (nonatomic, retain) SKLabelNode *speedLabel;
@property (nonatomic, retain) SKLabelNode *fuelLabel;
@property (nonatomic, retain) SKLabelNode *youWonLabel;
@property (nonatomic, retain) SKLabelNode *youLostLabel;

@property (nonatomic, retain) BKButton *youWonButton;
@property (nonatomic, retain) BKButton *retryButton;
@property (nonatomic, retain) BKButton *giveUpButton;

@property (nonatomic) int level;
@property (nonatomic) BOOL tooFast;
@property (nonatomic) int fuel;
@property (nonatomic) int state;
@end

@implementation BKLandingScene

+ (instancetype)landingSceneWithSize:(CGSize)size level:(int)level {
    return [[BKLandingScene alloc] initWithSize:size level:level];
}

-(id)initWithSize:(CGSize)size level:(int)level {
    if (self = [super initWithSize:size]) {
        self.level = level;

        self.state = kStateLanding;

        self.scaleMode = SKSceneScaleModeAspectFill;
        self.backgroundColor = [SKColor colorWithRed:0.4
                                               green:0.4
                                               blue:0.6
                                               alpha:1.0];

        self.physicsWorld.gravity = CGVectorMake(0, -0.7);
        self.physicsWorld.contactDelegate = self;

        self.fuel = 100 - 70 * (self.level / (float)kLevels);

        CGPoint center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        SKNode *space = [SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
        space.position = center;
        space.scale = 1.0;
        [self addChild:space];

        self.land = [BKLandNode landNodeWithLevel:self.level];
        [self addChild:self.land];

        self.levelLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        self.levelLabel.text = [NSString stringWithFormat:@"Level: %d", (self.level + 1)];
        self.levelLabel.fontSize = 25;
        self.levelLabel.fontColor = [UIColor whiteColor];
        self.levelLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                               CGRectGetMaxY(self.frame) - 50);
        [self addChild:self.levelLabel];

        self.speedLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        self.speedLabel.text = @"Speed: 0";
        self.speedLabel.fontSize = 25;
        self.speedLabel.fontColor = [UIColor whiteColor];
        self.speedLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                               CGRectGetMaxY(self.frame) - 80);
        [self addChild:self.speedLabel];

        self.fuelLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        self.fuelLabel.text = [NSString stringWithFormat:@"Fuel: %d", self.fuel];
        self.fuelLabel.fontSize = 25;
        self.fuelLabel.fontColor = [UIColor whiteColor];
        self.fuelLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                              CGRectGetMaxY(self.frame) - 110);
        [self addChild:self.fuelLabel];

        CGPoint shipStart = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 20);

        self.ship = [BKShip ship];
        self.ship.position = shipStart;
        [self addChild:self.ship];
        
        self.youWonLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        self.youWonLabel.text = @"You landed!";
        self.youWonLabel.fontSize = 40;
        self.youWonLabel.fontColor = [UIColor whiteColor];
        self.youWonLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                                CGRectGetMaxY(self.frame) - 300);
        self.youWonLabel.hidden = YES;
        [self addChild:self.youWonLabel];

        self.youLostLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        self.youLostLabel.text = @"You crashed.";
        self.youLostLabel.fontSize = 40;
        self.youLostLabel.fontColor = [UIColor whiteColor];
        self.youLostLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                                 CGRectGetMaxY(self.frame) - 300);
        self.youLostLabel.hidden = YES;
        [self addChild:self.youLostLabel];

        CGRect button1Rect = CGRectMake(40, 200, self.frame.size.width - 80, 48);
        CGRect button2Rect = CGRectMake(40, 120, self.frame.size.width - 80, 48);

        self.retryButton = [BKButton buttonWithText:@"Retry" inRect:button1Rect];
        self.retryButton.hidden = YES;
        [self addChild:self.retryButton];

        self.giveUpButton = [BKButton buttonWithText:@"Give Up" inRect:button2Rect];
        self.giveUpButton.hidden = YES;
        [self addChild:self.giveUpButton];

        self.youWonButton = [BKButton buttonWithText:@"Next Level" inRect:button1Rect];
        self.youWonButton.hidden = YES;
        [self addChild:self.youWonButton];
    }
    return self;
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    if (self.state != kStateLanding) {
        return;
    }

    if ((contact.bodyA.categoryBitMask & kCategoryLandSloped) ||
        (contact.bodyB.categoryBitMask & kCategoryLandSloped) ||

        self.tooFast) {
        self.state = kStateLost;
        [self.ship explode];

        self.youLostLabel.hidden = NO;

        SKAction *wait = [SKAction waitForDuration:1.0];
        [self runAction:wait completion:^{
            self.retryButton.hidden = NO;
            self.retryButton.alpha = 0.0;

            self.giveUpButton.hidden = NO;
            self.giveUpButton.alpha = 0.0;

            SKAction *fadeIn = [SKAction fadeInWithDuration:0.5];
            [self.retryButton runAction:fadeIn];
            [self.giveUpButton runAction:fadeIn];
        }];

    } else {
        self.state = kStateWon;
        [self.land stopMoving];
        [self.ship turnOff];

        int nextLevel = self.level + 1;
        self.youWonLabel.hidden = NO;
        if (nextLevel >= kLevels) {
            self.youWonLabel.text = @"You win!";
            return;
        }

        SKAction *wait = [SKAction waitForDuration:1.0];
        [self runAction:wait completion:^{
            self.youWonButton.hidden = NO;
            self.youWonButton.alpha = 0.0;
            SKAction *fadeIn = [SKAction fadeInWithDuration:0.5];
            [self.youWonButton runAction:fadeIn];
        }];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    switch (self.state) {
        case kStateLanding: {
            if (self.fuel > 0) {
                self.fuel -= 1;
                [self.ship boost];
                self.fuelLabel.text = [NSString stringWithFormat:@"Fuel: %d", self.fuel];
            }
            break;
        }
        case kStateWon: {
            if ([self.youWonButton isTouchedInScene:self withTouches:touches]) {
                int nextLevel = self.level + 1;
                if (nextLevel >= kLevels) {
                    // You've beaten the game!
                } else {
                    SKView *view = self.view;
                    BKLandingScene *scene = [BKLandingScene landingSceneWithSize:view.frame.size
                                                                           level:nextLevel];
                    SKTransition *transition = [SKTransition fadeWithDuration:0.1];
                    [view presentScene:scene transition:transition];
                }
            }
            break;
        }
        case kStateLost: {
            if ([self.giveUpButton isTouchedInScene:self withTouches:touches]) {
                SKView *view = self.view;
                BKSplashScene *scene = [BKSplashScene sceneWithSize:view.frame.size];
                SKTransition *transition = [SKTransition fadeWithDuration:0.1];
                [view presentScene:scene transition:transition];

            } else if ([self.retryButton isTouchedInScene:self withTouches:touches]) {
                SKView *view = self.view;
                BKLandingScene *scene = [BKLandingScene landingSceneWithSize:view.frame.size
                                                                       level:self.level];
                SKTransition *transition = [SKTransition fadeWithDuration:0.1];
                [view presentScene:scene transition:transition];
            }
            break;
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    static const int kSampleCount = 20;
    static float samples[kSampleCount];
    static float sum = 0.0;
    static int i = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        for (int i = 0; i < kSampleCount; ++i) {
            samples[i] = 0.0;
        }
    });

    sum -= samples[i];
    samples[i] = self.ship.physicsBody.velocity.dy / -20;
    sum += samples[i];
    i = (i + 1) % kSampleCount;

    float dy = sum / kSampleCount;
    self.tooFast = (dy >= 3);

    if (self.tooFast) {
        // self.filter = [CIFilter filterWithName:@"CIZoomBlur"];
    }

    self.speedLabel.text = [NSString stringWithFormat:@"Speed: %d", (int32_t)dy];
    self.speedLabel.fontColor = (self.tooFast ? [UIColor redColor] : [UIColor whiteColor]);
}

@end
