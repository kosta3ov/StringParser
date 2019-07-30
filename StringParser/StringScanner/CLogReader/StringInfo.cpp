//
//  StringHelpers.cpp
//  StringParser
//
//  Created by Константин Трехперстов on 28.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#include "StringInfo.hpp"
#include <cstring>

typedef enum {
    star, character
} State;

StringInfo::StringInfo() {
    this->string = new char [0];
    this->length = 0;
    this->startsWithStar = false;
    this->endsWithStar = false;
    this->views = new Vector<StringView>(1);
}

StringInfo::StringInfo(const char* str) {
    this->string = strdup(str);
    this->length = strlen(str);
    
    if (str[0] == STAR) {
        this->startsWithStar = true;
    }
    
    if (str[this->length - 1] == STAR) {
        this->endsWithStar = true;
    }
    
    this->views = new Vector<StringView>(10);
    this->splitIntoViews();
    
}

StringInfo::~StringInfo() {
    delete views;
    delete [] string;

}

void StringInfo::splitIntoViews() {
    bool prevState = star;
    bool newState = star;
    
    StringView* view = NULL;
    
    for (int i = 0; i < length; i++) {
        newState = string[i] != STAR ? character : star;
        
        if (newState == character && prevState == star) {
            view = new StringView(&string[i], 1);
        }
        else if (newState == star && prevState == character) {
            views->PushBack(view);
            delete view;
        }
        else if (newState == star && prevState == star) {
            continue;
        }
        else if (newState == character && prevState == character) {
            view->length++;
        }
        
        prevState = newState;
    }
    
    if (newState == character) {
        views->PushBack(view);
        delete view;
    }
}

bool StringInfo::matchWith(const char *str) {
    size_t len = strlen(str);
    const char* end = str + len;
    
    char* pointer = (char*)str;
    
    for (int i = 0; i < views->GetSize(); i++) {
        StringView* view = views->Get(i);
        
        bool isFounded = false;
        
        while (pointer + view->length < end) {
            StringView subView = StringView(pointer, view->length);
            if (view->match(&subView)) {
                pointer += view->length;
                isFounded = true;
                break;
            }
            else {
                if (this->startsWithStar == false) {
                    return false;
                }
                pointer++;
            }
        }
        
        if (!isFounded && (pointer + view->length >= end)) {
            return false;
        }
        if (isFounded && (i == views->GetSize() - 1) && (pointer < end) && this->endsWithStar == false) {
            return false;
        }
    }
    
    
    return true;
}
