//
//  TTGamePlayViewController.m
//  TicTacToe
//
//  Created by Andy Sweeny on 6/2/14.
//  Copyright (c) 2014 Andy Sweeny. All rights reserved.
//

#import "TTGamePlayViewController.h"

#import "TTTurnIndicatorView.h"

@interface TTGamePlayViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) TTGameController *gameController;
@property (nonatomic, strong) TTTurnIndicatorView *turnIndicatorView;

@property (nonatomic, strong) NSLayoutConstraint *leftTurnIndicatorConstraint;
@property (nonatomic, strong) NSLayoutConstraint *rightTurnIndicatorConstraint;

@property (nonatomic) TTPlayer userPlayer;

@end;

@implementation TTGamePlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.gridView setDelegate:self];
    
    self.userPlayer = TTGridSquareValueX;
    
    [self.userPlayerSquareView setValue:TTGridSquareValueX];
    
    [self.opponentPlayerSquareView setValue:TTGridSquareValueO];
    
    [self setupTurnIndicatorView];
    
    self.gameController = [TTGameController newGameAsPlayer:TTPlayerX];
    self.gameController.delegate = self;
}

- (void)setupTurnIndicatorView {
    
    TTTurnIndicatorView *turnIndicatorView = [TTTurnIndicatorView new];
    self.turnIndicatorView = turnIndicatorView;
    
    turnIndicatorView.layer.cornerRadius = 3;
    
    [turnIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.gameContainerView addSubview:turnIndicatorView];
    
    UIView *userPlayerNameLabel = self.userPlayerNameLabel;
    UIView *opponentPlayerNameLabel = self.opponentPlayerNameLabel;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(turnIndicatorView);
    
    [self.gameContainerView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"[turnIndicatorView(6)]" options:kNilOptions metrics:nil views:views]];
    
    [self.gameContainerView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[turnIndicatorView(6)]" options:kNilOptions metrics:nil views:views]];
 
    [self.gameContainerView addConstraint:
     [NSLayoutConstraint constraintWithItem:turnIndicatorView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:userPlayerNameLabel
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0
                                   constant:0]];
    
    self.leftTurnIndicatorConstraint =
    [NSLayoutConstraint constraintWithItem:turnIndicatorView
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:userPlayerNameLabel
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0
                                  constant:5];
    
    self.rightTurnIndicatorConstraint =
    [NSLayoutConstraint constraintWithItem:turnIndicatorView
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:opponentPlayerNameLabel
                                 attribute:NSLayoutAttributeLeft
                                multiplier:1.0
                                  constant:-5];
    
    [self.gameContainerView addConstraint:self.leftTurnIndicatorConstraint];
}

- (void)setTurnIndicatorToUser {
    [UIView animateWithDuration:.5 animations:^{
        [self.turnIndicatorView setBackgroundColor:[self userPlayerColor]];
        [self.gameContainerView removeConstraint:self.rightTurnIndicatorConstraint];
        [self.gameContainerView addConstraint:self.leftTurnIndicatorConstraint];
        [self.gameContainerView layoutIfNeeded];
    }];
}

- (void)setTurnIndicatorToOpponent {
    [UIView animateWithDuration:.5 animations:^{
        [self.turnIndicatorView setBackgroundColor:[self opponentPlayerColor]];
        [self.gameContainerView removeConstraint:self.leftTurnIndicatorConstraint];
        [self.gameContainerView addConstraint:self.rightTurnIndicatorConstraint];
        [self.gameContainerView layoutIfNeeded];
    }];
}

- (TTPlayer)opponentPlayer {
    return self.userPlayer == TTPlayerX ? TTPlayerO : TTPlayerX;
}

- (UIColor *)userPlayerColor {
    return self.userPlayer == TTPlayerX ? [UIColor blueColor] : [UIColor redColor];
}

- (UIColor *)opponentPlayerColor {
    return self.opponentPlayer == TTPlayerX ? [UIColor blueColor] : [UIColor redColor];
}

- (void)setUserPlayer:(TTPlayer)userPlayer {
    _userPlayer = userPlayer;
    if (userPlayer == TTPlayerX) {
        [self.userPlayerSquareView setValue:TTGridSquareValueX];
        [self.opponentPlayerSquareView setValue:TTGridSquareValueO];
        self.userPlayerNameLabel.textColor = [UIColor blueColor];
        self.opponentPlayerNameLabel.textColor = [UIColor redColor];
    } else {
        [self.userPlayerSquareView setValue:TTGridSquareValueO];
        [self.opponentPlayerSquareView setValue:TTGridSquareValueX];
        self.userPlayerNameLabel.textColor = [UIColor redColor];
        self.opponentPlayerNameLabel.textColor = [UIColor blueColor];
    }
}

- (void)player:(TTPlayer)player playedAtRow:(NSInteger)row column:(NSInteger)column {
    TTGridSquareValue valueToPlay = [self opponentPlayer] == TTPlayerX ? TTGridSquareValueX : TTGridSquareValueO;
    [self.gridView setGridSquareValue:valueToPlay atRow:row column:column];
    [self setTurnIndicatorToUser];
}

- (void)gameCompleteWithWinner:(TTPlayer)winner squares:(NSArray *)squares {
    
    for (TTBoardIndex *boardIndex in squares) {
        [self.gridView highlightSquareAtRow:boardIndex.row column:boardIndex.column];
    }
    
    NSString *title = nil;
    switch (winner) {
        case TTPlayerX:
            title = @"X wins";
            break;
        case TTPlayerO:
            title = @"O wins";
            break;
        default:
            title = @"Draw";
            break;
    }
    [[[UIAlertView alloc] initWithTitle:title message:@"Play Again?" delegate:self cancelButtonTitle:@"X" otherButtonTitles:@"O", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.gridView clear];
    
    self.userPlayer = buttonIndex == [alertView cancelButtonIndex] ? TTPlayerX : TTPlayerO;
 
    [self setTurnIndicatorToUser];
    
    self.gameController = [TTGameController newGameAsPlayer:self.userPlayer];
    self.gameController.delegate = self;
}

- (void)gridView:(TTGridView *)gridView didSelectSquareAtRow:(NSInteger)row column:(NSInteger)column {
    if ([self.gameController takeTurnAtRow:row column:column]) {
        TTGridSquareValue valueToPlay = self.userPlayer == TTPlayerX ? TTGridSquareValueX : TTGridSquareValueO;
        [self.gridView setGridSquareValue:valueToPlay atRow:row column:column];
        [self setTurnIndicatorToOpponent];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
