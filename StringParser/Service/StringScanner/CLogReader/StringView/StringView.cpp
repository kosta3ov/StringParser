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
    this->start = NULL;
    this->length = 0;
}

StringView::StringView(char* start, size_t length) {
    this->start = start;
    this->length = length;
}

bool StringView::match(StringView* view) {
    
    for (int i = 0; i < this->length; i++) {
        if (this->start[i] != view->start[i] && this->start[i] != QUESTION) {
            return false;
        }
    }
    return true;
}
