//
//  TTGamePlayViewController.h
//  TicTacToe
//
//  Created by Andy Sweeny on 6/2/14.
//  Copyright (c) 2014 Andy Sweeny. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTGridSquareView.h"
#import "TTGridView.h"
#import "TTGameController.h"

@interface TTGamePlayViewController : UIViewController <TTGridViewDelegate, TTGameControllerDelegate>

@property (weak, nonatomic) IBOutlet TTGridSquareView *userPlayerSquareView;
@property (weak, nonatomic) IBOutlet UILabel *userPlayerNameLabel;

@property (weak, nonatomic) IBOutlet TTGridSquareView *opponentPlayerSquareView;
@property (weak, nonatomic) IBOutlet UILabel *opponentPlayerNameLabel;

@property (weak, nonatomic) IBOutlet UIView *gameContainerView;

@property (weak, nonatomic) IBOutlet TTGridView *gridView;



@end
