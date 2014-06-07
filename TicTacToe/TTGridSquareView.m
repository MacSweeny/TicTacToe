//
//  TTGridSquareView.m
//  TicTacToe
//
//  Created by Andy Sweeny on 6/2/14.
//  Copyright (c) 2014 Andy Sweeny. All rights reserved.
//

#import "TTGridSquareView.h"

const CGFloat LineWidthScaleOfRadius = 0.3;

@implementation TTGridSquareView

- (id)initWithRow:(NSInteger)row column:(NSInteger)column {
    if (self = [super init]) {
        _row = row;
        _column = column;
        _value = TTGridSquareValueNone;
    }
    return self;
}

- (void)highlightSquare {
    if (self.value == TTGridSquareValueX) {
        [self setBackgroundColor:[[UIColor blueColor] deSaturate]];
        [self setNeedsDisplay];
    } else if (self.value == TTGridSquareValueO) {
        [self setBackgroundColor:[[UIColor redColor] deSaturate]];
        [self setNeedsDisplay];
    }
}

- (void)clearHighlight {
    [self setBackgroundColor:[UIColor clearColor]];
    [self setNeedsDisplay];
}

- (void)drawXAtPoint:(CGPoint)point radius:(CGFloat)radius context:(CGContextRef)context {
    
    CGFloat lineWidth = radius * LineWidthScaleOfRadius;
    
    CGContextSetLineWidth(context, lineWidth);
    [[UIColor blueColor] setStroke];
    
    CGContextMoveToPoint(context, point.x - radius, point.y - radius);
    CGContextAddLineToPoint(context, point.x + radius, point.y + radius);
    
    CGContextMoveToPoint(context, point.x - radius, point.y + radius);
    CGContextAddLineToPoint(context, point.x + radius, point.y - radius);
    
    CGContextStrokePath(context);
}

- (void)drawCircleAtPoint:(CGPoint)point radius:(CGFloat)radius context:(CGContextRef)context {
    
    CGFloat lineWidth = radius * LineWidthScaleOfRadius;
    
    CGContextSetLineWidth(context, lineWidth);
    [[UIColor redColor] setStroke];
    
    CGContextBeginPath(context);
    
    CGContextAddArc(context, point.x, point.y, radius, 0, 2 * M_PI, 0);
    
    CGContextStrokePath(context);
}

- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    
    CGPoint center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.value == TTGridSquareValueX) {
        [self drawXAtPoint:center radius:bounds.size.width/3 context:context];
    } else if (self.value == TTGridSquareValueO) {
        [self drawCircleAtPoint:center radius:bounds.size.width/3 context:context];
    }
    
}

- (void)setValue:(TTGridSquareValue)value {
    _value = value;
    [self setNeedsDisplay];
}

@end
