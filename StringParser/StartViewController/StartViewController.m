//
//  StartViewController.m
//  StringParser
//
//  Created by Константин Трехперстов on 25.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)startSearching:(UIButton *)sender {
    
}

- (void)dealloc {
    [_fileUrlTextField release];
    [_patternTextField release];
    [super dealloc];
}
@end
