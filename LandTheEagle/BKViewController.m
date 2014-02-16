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

@implementation BKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SKView *skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;

    SKScene *scene = [BKSplashScene sceneWithSize:skView.bounds.size];
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
