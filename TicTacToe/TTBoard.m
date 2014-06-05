//
//  TTBoard.m
//  TicTacToe
//
//  Created by Andy Sweeny on 6/4/14.
//  Copyright (c) 2014 Andy Sweeny. All rights reserved.
//

#import "TTBoard.h"

@implementation TTBoardIndex

+ (TTBoardIndex *)boardIndexForRow:(NSInteger)row column:(NSInteger)column {
    TTBoardIndex *boardIndex = [TTBoardIndex new];
    boardIndex.row = row;
    boardIndex.column = column;
    return boardIndex;
}

@end


@implementation TTBoard {
    NSInteger _squares [3][3];
}

+ (TTBoard *)copyBoard:(TTBoard *)board {
    TTBoard *copy = [TTBoard new];
    [board iterateBoardUsingBlock:^(TTBoardIndex *boardIndex, TTPlayer player, BOOL *stop) {
        [copy setPlayer:player atBoardIndex:boardIndex];
    }];
    return copy;
}

- (TTPlayer)playerAtBoardIndex:(TTBoardIndex *)boardIndex {
    return _squares[boardIndex.row][boardIndex.column];
}

- (void)setPlayer:(TTPlayer)player atBoardIndex:(TTBoardIndex *)boardIndex {
        _squares[boardIndex.row][boardIndex.column] = player;
}

- (BOOL)completeWithWinner:(TTPlayer *)winner {
    
    BOOL hasUnplayedSquares = NO;
    *winner = TTPlayerNone;
    
    for (NSInteger rowIdx = 0; rowIdx < 3; rowIdx++) {
        if (_squares[rowIdx][0] == TTPlayerNone || _squares[rowIdx][1] == TTPlayerNone || _squares[rowIdx][2] == TTPlayerNone) {
            hasUnplayedSquares = YES;
        } else if (_squares[rowIdx][0] == _squares[rowIdx][1] && _squares[rowIdx][1] == _squares[rowIdx][2]) {
            *winner = _squares[rowIdx][0];
            return YES;
        }
    }
    
    for (NSInteger colIdx = 0; colIdx < 3; colIdx++) {
        if (_squares[0][colIdx] == TTPlayerNone || _squares[1][colIdx] == TTPlayerNone || _squares[2][colIdx] == TTPlayerNone) {
            hasUnplayedSquares = YES;
        } else if (_squares[0][colIdx] == _squares[1][colIdx] && _squares[1][colIdx] == _squares[2][colIdx]) {
            *winner = _squares[0][colIdx];
            return YES;
        }
    }
    
    if (_squares[1][1] != TTPlayerNone && _squares[0][0] == _squares[1][1] && _squares[1][1] == _squares[2][2]) {
        *winner = _squares[1][1];
        return YES;
    }
    
    if (_squares[1][1] != TTPlayerNone && _squares[2][0] == _squares[1][1] && _squares[1][1] == _squares[0][2]) {
        *winner = _squares[1][1];
        return YES;
    }
    
    if (!hasUnplayedSquares) {
        return YES;
    }
    
    return NO;
}

- (void)iterateBoardUsingBlock:(void (^)(TTBoardIndex *boardIndex, TTPlayer player, BOOL *stop))block {
    BOOL stop = NO;
    for (NSInteger rowIdx = 0; rowIdx < 3; rowIdx++) {
        for (NSInteger columnIdx = 0; columnIdx < 3; columnIdx++) {
            TTBoardIndex *boardIndex = [TTBoardIndex boardIndexForRow:rowIdx column:columnIdx];
            TTPlayer playerAtSquare = [self playerAtBoardIndex:boardIndex];
            block(boardIndex, playerAtSquare, &stop);
            if (stop) {
                return;
            }
        }
    }
}
@end
