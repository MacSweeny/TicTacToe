//
//  TTGamePlayViewController.m
//  TicTacToe
//
//  Created by Andy Sweeny on 6/2/14.
//  Copyright (c) 2014 Andy Sweeny. All rights reserved.
//

#import "TTGamePlayViewController.h"

#import "TTGameController.h"

@interface TTGamePlayViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) TTGameController *gameController;

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
    
    self.gameController = [TTGameController newGameAsPlayer:TTPlayerX];
    self.gameController.delegate = self;
}

- (void)player:(TTPlayer)player playedAtRow:(NSInteger)row column:(NSInteger)column {
    [self.gridView setGridSquareValue:TTGridSquareValueO atRow:row column:column];
}

- (void)gameCompleteWithWinner:(TTPlayer)winner {
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
    [[[UIAlertView alloc] initWithTitle:title message:@"Play Again?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.gridView clear];
    
    self.gameController = [TTGameController newGameAsPlayer:TTPlayerX];
    self.gameController.delegate = self;
}

- (void)gridView:(TTGridView *)gridView didSelectSquareAtRow:(NSInteger)row column:(NSInteger)column {
    if ([self.gameController takeTurnAtRow:row column:column]) {
        [self.gridView setGridSquareValue:TTGridSquareValueX atRow:row column:column];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
