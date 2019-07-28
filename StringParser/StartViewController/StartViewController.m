//
//  StartViewController.m
//  StringParser
//
//  Created by Константин Трехперстов on 25.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import "StartViewController.h"
#import "ListResultViewController.h"

@interface StartViewController ()

@property (strong, nonatomic) UIAlertController* alert;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Empty fields" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    
    self.alert = alertController;
    
}

- (IBAction)startSearching:(id)sender {
    NSString* fileURL = self.fileUrlTextField.text;
    NSString* pattern = self.patternTextField.text;
    
    BOOL fileURLexist = fileURL.length > 0;
    BOOL filterPatternExist = pattern.length > 0;
    
    if (fileURLexist && filterPatternExist) {
        [self presentListResultsWithURL:fileURL andPattern:pattern];
    }
    else {
        [self presentAlert];
    }
}

- (void) presentListResultsWithURL:(NSString*) fileURL andPattern:(NSString*) pattern {
    ListResultViewController* lrvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ListResultViewController"];
    
    lrvc.fileURL = fileURL;
    lrvc.stringPattern = pattern;
    
    [self.navigationController pushViewController:lrvc animated:YES];
}

- (void) presentAlert {
    [self presentViewController:self.alert animated:YES completion:nil];
}

- (void)dealloc {
    [_fileUrlTextField release];
    [_patternTextField release];
    [_alert release];
    [super dealloc];
}

@end
