//
//  TTBoard.h
//  TicTacToe
//
//  Created by Andy Sweeny on 6/4/14.
//  Copyright (c) 2014 Andy Sweeny. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TTPlayerX = 1,
    TTPlayerO = -1,
    TTPlayerNone = 0
} TTPlayer;

@interface TTBoardIndex : NSObject

@property (nonatomic) NSInteger row;
@property (nonatomic) NSInteger column;

+ (TTBoardIndex *)boardIndexForRow:(NSInteger)row column:(NSInteger)column;

@end

@interface TTBoard : NSObject

@property (nonatomic, readonly) NSArray *winningSquares;

+ (TTBoard *)copyBoard:(TTBoard *)board;

- (TTPlayer)playerAtBoardIndex:(TTBoardIndex *)boardIndex;
- (BOOL)completeWithWinner:(TTPlayer *)winner;

- (void)setPlayer:(TTPlayer)player atBoardIndex:(TTBoardIndex *)boardIndex;

- (void)iterateBoardUsingBlock:(void (^)(TTBoardIndex *boardIndex, TTPlayer player, BOOL *stop))block;

@end
