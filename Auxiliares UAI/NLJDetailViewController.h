//
//  NLJDetailViewController.h
//  Auxiliares UAI
//
//  Created by Nicolas Lopez on 16-12-13.
//  Copyright (c) 2013 Nicolas Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLJDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
