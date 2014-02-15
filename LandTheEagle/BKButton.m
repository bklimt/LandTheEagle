//
//  BKButton.m
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/14/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//

#import "BKButton.h"

@implementation BKButton

+ (instancetype)buttonWithText:(NSString *)text inRect:(CGRect)rect {

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);

    SKShapeNode *rectNode = [[SKShapeNode alloc] init];
    rectNode.path = path;
    rectNode.fillColor = [UIColor whiteColor];

    SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    labelNode.text = text;
    labelNode.fontSize = 18;
    labelNode.position = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect) + 10);
    labelNode.fontColor = [UIColor blueColor];

    BKButton *node = [BKButton node];
    [node addChild:rectNode];
    [node addChild:labelNode];

    CGPathRelease(path);

    return node;
}

- (BOOL)isTouchedInScene:(SKScene *)scene withTouches:(NSSet *)touches {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:scene];
        for (SKNode *node in [scene nodesAtPoint:location]) {
            if (node == self) {
                return YES;
            }
        }
    }
    return NO;
}

@end
