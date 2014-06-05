//
//  TTUltimateWarrior.m
//  TicTacToe
//
//  Created by Andy Sweeny on 6/4/14.
//  Copyright (c) 2014 Andy Sweeny. All rights reserved.
//

#import "TTUltimateWarrior.h"

@implementation TTUltimateWarrior

+ (TTBoardIndex *)suggestMoveForPlayer:(TTPlayer)player inBoard:(TTBoard *)board {
    
    TTBoard *boardCopy = [TTBoard copyBoard:board];
    
    NSArray *moves = [self nextMoves:boardCopy];
    NSInteger bestScore = NSIntegerMin;
    TTBoardIndex *bestMove = nil;
    
    for (TTBoardIndex *move in moves) {
        [boardCopy setPlayer:player atBoardIndex:move];
        NSInteger score = [self minMax:boardCopy player:[self otherPlayer:player] maxPlayer:player];
        if (score > bestScore) {
            bestMove = move;
            bestScore = score;
        }
        [boardCopy setPlayer:TTPlayerNone atBoardIndex:move];
    }
    
    return bestMove;
}

+ (TTPlayer)otherPlayer:(TTPlayer)player {
    return player == TTPlayerX ? TTPlayerO : TTPlayerX;
}

+ (NSInteger)minMax:(TTBoard *)board player:(TTPlayer)player maxPlayer:(TTPlayer)maxPlayer {
    
    TTPlayer otherPlayer = [self otherPlayer:player];
    
    TTPlayer winner;
    if ([board completeWithWinner:&winner]) {
        if (winner == TTPlayerNone) {
            return 0;
        } else {
            return winner == maxPlayer ? 10 : -10;
        }
    }
    
    NSArray *moves = [self nextMoves:board];
    
    NSInteger minMax = 0;
    
    if (player == maxPlayer) {
        
        minMax = NSIntegerMin;
        
        for (TTBoardIndex *move in moves) {
            [board setPlayer:player atBoardIndex:move];
            NSInteger value = [self minMax:board player:otherPlayer maxPlayer:maxPlayer];
            minMax = MAX(value, minMax);
            [board setPlayer:TTPlayerNone atBoardIndex:move];
        }
        
    } else {
        
        minMax = NSIntegerMax;
        
        for (TTBoardIndex *move in moves) {
            [board setPlayer:player atBoardIndex:move];
            NSInteger value = [self minMax:board player:otherPlayer maxPlayer:maxPlayer];
            minMax = MIN(value, minMax);
            [board setPlayer:TTPlayerNone atBoardIndex:move];
        }
        
    }
    
    return minMax;
}

+ (NSArray *)nextMoves:(TTBoard *)board {
    __block NSMutableArray *moves = [NSMutableArray new];
    [board iterateBoardUsingBlock:^(TTBoardIndex *boardIndex, TTPlayer player, BOOL *stop) {
        if (player == TTPlayerNone) {
            [moves addObject:boardIndex];
        }
    }];
    return moves;
}

@end
