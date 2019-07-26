//
//  CLogReader.hpp
//  StringParser
//
//  Created by Константин Трехперстов on 26.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#ifndef CLogReader_hpp
#define CLogReader_hpp

#include <stdio.h>

class CLogReader {
    
public:
    CLogReader();
    ~CLogReader();
    
    bool SetFilter(const char *filter);
    bool AddSourceBlock(const char* block, const size_t block_size);
    
private:
    char* filterString;
    
    
};

#endif /* CLogReader_hpp */
