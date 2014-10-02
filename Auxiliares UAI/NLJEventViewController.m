//
//  NLJEventViewController.m
//  Auxiliares UAI
//
//  Created by Nicolas Lopez on 23-12-13.
//  Copyright (c) 2013 Nicolas Lopez. All rights reserved.
//

#import "NLJEventViewController.h"
#import "NLJEventsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "ChameleonFramework/Chameleon.h"

@interface NLJEventViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation NLJEventViewController

#pragma mark - Managing the detail item

- (void)setEvent:(Event *)newEvent
{
    if (_event != newEvent) {
        _event = newEvent;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    if (self.event) {
        _gradientView.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:_gradientView.frame andColors:@[FlatBlue, FlatNavyBlue]];
        _roomLabel.text = _event.room;
        _nameLabel.text = _event.name;
        _attendantLabel.text = _event.attendant;
        _teacherName.text = [[_event.teacherName stringByAppendingString:@" "] stringByAppendingString:_event.teacherLastName];
        _teacherRut.text = _event.teacherRut;
        _descriptionLabel.text = _event._description;
        if (_event._description.length > 0) {
            _descriptionAlertImageView.alpha = 1.0f;
        } else {
            _descriptionAlertImageView.alpha = 0.0f;
        }
        _noneSelectedView.alpha = 0.0f;
        
        if (![_event.helperName isEqualToString:@"N/A"]) {
            _helperName.text = [[_event.helperName stringByAppendingString:@" "] stringByAppendingString:_event.helperLastName];
            _helperRut.text = _event.helperRut;
        } else {
            _helperName.text = @"";
            _helperRut.text = @"";
        }
        
        NSURL *teacherImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://firma.uai.cl/auxiliares/fotos/%@.jpg", _event.teacherRut]];
        [_teacherPhotoImageView setImageWithURL:teacherImageURL usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [self reloadButtons];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm"];
        _dateLabel.text = [[[dateFormat stringFromDate:_event.startDate]
                            stringByAppendingString:@" - "]
                           stringByAppendingString:[dateFormat stringFromDate:_event.endDate]];
        
    } else {
        _noneSelectedView.alpha = 1.0f;
    }
}

- (void)reloadButtons
{
    Check *check = [self.event checkInManagedObjectContext:self.managedObjectContext];
    if (check.date) {
        if ([check.uploaded isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            _observationButton.enabled = NO;
            _okButton.enabled = NO;
            _loadedInServerLabel.alpha = 1.0f;
        } else {
            _observationButton.enabled = YES;
            _okButton.enabled = YES;
            _loadedInServerLabel.alpha = 0.0f;
        }
        if (check.comment.length > 0) {
            _observationButton.selected = YES;
            _observationLabel.text = check.comment;
            _okButton.selected = NO;
        } else {
            _observationLabel.text = @"";
            _observationButton.selected = NO;
            _okButton.selected = YES;
        }
    } else {
        _observationLabel.text = @"";
        _observationButton.selected = NO;
        _okButton.selected = NO;
        _observationButton.enabled = YES;
        _okButton.enabled = YES;
        _loadedInServerLabel.alpha = 0.0f;
    }
}

- (void)checkStateDidChange
{
    NSIndexPath *selectedRow = self.masterViewController.tableView.indexPathForSelectedRow;
    [self.masterViewController.tableView reloadRowsAtIndexPaths:@[selectedRow]
                                               withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.masterViewController.tableView selectRowAtIndexPath:selectedRow animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self reloadButtons];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (NSManagedObjectContext *)managedObjectContext
{
    return [(NLJAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

#pragma mark - User Actions


- (IBAction)didClickOkButton:(id)sender
{
    [_event toggleCheckInManagedObjectContext:self.managedObjectContext];
    [self checkStateDidChange];
}

- (IBAction)didClickObservationButton:(id)sender
{
    if ([_event isCheckedinManagedObjectContext:self.managedObjectContext]) {
        [_event deleteCheckInManagedObjectContext:self.managedObjectContext];
        [self checkStateDidChange];
        return;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Profesor no corresponde",
                                                                        @"Sala no ocupada",
                                                                        @"Otro", nil];
    [actionSheet showInView:sender];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //profesor no corresponde
        [_event toggleCheckInManagedObjectContext:self.managedObjectContext withComment:@"Profesor no corresponde"];
        [self checkStateDidChange];
    } else if (buttonIndex == 1) {
        //sala no ocupada
        [_event toggleCheckInManagedObjectContext:self.managedObjectContext withComment:@"Sala no ocupada"];
        [self checkStateDidChange];
    } else if (buttonIndex == 2) {
        [self didChooseObservationOther];
    }
}

- (void)didChooseObservationOther
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Observación"
                                                    message:@"Escriba la observación"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancelar"
                                          otherButtonTitles:@"Guardar", nil];
    alert.tag = 1;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            
        } else if (buttonIndex == 1) {
            [_event toggleCheckInManagedObjectContext:self.managedObjectContext withComment:[alertView textFieldAtIndex:0].text];
            [self checkStateDidChange];
        }
    }
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = @"Eventos";
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
