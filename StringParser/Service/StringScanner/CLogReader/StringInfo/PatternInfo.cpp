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
    string = NULL;
    length = 0;
    startsWithStar = false;
    endsWithStar = false;
    views = new Vector<StringView>(1);
}

PatternInfo::PatternInfo(const char* str) {
    string = strdup(str);
    length = strlen(str);
    
    if (str[0] == STAR) {
        startsWithStar = true;
    }
    
    if (str[length - 1] == STAR) {
        endsWithStar = true;
    }
    
    views = new Vector<StringView>(10);
    splitIntoViews();
    
}

PatternInfo::~PatternInfo() {
    delete views;
    delete [] string;
}


void PatternInfo::splitIntoViews() {
    bool prevState = star;
    bool newState = star;
    
    StringView* view = NULL;
    
    // Get vector of string views between stars
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
    int len = static_cast<int>(strlen(str));
    char* end = const_cast<char*>(str) + len;
    char* pointer = const_cast<char*>(str);
    
    int firstViewIndex = 0;
    int lastViewIndex = static_cast<int>(views->GetSize() - 1);
    
    //First part processing
    if (!startsWithStar) {
        StringView firstView = views->Get(firstViewIndex);
        
        if (len < firstView.length) {
            return false;
        }

        const StringView subView = StringView(pointer, firstView.length);
        
        if (!firstView.match(subView)) {
            return false;
        }
        
        firstViewIndex++;
        pointer += firstView.length;
    }
    

    //Last part processing
    if (!endsWithStar) {
        StringView lastView = views->Get(lastViewIndex);
        
        if (len < lastView.length) {
            return false;
        }
        
        const StringView subView = StringView(end - lastView.length, lastView.length);
        
        if (!lastView.match(subView)) {
            return false;
        }
        
        lastViewIndex--;
        if (lastViewIndex < 0) {
            lastViewIndex = 0;
        }
        
        end -= lastView.length;
    }
    
    
    if (pointer >= end) {
        return false;
    }
    
    // Processing between first and last parts
    for (int i = firstViewIndex; i <= lastViewIndex; i++) {
        StringView view = views->Get(i);
        
        bool found = false;
        
        while (pointer + view.length <= end) {
            
            const StringView subView = StringView(pointer, view.length);
            
            if (view.match(subView)) {
                found = true;
                pointer += view.length;
                break;
            }
            else {
                pointer++;
            }
        }
        
        if (!found) {
            return false;
        }
    }
    
    return true;
}
