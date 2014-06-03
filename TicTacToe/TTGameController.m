//
//  TTGameController.m
//  TicTacToe
//
//  Created by Andy Sweeny on 6/2/14.
//  Copyright (c) 2014 Andy Sweeny. All rights reserved.
//

#import "TTGameController.h"

@interface TTGameController()

@property (nonatomic, strong) NSMutableArray *board;

@end

@implementation TTGameController

+ (TTGameController *)newGameAsPlayer:(TTPlayer)player {
    return [[TTGameController alloc] initWithUserPlayer:player];
}

- (id)initWithUserPlayer:(TTPlayer)userPlayer {
    if (self = [super init]) {
        _userPlayer = userPlayer;
        _opponentPlayer = userPlayer == TTPlayerX ? TTPlayerO : TTPlayerX;
        _gameState = TTGameStateActive;
        _currentPlayer = userPlayer;
        _winner = TTPlayerNone;
    }
    return self;
}

- (void)setWinner:(TTPlayer)winner {
    _currentPlayer = TTPlayerNone;
    _winner = winner;
    _gameState = TTGameStateComplete;
    if (self.delegate) {
        [self.delegate gameCompleteWithWinner:winner];
    }
}

- (void)checkComplete {
    BOOL openSquares = NO;
    
    for (NSInteger rowIdx = 0; rowIdx < 3; rowIdx++) {
        TTPlayer column0 = [[[self.board objectAtIndex:rowIdx] objectAtIndex:0] integerValue];
        TTPlayer column1 = [[[self.board objectAtIndex:rowIdx] objectAtIndex:1] integerValue];
        TTPlayer column2 = [[[self.board objectAtIndex:rowIdx] objectAtIndex:2] integerValue];
        if (column0 == TTPlayerNone || column1 == TTPlayerNone || column2 == TTPlayerNone) {
            openSquares = YES;
        } else if (column0 == column1 && column1 == column2) {
            [self setWinner:column0];
            return;
        }
    }
    
    for (NSInteger columnIdx = 0; columnIdx < 3; columnIdx++) {
        TTPlayer row0 = [[[self.board objectAtIndex:0] objectAtIndex:columnIdx] integerValue];
        TTPlayer row1 = [[[self.board objectAtIndex:1] objectAtIndex:columnIdx] integerValue];
        TTPlayer row2 = [[[self.board objectAtIndex:2] objectAtIndex:columnIdx] integerValue];
        if (row0 == TTPlayerNone || row1 == TTPlayerNone || row2 == TTPlayerNone) {
            openSquares = YES;
        } else if (row0 == row1 && row1 == row2) {
            [self setWinner:row0];
            return;
        }
    }
    
    TTPlayer topLeft = [self playerAtRow:0 column:0];
    TTPlayer center = [self playerAtRow:1 column:1];
    TTPlayer bottomRight = [self playerAtRow:2 column:2];
    if (topLeft == bottomRight && bottomRight == center && center != TTPlayerNone) {
        [self setWinner:center];
        return;
    }
    
    TTPlayer topRight = [self playerAtRow:0 column:2];
    TTPlayer bottomLeft = [self playerAtRow:2 column:0];
    if (topRight == bottomLeft && bottomLeft == center && center != TTPlayerNone) {
        [self setWinner:center];
        return;
    }

    if (!openSquares) {
        [self setWinner:TTPlayerNone];
    }
}

- (BOOL)takeTurnAtRow:(NSInteger)row column:(NSInteger)column {
    TTPlayer currentValueAtSquare = [[[self.board objectAtIndex:row] objectAtIndex:column] integerValue];
    if (self.userPlayer == self.currentPlayer
        && self.gameState == TTGameStateActive
        && currentValueAtSquare == TTPlayerNone) {
        [[self.board objectAtIndex:row] setObject:[NSNumber numberWithInt:self.userPlayer] atIndex:column];
        
        // check complete?
        [self checkComplete];
        
        if (self.gameState != TTGameStateComplete) {
            _currentPlayer = self.opponentPlayer;
            // computer's turn in background OR inline...
            [self iterateBoardUsingBlock:^(TTPlayer player, NSUInteger rowIdx, NSUInteger columnIdx, BOOL *stop) {
                if (player == TTPlayerNone) {
                    [[self.board objectAtIndex:rowIdx] setObject:[NSNumber numberWithInt:self.opponentPlayer] atIndex:columnIdx];
                    [self checkComplete];
                    *stop = YES;
                    _currentPlayer = self.userPlayer;
                    if (self.delegate) {
                        [self.delegate player:self.opponentPlayer playedAtRow:rowIdx column:columnIdx];
                    }
                }
            }];
        }
        
        return YES;
    }
    return NO;
}

- (void)iterateBoardUsingBlock:(void (^)(TTPlayer player, NSUInteger rowIdx, NSUInteger columnIdx, BOOL *stop))block {
    BOOL stop = NO;
    for (NSInteger rowIdx = 0; rowIdx < 3; rowIdx++) {
        for (NSInteger columnIdx = 0; columnIdx < 3; columnIdx++) {
            TTPlayer playerAtSquare = [[[self.board objectAtIndex:rowIdx] objectAtIndex:columnIdx] integerValue];
            block(playerAtSquare, rowIdx, columnIdx, &stop);
            if (stop) {
                return;
            }
        }
    }
}

- (TTPlayer)playerAtRow:(NSInteger)row column:(NSInteger)column {
    return [[[self.board objectAtIndex:row] objectAtIndex:column] integerValue];
}

- (NSMutableArray *)board {
    if (!_board) {
        _board = [@[
                    [@[@(TTPlayerNone), @(TTPlayerNone), @(TTPlayerNone)] mutableCopy],
                    [@[@(TTPlayerNone), @(TTPlayerNone), @(TTPlayerNone)] mutableCopy],
                    [@[@(TTPlayerNone), @(TTPlayerNone), @(TTPlayerNone)] mutableCopy]
                    ] mutableCopy];
    }
    return _board;
}

@end
