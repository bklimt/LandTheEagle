//
//  BKButton.h
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/14/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BKButton : SKNode

+ (instancetype)buttonWithText:(NSString *)text inRect:(CGRect)rect;

- (BOOL)isTouchedInScene:(SKScene *)scene withTouches:(NSSet *)touches;

+ (instancetype)buttonWithText:(NSString *)text
                    atPosition:(int)position
                    withScreen:(CGRect)screen;
@end
