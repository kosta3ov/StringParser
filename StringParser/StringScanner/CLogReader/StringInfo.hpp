//
//  StringHelpers.hpp
//  StringParser
//
//  Created by Константин Трехперстов on 28.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#ifndef StringHelpers_hpp
#define StringHelpers_hpp

#include <stdio.h>
#include "vector.hpp"
#include "StringView.hpp"


const char STAR = '*';
const char QUESTION = '?';

class StringInfo {
    
public:
    StringInfo(const char* str);
    
    bool matchWith(const char* str);
    
private:
    void splitIntoViews();

    bool startsWithStar = false;
    bool endsWithStar = false;
    
    char* string;
    size_t length;
    
    Vector<StringView>* views;
    
    
};


#endif /* StringHelpers_hpp */
