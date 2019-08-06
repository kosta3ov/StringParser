//
//  Vector.hpp
//  StringParser
//
//  Created by Константин Трехперстов on 28.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#ifndef Vector_hpp
#define Vector_hpp

#include <stdio.h>

template <typename T>
class Vector {
    
public:
    Vector(size_t newCapacity);
    void PushBack (T* value);
    ~Vector ();
    size_t GetSize ();
    T& Get(size_t index);
    
private:
    size_t Size;
    size_t Capacity;
    T* Data;
    size_t GetOptimalCapacity (size_t newSize);
    void Resize (size_t newSize);
};

template <typename T>
Vector<T>::Vector (size_t newCapacity) {
    Capacity = 1;
    Size = 0;
    Capacity = GetOptimalCapacity (newCapacity);
    Data = new T[Capacity];
}


template <typename T>
void Vector<T>::PushBack (T* value){
    Size++;
    if (Size > Capacity) {
        Resize(Size);
    }
    Data[Size - 1] = *value;
}


template <typename T>
T& Vector<T>::Get(size_t index) {
    return Data[index];
}

template <typename T>
size_t Vector<T>::GetSize () {
    return Size;
}

template <typename T>
size_t Vector<T>::GetOptimalCapacity (size_t newCap) {
    size_t res = Capacity;
    while (res < newCap) {
        res *= 2;
    }
    while ((res/2 > newCap) && (res > 4)) {
        res /= 2;
    }
    return res;
}

template <typename T>
void Vector<T>::Resize (size_t newSize) {
    size_t optimalCap = GetOptimalCapacity(newSize);
    T* newData = new T[optimalCap];
    if (optimalCap > Capacity) {
        for (int i = 0; i < Size; i++) {
            newData[i] = Data[i];
        }
    }
    else {
        for (int i = 0; i < newSize; i++) {
            newData[i] = Data[i];
        }
    }
    Capacity = optimalCap;
    delete [] Data;
    Data = newData;
    Size = newSize;
}

template <typename T>
Vector<T>::~Vector () {
    delete [] Data;
}

#endif /* Vector_hpp */
