//
//  StringHelpers.cpp
//  StringParser
//
//  Created by Константин Трехперстов on 28.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#include "PatternInfo.hpp"
#include <cstring>

typedef enum {
    star, character
} State;

PatternInfo::PatternInfo() {
    this->string = new char [0];
    this->length = 0;
    this->startsWithStar = false;
    this->endsWithStar = false;
    this->views = new Vector<StringView>(1);
}

PatternInfo::PatternInfo(const char* str) {
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

PatternInfo::~PatternInfo() {
    delete views;
    delete [] string;

}

void PatternInfo::splitIntoViews() {
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

bool PatternInfo::matchWith(const char *str) {
    size_t len = strlen(str);
    const char* end = str + len;
    
    char* pointer = (char*)str;
    
    bool lastValue = false;
    char* lastEndsAt = NULL;
    
    // Iterating through views
    for (int i = 0; i < views->GetSize(); i++) {
        StringView* view = views->Get(i);
        
        bool isFounded = false;
    
        if (i == views->GetSize() - 1) {
            lastValue = true;
        }
        
        // Moving through string
        while (pointer + view->length <= end) {
            
            // Make subView from pointer with length offset
            StringView subView = StringView(pointer, view->length);
            
            // Checking match
            if (view->match(&subView)) {
                
                // Move pointer
                pointer += view->length;
                
                isFounded = true;
                
                if (lastValue) {
                    lastEndsAt = pointer;
                    continue;
                }
                
                break;
            }
            else {
                // First mismatch without first stars
                if (this->startsWithStar == false && i == 0) {
                    return false;
                }
                // Move pointer
                pointer++;
            }
        }
        
        // if not found and pointer out of range -> false
        if (!isFounded && (pointer + view->length >= end)) {
            return false;
        }
        
        // if found and last view poiner end earlier when no star at the end
        if (isFounded && (i == views->GetSize() - 1) && this->endsWithStar == false) {
            
            if (lastEndsAt < end) {
                return false;
            }
            
        }
        
    }
    
    
    return true;
}
