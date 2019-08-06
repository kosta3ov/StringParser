//
//  CLogReader.cpp
//  StringParser
//
//  Created by Константин Трехперстов on 26.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#include "CLogReader.hpp"
#include <cstring>
#include "PatternInfo.hpp"

CLogReader::CLogReader() {
    blockString = NULL;
    filterString = NULL;
    info = new PatternInfo();
}

CLogReader::~CLogReader() {
    delete [] filterString;
    delete [] blockString;
    delete info;
}

bool CLogReader::SetFilter(const char *filter) {
    size_t len = strlen(filter);
    if (len <= 0) {
        return false;
    }
    
    delete [] filterString;
    filterString = strdup(filter);
    
    delete info;
    info = new PatternInfo(filterString);
    
    return true;
}

bool CLogReader::AddSourceBlock(const char *block, const size_t block_size) {
    
    delete [] blockString;
    
    blockString = strdup(block);
    
    return startSearching();
}


bool CLogReader::startSearching() {
    return info->matchWith(blockString);
}
