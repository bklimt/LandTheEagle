//
//  BKTheme.h
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/15/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//
//  This source code is licensed as described in the LICENSE file in the root directory of this
//  source tree.
//

#import <Foundation/Foundation.h>

@interface BKTheme : NSObject

+ (instancetype)defaultTheme;

- (instancetype)nextTheme;

- (NSString *)fileNameForImage:(NSString *)image;

@end
