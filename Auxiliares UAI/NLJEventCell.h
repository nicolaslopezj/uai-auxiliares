//
//  NLJEventCell.h
//  Auxiliares UAI
//
//  Created by Nicolas Lopez on 23-12-13.
//  Copyright (c) 2013 Nicolas Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLJCircleView.h"

@interface NLJEventCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet NLJCircleView *colorView;
@property (weak, nonatomic) IBOutlet UIView *selectedLineView;

@end
