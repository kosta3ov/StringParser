//
//  StartViewController.h
//  StringParser
//
//  Created by Константин Трехперстов on 25.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StartViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *fileUrlTextField;
@property (weak, nonatomic) IBOutlet UITextField *patternTextField;

@end

NS_ASSUME_NONNULL_END
