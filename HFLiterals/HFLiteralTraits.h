//
//  HFLiteralTraits.h
//  HFLiterals
//
//  Created by crazylhf on 16/9/19.
//  Copyright © 2016年 crazylhf. All rights reserved.
//

#ifndef HFLiteralTraits_h
#define HFLiteralTraits_h


///================================================================================
#pragma mark - HFSelectType

template <bool, typename T1, typename T2>
struct HFSelectType {
    typedef T2 ResultType;
};

template <typename T1, typename T2>
struct HFSelectType<true, T1, T2> {
    typedef T1 ResultType;
};


///================================================================================
#pragma mark - HFLiteralTraits

/// limit prefix length is 4
template < char = ':', char = ':', char = ':', char = ':'>
struct HFLiteralTraits {
    static const bool MatchLiteral = false;
    typedef id LiteralType;
    
    char __error_literal_prefix_invalid__[MatchLiteral?1:-1];
};


///================================================================================
#pragma mark - HFLiteralTraits specialization

/**
 * parse prefix during compile time to find the real data type
 * [url stb xib img rgb nil fon]
 */

template <> struct HFLiteralTraits<'u', 'r', 'l'> {
    static const bool MatchLiteral = true;
    typedef NSURL * LiteralType;
};

/// storyboard
template <> struct HFLiteralTraits<'s', 't', 'o', 'r'> {
    static const bool MatchLiteral = true;
    typedef UIStoryboard * LiteralType;
};

template <> struct HFLiteralTraits<'x', 'i', 'b'> {
    static const bool MatchLiteral = true;
    typedef UINib * LiteralType;
};

template <> struct HFLiteralTraits<'i', 'm', 'g'> {
    static const bool MatchLiteral = true;
    typedef UIImage * LiteralType;
};

template <> struct HFLiteralTraits<'r', 'g', 'b'> {
    static const bool MatchLiteral = true;
    typedef UIColor * LiteralType;
};

template <> struct HFLiteralTraits<'n', 'u', 'l', 'l'> {
    static const bool MatchLiteral = true;
    typedef NSNull * LiteralType;
};

template <> struct HFLiteralTraits<'f', 'o', 'n', 't'> {
    static const bool MatchLiteral = true;
    typedef UIFont * LiteralType;
};

template <> struct HFLiteralTraits<'u', 'u', 'i', 'd'> {
    static const bool MatchLiteral = true;
    typedef NSUUID * LiteralType;
};


#define __literal_type__(_lit_) HFLiteralTraits<#_lit_[0], #_lit_[1], #_lit_[2], #_lit_[3]>::LiteralType

#endif /* HFLiteralTraits_h */
