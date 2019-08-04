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
    this->blockString = new char [0];
    this->filterString = new char [0];
    this->info = new PatternInfo();
}

CLogReader::~CLogReader() {
    delete [] this->filterString;
    delete [] this->blockString;
    delete info;
}

bool CLogReader::SetFilter(const char *filter) {
    size_t len = strlen(filter);
    if (len <= 0) {
        return false;
    }
    
    delete [] this->filterString;
    this->filterString = strdup(filter);
    
    delete this->info;
    this->info = new PatternInfo(this->filterString);
    
    return true;
}

bool CLogReader::AddSourceBlock(const char *block, const size_t block_size) {
    
    delete [] this->blockString;
    
    this->blockString = strdup(block);
    
    return startSearching();
}


bool CLogReader::startSearching() {
    return this->info->matchWith(this->blockString);
}
