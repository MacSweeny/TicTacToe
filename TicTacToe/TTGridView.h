//
//  TTGridView.h
//  TicTacToe
//
//  Created by Andy Sweeny on 6/2/14.
//  Copyright (c) 2014 Andy Sweeny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TTGridSquareValueX = 1,
    TTGridSquareValueO = 2,
    TTGridSquareValueNone = 0
} TTGridSquareValue;

@protocol TTGridViewDelegate;

@interface TTGridView : UIView

@property (weak, nonatomic) id<TTGridViewDelegate> delegate;

- (void)setGridSquareValue:(TTGridSquareValue)value atRow:(NSInteger)row column:(NSInteger)column;

@end

@protocol TTGridViewDelegate <NSObject>

- (void)gridView:(TTGridView *)gridView didSelectSquareAtRow:(NSInteger)row column:(NSInteger)column;

@end