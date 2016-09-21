# HFLiterals
IOS Literal Extension with Strong Typing --- Just for Fun .

recognize real type during compile time through C++ Template .
    
    #define __literal_type__(_lit_) HFLiteralTraits<#_lit_[0], #_lit_[1], #_lit_[2], #_lit_[3]>::LiteralType
    
    #ifdef __cplusplus
    #import "HFLiteralTraits.h"
    #define $(_lit_) (__literal_type__(_lit_))[[HFLiterals sharedInstance] literalObject:@ #_lit_]
    #else
    #define $(_lit_) [[HFLiterals sharedInstance] literalObject:@ #_lit_]
    #endif
