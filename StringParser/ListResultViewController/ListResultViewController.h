//
//  ViewController.h
//  StringParser
//
//  Created by Константин Трехперстов on 25.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListResultViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString* fileURL;
@property (strong, nonatomic) NSString* stringPattern;

@end

