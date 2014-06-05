//
//  TTGameController.h
//  TicTacToe
//
//  Created by Andy Sweeny on 6/2/14.
//  Copyright (c) 2014 Andy Sweeny. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TTBoard.h"

typedef enum {
    TTGameStateActive,
    TTGameStateComplete
} TTGameState;

@protocol TTGameControllerDelegate;

@interface TTGameController : NSObject

@property (nonatomic, readonly) TTGameState gameState;
@property (nonatomic, readonly) TTPlayer userPlayer;
@property (nonatomic, readonly) TTPlayer opponentPlayer;
@property (nonatomic, readonly) TTPlayer currentPlayer;
@property (nonatomic, readonly) TTPlayer winner;
@property (nonatomic, weak) id<TTGameControllerDelegate> delegate;

+ (TTGameController *)newGameAsPlayer:(TTPlayer)player;

- (BOOL)takeTurnAtRow:(NSInteger)row column:(NSInteger)column;

@end

@protocol TTGameControllerDelegate <NSObject>

- (void)player:(TTPlayer)player playedAtRow:(NSInteger)row column:(NSInteger)column;
- (void)gameCompleteWithWinner:(TTPlayer)winner;

@end
