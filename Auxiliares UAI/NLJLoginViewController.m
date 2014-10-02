//
//  NLJLoginViewController.m
//  Auxiliares UAI
//
//  Created by Nicolás López on 01-10-14.
//  Copyright (c) 2014 Nicolas Lopez. All rights reserved.
//

#import "NLJLoginViewController.h"
#import <UNIRest.h>
#import "NLJHelper.h"

@interface NLJLoginViewController ()

@end

@implementation NLJLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSInteger number = arc4random_uniform(3) + 1;
    NSString *imageName = [NSString stringWithFormat:@"welcome_image_%li", (long) number];
    self.backgroundImageView.image = [UIImage imageNamed:imageName];
    
    NSArray *allFields = @[self.usernameTextField, self.passwordTextField];
    self.viewShaker = [[AFViewShaker alloc] initWithViewsArray:allFields];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enterButtonClicked:(id)sender {
    [self startLoginProcessWithUsername:self.usernameTextField.text andPassword:self.passwordTextField.text];
}

- (void)startLoginProcessWithUsername:(NSString *)username andPassword:(NSString *)password {
    
    if (!(username.length > 0) || !(password.length > 0)) {
        [self performSelector:@selector(shake) withObject:nil];
        return;
    }
    
    NSDictionary* headers = @{@"accept": @"application/json"};
    NSDictionary* parameters = @{@"username": username, @"password": password};
    
    dispatch_async( dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"Starting login...");
        
        UNIHTTPJsonResponse* response = [[UNIRest get:^(UNISimpleRequest* request) {
            [request setUrl:@"http://firma.uai.cl/auxiliares/autenticarAuxiliar.php"];
            [request setHeaders:headers];
            [request setParameters:parameters];
        }] asJson];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            
            NSDictionary *body = [[response body] JSONObject];
            if ([[body objectForKey:@"success"] boolValue]) {
                NSString *auxId = (NSString *)[body objectForKey:@"aux_id"];
                [NLJHelper setDefaultsValue:auxId forKey:@"aux_id"];
                [self dismissViewControllerAnimated:YES completion:nil];
                
                NSLog(@"Logged in as %@", auxId);
            } else {
                [self performSelector:@selector(shake) withObject:nil];
                NSLog(@"Not Authorized: %@", body);
            }
            
        });
    });
    
}

- (void)shake {
    
    [self.viewShaker shake];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
