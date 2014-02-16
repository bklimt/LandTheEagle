//
//  BKButton.m
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/14/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//

#import "BKButton.h"

@interface BKButton ()

@property (nonatomic, retain) SKShapeNode *rectNode;

@end

@implementation BKButton

+ (instancetype)buttonWithText:(NSString *)text
                    atPosition:(int)position
                    withScreen:(CGRect)screen {
    int y = CGRectGetMidY(screen) - 90;
    CGRect rect = CGRectMake(40, y - 70 * position, screen.size.width - 80, 48);
    return [BKButton buttonWithText:text inRect:rect];
}

+ (instancetype)buttonWithText:(NSString *)text inRect:(CGRect)rect {
    BKButton *node = [BKButton node];

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);

    node.rectNode = [[SKShapeNode alloc] init];
    node.rectNode.path = path;
    node.rectNode.fillColor = [UIColor whiteColor];

    SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
    labelNode.text = text;
    labelNode.fontSize = 24;
    labelNode.position = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect) + 15);
    labelNode.fontColor = [UIColor blueColor];

    [node addChild:node.rectNode];
    [node addChild:labelNode];

    CGPathRelease(path);

    return node;
}

- (BOOL)isTouchedInScene:(SKScene *)scene withTouches:(NSSet *)touches {
    if (self.isHidden) {
        return NO;
    }

    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self.rectNode];
        if (CGPathContainsPoint(self.rectNode.path, NULL, location, YES)) {
            return YES;
        }
    }
    return NO;
}

@end
