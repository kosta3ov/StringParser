//
//  Errors.h
//  StringParser
//
//  Created by Константин Трехперстов on 26.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifndef Errors_h
#define Errors_h


FOUNDATION_EXPORT NSString* const StringParserErrorDomain;

typedef NS_ENUM(NSInteger, StringParserErrorCodes) {
    SPBadPattern = 1000,
};


#endif /* Errors_h */
