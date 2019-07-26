//
//  DownloadService.h
//  StringParser
//
//  Created by Константин Трехперстов on 26.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface DownloadService : NSObject

- (void) downloadFileAt:(NSString*) fileURL;

@end

NS_ASSUME_NONNULL_END
