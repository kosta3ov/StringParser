//
//  StringView.hpp
//  StringParser
//
//  Created by Константин Трехперстов on 28.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#ifndef StringView_hpp
#define StringView_hpp

#include <stdio.h>

class StringView {
public:
    char* start = NULL;
    size_t length = 0;
    
    StringView(char* start, size_t length);
    StringView();
    
    bool match(const StringView& view);
};

#endif /* StringView_hpp */
