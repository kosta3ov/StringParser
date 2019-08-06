//
//  StringView.cpp
//  StringParser
//
//  Created by Константин Трехперстов on 28.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#include "StringView.hpp"
#include "PatternInfo.hpp"

StringView::StringView() {
    start = NULL;
    length = 0;
}

StringView::StringView(char* start, size_t length) {
    this->start = start;
    this->length = length;
}

bool StringView::match(const StringView& view) {
    
    for (int i = 0; i < length; i++) {
        
        if (start[i] != view.start[i] && start[i] != QUESTION) {
            
            return false;
        }
    }
    return true;
}
