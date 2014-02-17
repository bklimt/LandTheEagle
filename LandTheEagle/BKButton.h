//
//  BKButton.h
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/14/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//
//  This source code is licensed as described in the LICENSE file in the root directory of this
//  source tree.
//

#import <SpriteKit/SpriteKit.h>

@interface BKButton : SKNode

+ (instancetype)buttonWithText:(NSString *)text inRect:(CGRect)rect;

+ (instancetype)buttonWithText:(NSString *)text
                    atPosition:(int)position
                    withScreen:(CGRect)screen;

- (BOOL)isTouched:(NSSet *)touches;

- (void)setText:(NSString *)text;

@end
