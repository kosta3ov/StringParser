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

StringInfo::StringInfo(const char* str) {
    size_t strLen = strlen(str);
    this->string = new char [strLen];
    strcpy(this->string, str);
    
    this->length = strLen;
    
    if (str[0] == STAR) {
        this->startsWithStar = true;
    }
    
    if (str[strLen - 1] == STAR) {
        this->endsWithStar = true;
    }
    
    this->views = new Vector<StringView>(100);
    this->splitIntoViews();
    
}

void StringInfo::splitIntoViews() {
    bool prevState = star;
    bool newState = star;
    
    StringView* view;
    
    for (int i = 0; i < length; i++) {
        newState = string[i] != STAR ? character : star;
        
        if (newState == character && prevState == star) {
            view = new StringView(&string[i], 1);
        }
        else if (newState == star && prevState == character) {
            views->PushBack(view);
            
            //delete view;
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
        
        //delete view;
    }
}

bool StringInfo::matchWith(const char *str) {
    size_t len = strlen(str);
    
    char* pointer = (char*)str;
    
    for (int i = 0; i < views->GetSize(); i++) {
        StringView* view = views->Get(i);
        
        while (pointer + view->length < str + len) {
            StringView subView = StringView(pointer, view->length);
            if (view->match(&subView)) {
                pointer += view->length;
                break;
            }
            else {
                pointer++;
            }
        }
        
        if (pointer + view->length >= str + len) {
            return false;
        }
    }
    
    return true;
}
