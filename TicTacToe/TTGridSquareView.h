//
//  TTGridSquareView.h
//  TicTacToe
//
//  Created by Andy Sweeny on 6/2/14.
//  Copyright (c) 2014 Andy Sweeny. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTGridView.h"

@interface TTGridSquareView : UIView

@property (nonatomic, readonly) NSInteger row;
@property (nonatomic, readonly) NSInteger column;
@property (nonatomic) TTGridSquareValue value;

- (id)initWithRow:(NSInteger)row column:(NSInteger)column;

@end
