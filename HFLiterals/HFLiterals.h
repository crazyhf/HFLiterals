//
//  HFLiterals.h
//  HFLiterals
//
//  Created by crazylhf on 16/9/18.
//  Copyright © 2016年 crazylhf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 *  literal format (prefix format must be "xxxxxx:")
 *  NSUUID       => $(uuid:214C7B4F-7C20-4FD8-8DF8-6CC00D06A21B)
 *  NSURL        => $(url:http:www.baidu.com)
 *  UIColor      => $(rgb:#00ff0055)
 *  UIImage      => $(img:test.jpg)
 *  NSNull       => $(null)
 *  UINib        => $(xib:View)
 *  UIFont       => $(font:17.9)
 *  UIStoryboard => $(stor:Main)
 */

@interface HFLiterals : NSObject

- (void)registerPrefix:(NSString *)prefix
              forBlock:(id (^)(NSString * literal))block;


- (id)literalObject:(NSString *)literal;


+ (instancetype)sharedInstance;

@end


#ifdef __cplusplus
    #import "HFLiteralTraits.h"
    #define $(_lit_) (__literal_type__(_lit_))[[HFLiterals sharedInstance] literalObject:@ #_lit_]
#else
    #define $(_lit_) [[HFLiterals sharedInstance] literalObject:@ #_lit_]
#endif

