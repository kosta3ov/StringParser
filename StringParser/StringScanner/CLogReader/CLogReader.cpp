//
//  CLogReader.cpp
//  StringParser
//
//  Created by Константин Трехперстов on 26.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#include "CLogReader.hpp"
#include <cstring>

CLogReader::CLogReader() {
    
}

CLogReader::~CLogReader() {
    delete[] this->filterString;

}

bool CLogReader::SetFilter(const char *filter) {
    size_t len = strlen(filter);
    
    if (len <= 0) {
        return false;
    }
    
    this->filterString = new char [len];
    strcpy(this->filterString, filter);
    return true;
}

bool CLogReader::AddSourceBlock(const char *block, const size_t block_size) {
    return true;
}
