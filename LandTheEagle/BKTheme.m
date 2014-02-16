//
//  BKTheme.m
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/15/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//

#import "BKTheme.h"

@interface BKTheme ()

@property NSString *prefix;

@end

@implementation BKTheme

+ (instancetype)defaultTheme {
    return [[BKTheme alloc] initWithPrefix:@""];
}

- (instancetype)nextTheme {
    if ([self.prefix isEqualToString:@""]) {
        return [[BKTheme alloc] initWithPrefix:@"ios7_"];
    } else {
        return [[BKTheme alloc] initWithPrefix:@""];
    }
}

- (instancetype)initWithPrefix:(NSString *)prefix {
    if (self = [super init]) {
        self.prefix = prefix;
    }
    return self;
}

- (NSString *)fileNameForImage:(NSString *)image {
    return [NSString stringWithFormat:@"%@%@.png", self.prefix, image];
}

@end
