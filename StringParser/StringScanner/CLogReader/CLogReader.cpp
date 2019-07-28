//
//  CLogReader.cpp
//  StringParser
//
//  Created by Константин Трехперстов on 26.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#include "CLogReader.hpp"
#include <cstring>
#include "StringInfo.hpp"

CLogReader::CLogReader() {
    
}

CLogReader::~CLogReader() {
    delete [] this->filterString;
    delete [] this->blockString;

}

bool CLogReader::SetFilter(const char *filter) {
    
    size_t len = strlen(filter);
    
    if (len <= 0) {
        return false;
    }
    
    this->filterString = new char [len];
    strcpy(this->filterString, filter);
    
    this->info = new StringInfo(this->filterString);
    
    return true;
}

bool CLogReader::AddSourceBlock(const char *block, const size_t block_size) {
    
    this->blockString = new char [block_size];
    
    strcpy(this->blockString, block);
    
    return startSearching();
}


bool CLogReader::startSearching() {
    return this->info->matchWith(this->blockString);
}
