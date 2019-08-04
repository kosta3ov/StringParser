//
//  StringViewerController.m
//  StringParser
//
//  Created by Константин Трехперстов on 04.08.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import "StringViewerController.h"

@interface StringViewerController ()

@property (weak, nonatomic) IBOutlet UITextView* textView;

@end

@implementation StringViewerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.text = self.text;
}

- (void)dealloc {
    [_text release];
    _text = nil;
    _textView = nil;
    [super dealloc];
}

@end
