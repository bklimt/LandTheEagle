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
#import "BKTheme.h"
#import "BKViewController.h"
#import "Constants.h"

static const int kStateWaiting = 0;
static const int kStateLanding = 1;
static const int kStateWon = 2;
static const int kStateLost = 3;

@interface BKLandingScene ()
@property (nonatomic, retain) BKTheme *theme;

@property (nonatomic, retain) BKShip *ship;
@property (nonatomic, retain) BKLandNode *land;

@property (nonatomic, retain) SKLabelNode *levelLabel;
@property (nonatomic, retain) SKLabelNode *speedLabel;
@property (nonatomic, retain) SKLabelNode *fuelLabel;
@property (nonatomic, retain) SKLabelNode *youWonLabel;
@property (nonatomic, retain) SKLabelNode *youLostLabel;
@property (nonatomic, retain) SKNode *explanationLabel;

@property (nonatomic, retain) BKButton *youWonButton;
@property (nonatomic, retain) BKButton *retryButton;
@property (nonatomic, retain) BKButton *giveUpButton;

@property (nonatomic) int level;
@property (nonatomic) BOOL tooFast;
@property (nonatomic) int fuel;
@property (nonatomic) int state;
@end

@implementation BKLandingScene

+ (instancetype)landingSceneWithSize:(CGSize)size level:(int)level theme:(BKTheme *)theme {
    return [[BKLandingScene alloc] initWithSize:size level:level theme:theme];
}

-(id)initWithSize:(CGSize)size level:(int)level theme:(BKTheme *)theme {
    if (self = [super initWithSize:size]) {
        self.level = level;
        self.theme = theme;

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:level forKey:kDefaultLevel];

        self.state = kStateWaiting;

        self.scaleMode = SKSceneScaleModeAspectFill;
        self.backgroundColor = [SKColor colorWithRed:0.4
                                               green:0.4
                                                blue:0.6
                                               alpha:1.0];

        self.physicsWorld.gravity = CGVectorMake(0, -0.7);
        self.physicsWorld.contactDelegate = self;

        self.fuel = 100 - 80 * (self.level / (float)kLevels);

        CGPoint center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        SKNode *space = [SKSpriteNode spriteNodeWithImageNamed:[theme fileNameForImage:@"background"]];
        space.position = center;
        space.scale = 1.0;
        [self addChild:space];

        self.land = [BKLandNode landNodeWithLevel:self.level theme:theme];
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

        self.ship = [BKShip shipWithTheme:theme];
        self.ship.position = shipStart;
        [self addChild:self.ship];
        
        self.youWonLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        self.youWonLabel.text = @"You landed!";
        self.youWonLabel.fontSize = 40;
        self.youWonLabel.fontColor = [UIColor whiteColor];
        self.youWonLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                                CGRectGetMidY(self.frame));
        self.youWonLabel.hidden = YES;
        [self addChild:self.youWonLabel];

        self.youLostLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        self.youLostLabel.text = @"You crashed.";
        self.youLostLabel.fontSize = 40;
        self.youLostLabel.fontColor = [UIColor whiteColor];
        self.youLostLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                                 CGRectGetMidY(self.frame));
        self.youLostLabel.hidden = YES;
        [self addChild:self.youLostLabel];

        self.retryButton = [BKButton buttonWithText:@"Retry" atPosition:0 withScreen:self.frame];
        self.retryButton.hidden = YES;
        [self addChild:self.retryButton];

        self.giveUpButton = [BKButton buttonWithText:@"Give Up" atPosition:1 withScreen:self.frame];
        self.giveUpButton.hidden = YES;
        [self addChild:self.giveUpButton];

        self.youWonButton = [BKButton buttonWithText:@"Next Level" atPosition:0 withScreen:self.frame];
        self.youWonButton.hidden = YES;
        [self addChild:self.youWonButton];


        self.explanationLabel = [SKNode node];

        SKLabelNode *touchToThrust = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        touchToThrust.text = @"Touch to thrust.";
        touchToThrust.fontSize = 30;
        touchToThrust.fontColor = [UIColor whiteColor];
        touchToThrust.position = CGPointMake(CGRectGetMidX(self.frame),
                                             CGRectGetMaxY(self.frame) - 230);
        [self.explanationLabel addChild:touchToThrust];

        SKLabelNode *landWhereFlat = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        landWhereFlat.text = @"Land where flat.";
        landWhereFlat.fontSize = 30;
        landWhereFlat.fontColor = [UIColor whiteColor];
        landWhereFlat.position = CGPointMake(CGRectGetMidX(self.frame),
                                             CGRectGetMaxY(self.frame) - 280);
        [self.explanationLabel addChild:landWhereFlat];

        SKLabelNode *notTooFast = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        notTooFast.text = @"Not too fast.";
        notTooFast.fontSize = 30;
        notTooFast.fontColor = [UIColor whiteColor];
        notTooFast.position = CGPointMake(CGRectGetMidX(self.frame),
                                          CGRectGetMaxY(self.frame) - 330);
        [self.explanationLabel addChild:notTooFast];

        [self addChild:self.explanationLabel];

        SKAction *playBackgroundSound =
            [SKAction playSoundFileNamed:@"ambiance.mp3" waitForCompletion:NO];
        SKAction *waitForThirtySeconds = [SKAction waitForDuration:30];
        playBackgroundSound = [SKAction sequence:@[playBackgroundSound, waitForThirtySeconds]];
        playBackgroundSound = [SKAction repeatActionForever:playBackgroundSound];
        [self runAction:playBackgroundSound];
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
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            BOOL hasWon = [defaults boolForKey:kDefaultWon];

            self.youWonLabel.text = @"You win!";
            if (hasWon) {
                self.youWonButton.text = @"Start Over";
            } else {
                self.youWonButton.text = @"Unlock Ivy Theme";
            }

            [defaults setBool:YES forKey:kDefaultWon];
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
        case kStateWaiting: {
            self.state = kStateLanding;
            [self.ship startFalling];
            [self.explanationLabel runAction:[SKAction fadeOutWithDuration:0.5]];
            break;
        }
        case kStateLanding: {
            if (self.fuel > 0) {
                self.fuel -= 1;
                [self.ship boost];
                self.fuelLabel.text = [NSString stringWithFormat:@"Fuel: %d", self.fuel];
            }
            break;
        }
        case kStateWon: {
            if ([self.youWonButton isTouched:touches]) {
                int nextLevel = self.level + 1;
                if (nextLevel >= kLevels) {
                    NSLog(@"The game is won.");
                    SKView *view = self.view;
                    BKTheme *theme = [self.theme nextTheme];
                    BKSplashScene *scene = [BKSplashScene splashSceneWithSize:view.frame.size
                                                                        theme:theme];
                    SKTransition *transition = [SKTransition fadeWithDuration:0.1];
                    [view presentScene:scene transition:transition];

                } else {
                    SKView *view = self.view;
                    BKLandingScene *scene = [BKLandingScene landingSceneWithSize:view.frame.size
                                                                           level:nextLevel
                                                                           theme:self.theme];
                    SKTransition *transition = [SKTransition fadeWithDuration:0.1];
                    [view presentScene:scene transition:transition];
                }
            }
            break;
        }
        case kStateLost: {
            if ([self.giveUpButton isTouched:touches]) {
                SKView *view = self.view;
                BKSplashScene *scene = [BKSplashScene splashSceneWithSize:view.frame.size
                                                                    theme:self.theme];
                SKTransition *transition = [SKTransition fadeWithDuration:0.1];
                [view presentScene:scene transition:transition];

            } else if ([self.retryButton isTouched:touches]) {
                SKView *view = self.view;
                BKLandingScene *scene = [BKLandingScene landingSceneWithSize:view.frame.size
                                                                       level:self.level
                                                                       theme:self.theme];
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

    if (dy > 2.5 && self.state == kStateLanding) {
        double radius = ((dy - 2.5) * 2.0);
        if (radius > 3.0) {
            radius = 3.0;
        }

        if (!self.filter) {
            CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
            [filter setDefaults];
            self.filter = filter;
        }
        [self.filter setValue:@(radius) forKey:@"inputRadius"];

        self.shouldEnableEffects = YES;
    } else {
        self.shouldEnableEffects = NO;
    }

    self.speedLabel.text = [NSString stringWithFormat:@"Speed: %d", (int32_t)dy];
    self.speedLabel.fontColor = (self.tooFast ? [UIColor redColor] : [UIColor whiteColor]);
}

@end
