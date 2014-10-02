//
//  NLJLoginViewController.h
//  Auxiliares UAI
//
//  Created by Nicolás López on 01-10-14.
//  Copyright (c) 2014 Nicolas Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFViewShaker.h"

@interface NLJLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) AFViewShaker *viewShaker;

@end
