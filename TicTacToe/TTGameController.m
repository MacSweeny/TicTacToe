//
//  TTGameController.m
//  TicTacToe
//
//  Created by Andy Sweeny on 6/2/14.
//  Copyright (c) 2014 Andy Sweeny. All rights reserved.
//

#import "TTGameController.h"

#import "TTUltimateWarrior.h"

@interface TTGameController()

@property (nonatomic, strong) TTBoard *board;

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
        [self.delegate gameCompleteWithWinner:winner squares:[self.board winningSquares]];
    }
}

- (void)checkComplete {
    TTPlayer winner;
    if ([self.board completeWithWinner:&winner]) {
        [self setWinner:winner];
    }
}

- (BOOL)takeTurnAtRow:(NSInteger)row column:(NSInteger)column {
    TTBoardIndex *boardIndexForTurn = [TTBoardIndex boardIndexForRow:row column:column];
    
    TTPlayer currentValueAtSquare = [self.board playerAtBoardIndex:boardIndexForTurn];
    if (self.userPlayer == self.currentPlayer
        && self.gameState == TTGameStateActive
        && currentValueAtSquare == TTPlayerNone) {
        [self.board setPlayer:self.userPlayer atBoardIndex:boardIndexForTurn];
        
        _currentPlayer = self.opponentPlayer;
        
        // check complete?
        [self checkComplete];
        
        if (self.gameState != TTGameStateComplete) {
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                // Normalizing time it takes for optimal move calculation... to make opponent appear more human...
                double delayInSeconds = 1.5;
                dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                
                TTBoardIndex *nextMove = [TTUltimateWarrior suggestMoveForPlayer:self.opponentPlayer inBoard:self.board];
                
                dispatch_after(dispatchTime, dispatch_get_main_queue(), ^{
                    [self.board setPlayer:self.opponentPlayer atBoardIndex:nextMove];
                    
                    if (self.delegate) {
                        [self.delegate player:self.opponentPlayer playedAtRow:nextMove.row column:nextMove.column];
                    }
                    
                    [self checkComplete];
                    
                    if (self.gameState != TTGameStateComplete) {
                        _currentPlayer = self.userPlayer;
                    }
                    
                });
            });
            
        }
    
        return YES;
    }
    return NO;
}

- (TTPlayer)playerAtRow:(NSInteger)row column:(NSInteger)column {
    return [self.board playerAtBoardIndex:[TTBoardIndex boardIndexForRow:row column:column]];
}

- (TTBoard *)board {
    if (!_board) {
        _board = [TTBoard new];
    }
    return _board;
}

@end
