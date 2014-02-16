//
//  BKLandingScene.m
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/10/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//

#import "BKSplashScene.h"

#import "BKButton.h"
#import "BKLandingScene.h"
#import "BKLandNode.h"

@interface BKSplashScene ()
@property (nonatomic, retain) BKButton *startButton;
@property (nonatomic, retain) BKButton *resumeButton;
@end

@implementation BKSplashScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.scaleMode = SKSceneScaleModeAspectFill;
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];

        CGPoint center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));

        SKNode *space = [SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
        space.position = center;
        space.scale = 1.0;
        [self addChild:space];

        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        myLabel.text = @"Land the Eagle!";
        myLabel.fontSize = 30;
        myLabel.position = center;
        [self addChild:myLabel];

        BKLandNode *land = [BKLandNode landNodeWithLevel:(kLevels / 2)];
        [self addChild:land];

        self.startButton = [BKButton buttonWithText:@"Start" atPosition:0 withScreen:self.frame];
        [self addChild:self.startButton];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int level = [defaults integerForKey:kDefaultLevel];
        NSLog(@"Previous level was %d.", level + 1);

        self.resumeButton = [BKButton buttonWithText:@"Resume" atPosition:1 withScreen:self.frame];
        [self addChild:self.resumeButton];
        self.resumeButton.hidden = !level;

        SKAction *playBackgroundSound =
            [SKAction playSoundFileNamed:@"music.mp3" waitForCompletion:NO];
        SKAction *waitForSixteenSeconds = [SKAction waitForDuration:18];
        playBackgroundSound = [SKAction sequence:@[playBackgroundSound, waitForSixteenSeconds]];
        playBackgroundSound = [SKAction repeatActionForever:playBackgroundSound];
        [self runAction:playBackgroundSound];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    if ([self.startButton isTouchedInScene:self withTouches:touches]) {
        NSLog(@"Pushed start button.");
        SKView *skView = (SKView *)self.view;
        BKLandingScene *scene = [BKLandingScene landingSceneWithSize:skView.bounds.size level:0];
        [skView presentScene:scene];
    }

    if ([self.resumeButton isTouchedInScene:self withTouches:touches]) {
        NSLog(@"Pushed resume button.");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int level = [defaults integerForKey:kDefaultLevel];
        NSLog(@"Resuming at level %d.", level + 1);

        SKView *skView = (SKView *)self.view;
        BKLandingScene *scene = [BKLandingScene landingSceneWithSize:skView.bounds.size level:level];
        [skView presentScene:scene];
    }
}

-(void)update:(CFTimeInterval)currentTime {
}

@end
