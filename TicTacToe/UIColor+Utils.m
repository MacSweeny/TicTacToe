//
//  UIColor+Utils.m
//  TicTacToe
//
//  Created by Andy Sweeny on 6/5/14.
//  Copyright (c) 2014 Andy Sweeny. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

- (UIColor *)deSaturate {
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    
    if([self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha]) {
        UIColor *newColor = [UIColor colorWithHue:hue saturation:.2f brightness:brightness alpha:alpha];
        return newColor;
    } else {
        return self;
    }
}

@end
