//
//  TTGridView.m
//  TicTacToe
//
//  Created by Andy Sweeny on 6/2/14.
//  Copyright (c) 2014 Andy Sweeny. All rights reserved.
//

#import "TTGridView.h"

#import "TTGridSquareView.h"

@interface TTGridView()

@property (nonatomic, strong) NSArray *squareViews;

@end

@implementation TTGridView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeSquareViews];
    }
    return self;
}

- (void)initializeSquareViews {
    NSMutableArray *rows = [NSMutableArray new];
    self.squareViews = rows;
    
    TTGridSquareView *previousSquareView = nil;
    BOOL isOriginalSquare = YES;
    
    for (NSInteger rowIdx = 0; rowIdx < 3; rowIdx++) {
        NSMutableArray *row = [NSMutableArray new];
        [rows addObject:row];
        for (NSInteger columnIdx = 0; columnIdx < 3; columnIdx++) {
            TTGridSquareView *squareView = [[TTGridSquareView alloc] initWithRow:rowIdx column:columnIdx];
            
            [squareView setBackgroundColor:[UIColor clearColor]];
            
            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(squareViewTapped:)];
            [squareView addGestureRecognizer:gestureRecognizer];
            
            [row addObject:squareView];
            
            [squareView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addSubview:squareView];
            
            [self addConstraint:
             [NSLayoutConstraint constraintWithItem:squareView
                                          attribute:NSLayoutAttributeHeight
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self
                                          attribute:NSLayoutAttributeHeight
                                         multiplier:(1.0/3.0)
                                           constant:0]];
            [self addConstraint:
             [NSLayoutConstraint constraintWithItem:squareView
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                         attribute:NSLayoutAttributeWidth
                                        multiplier:(1.0/3.0)
                                          constant:0]];
            
            if (isOriginalSquare) {
                NSDictionary *views = NSDictionaryOfVariableBindings(squareView);
                NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[squareView]" options:0 metrics:nil views:views];
                NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[squareView]" options:0 metrics:nil views:views];
                [self addConstraints:horizontalConstraints];
                [self addConstraints:verticalConstraints];
            } else {
                // first square in row
                if (columnIdx == 0) {
                    NSDictionary *views = NSDictionaryOfVariableBindings(squareView, previousSquareView);
                    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[squareView]" options:0 metrics:nil views:views];
                    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[previousSquareView][squareView]" options:0 metrics:nil views:views];
                    [self addConstraints:horizontalConstraints];
                    [self addConstraints:verticalConstraints];
                } else {
                    NSDictionary *views = NSDictionaryOfVariableBindings(squareView, previousSquareView);
                    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[previousSquareView][squareView]" options:0 metrics:nil views:views];
                    NSArray *topAlignment = @[[NSLayoutConstraint constraintWithItem:squareView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousSquareView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
                    [self addConstraints:horizontalConstraints];
                    [self addConstraints:topAlignment];
                }
            }
            previousSquareView = squareView;
            isOriginalSquare = NO;
        }
    }
}

- (void)squareViewTapped:(UIGestureRecognizer *)sender {
    TTGridSquareView *squareView = (TTGridSquareView *)sender.view;
    if (self.delegate) {
        [self.delegate gridView:self didSelectSquareAtRow:squareView.row column:squareView.column];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGRect bounds = self.bounds;

    CGFloat length = bounds.size.width;
    CGFloat offset = length / 3;
    
    [[UIColor blackColor] setStroke];
    
    CGContextSetLineWidth(context, 5.0);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, offset, 0);
    CGContextAddLineToPoint(context, offset, length);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, offset*2, 0);
    CGContextAddLineToPoint(context, offset*2, length);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 0, offset);
    CGContextAddLineToPoint(context, length, offset);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 0, offset*2);
    CGContextAddLineToPoint(context, length, offset*2);
    CGContextStrokePath(context);
}

- (void)setGridSquareValue:(TTGridSquareValue)gridSquareValue atRow:(NSInteger)row column:(NSInteger)column {
    TTGridSquareView *squareView = (TTGridSquareView *)[[self.squareViews objectAtIndex:row] objectAtIndex:column];
    [squareView setValue:gridSquareValue];
}

- (void)clear {
    for (NSArray *row in self.squareViews) {
        for (TTGridSquareView *squareView in row) {
            [squareView setValue:TTGridSquareValueNone];
        }
    }
    [self setNeedsDisplay];
}

@end
