#include "reducedprecfp.hpp"

#include<cstring>
#include<ctime>
#include<iostream>
#include<cstdlib>

namespace {
  // number of mantissa bits
  int getNumBits(const char* type) {
    if (strcmp(type, "Float") == 0)return 23 ;
    if (strcmp(type, "Double") == 0) return 52;
    return 0;
  }

  inline void flip_bit(uint64& n, int bit) {
    uint64 mask = 1ULL << bit;
    if (n & mask) n &= ~mask;
    else n |= mask;
  }
}

// mask off low order 'param' bits of ret
uint64 ReducedPrecFP::FPOp(int64 param, uint64 ret, const char* type) {
  if (param <= 0) return ret; // 0 or negative bits to mask
  int maxshift = getNumBits(type); // fetch max number of mantissa bits
  int shift = param > maxshift ? maxshift : param; // guarantee don't mask off sign or exp
  int64 mask = ~((int64)0x0) << shift;
  return ret & mask;
}