//
//  TTUltimateWarrior.h
//  TicTacToe
//
//  Created by Andy Sweeny on 6/4/14.
//  Copyright (c) 2014 Andy Sweeny. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TTBoard.h"

@interface TTUltimateWarrior : NSObject

+ (TTBoardIndex *)suggestMoveForPlayer:(TTPlayer)player inBoard:(TTBoard *)board;

@end
