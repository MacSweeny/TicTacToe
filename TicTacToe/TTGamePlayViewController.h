//
//  TTGamePlayViewController.h
//  TicTacToe
//
//  Created by Andy Sweeny on 6/2/14.
//  Copyright (c) 2014 Andy Sweeny. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTGridView.h"

@interface TTGamePlayViewController : UIViewController <TTGridViewDelegate>

@property (weak, nonatomic) IBOutlet TTGridView *gridView;

@end
