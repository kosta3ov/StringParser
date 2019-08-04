//
//  StringScanner.h
//  StringParser
//
//  Created by Константин Трехперстов on 26.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringScanner : NSObject

- (void) setFilter:(NSString*) filter;
- (BOOL) addSourceBlock:(NSString*) string;

@end


