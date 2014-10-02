//
//  NLJEventViewController.h
//  Auxiliares UAI
//
//  Created by Nicolas Lopez on 23-12-13.
//  Copyright (c) 2013 Nicolas Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLJAppDelegate.h"
#import "Check.h"
#import "Event.h"

@class NLJEventsViewController;

@interface NLJEventViewController : UIViewController <UISplitViewControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic,readonly) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) Event *event;

@property (strong, nonatomic) NLJEventsViewController *masterViewController;

@property (weak, nonatomic) IBOutlet UIView *infoBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *buttonsBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *descriptionAlertImageView;

@property (weak, nonatomic) IBOutlet UIView *gradientView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *attendantLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherName;
@property (weak, nonatomic) IBOutlet UILabel *teacherRut;
@property (weak, nonatomic) IBOutlet UILabel *helperName;
@property (weak, nonatomic) IBOutlet UILabel *helperRut;
@property (weak, nonatomic) IBOutlet UIImageView *teacherPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIButton *observationButton;
@property (weak, nonatomic) IBOutlet UIView *noneSelectedView;
@property (weak, nonatomic) IBOutlet UILabel *observationLabel;
@property (weak, nonatomic) IBOutlet UILabel *loadedInServerLabel;

- (void)configureView;

@end
