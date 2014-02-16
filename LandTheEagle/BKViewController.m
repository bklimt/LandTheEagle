//
//  BKViewController.m
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/10/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//

#import "BKViewController.h"
#import "BKLandingScene.h"
#import "BKSplashScene.h"
#import "BKTheme.h"

@implementation BKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SKView *skView = (SKView *)self.view;
    // skView.showsFPS = YES;
    // skView.showsNodeCount = YES;

    // iPad 3 is 768 x 1024.
    // iPhone 5 is 320 x 568.
    float width = skView.bounds.size.width;
    float height = skView.bounds.size.height;
    NSLog(@"Screen is %f x %f.", width, height);

    // Let's scale everything to the size of an iPhone 5.
    float aspectRatio = width / height;
    if (height != 568 || width != 320 || (568 * aspectRatio > 320)) {
        height = 568;
        width = 568 * aspectRatio;
    } else {
        width = 320;
        height = width / aspectRatio;
    }
    NSLog(@"Pretending the screen is %f x %f.\n", width, height);
    CGSize size = CGSizeMake(width, height);

    BKTheme *theme = [BKTheme defaultTheme];
    SKScene *scene = [BKSplashScene splashSceneWithSize:size theme:theme];
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
