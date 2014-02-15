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

        CGRect buttonRect = CGRectMake(40, 150, self.frame.size.width - 80, 48);
        self.startButton = [BKButton buttonWithText:@"Start" inRect:buttonRect];
        [self addChild:self.startButton];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.startButton isTouchedInScene:self withTouches:touches]) {
        SKView *skView = (SKView *)self.view;
        BKLandingScene *scene = [BKLandingScene landingSceneWithSize:skView.bounds.size level:0];
        [skView presentScene:scene];
    }
}

-(void)update:(CFTimeInterval)currentTime {
}

@end
