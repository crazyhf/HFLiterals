//
//  HFLiterals.m
//  HFLiterals
//
//  Created by crazylhf on 16/9/18.
//  Copyright © 2016年 crazylhf. All rights reserved.
//

#import "HFLiterals.h"


@interface HFLiterals()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id (^)(NSString *)> * parserMap;

@end


@implementation HFLiterals

- (void)registerPrefix:(NSString *)prefix
              forBlock:(id (^)(NSString *))block
{
    self.parserMap[prefix] = block;
}


- (id)literalObject:(NSString *)literal
{
    NSString * litPrefix = @"";
    
    if ([literal isEqualToString:@"null"]) {
        litPrefix = @"null";
    } else {
        NSRange resultRange  = [literal rangeOfString:@":"];
        if (NSNotFound != resultRange.location) {
            litPrefix = [literal substringToIndex:resultRange.location];
            literal   = [literal substringFromIndex:resultRange.location + 1];
        }
    }
    
    if (0 != litPrefix.length && 0 != literal.length)
    {
        id (^aParserBlock)(NSString *) = self.parserMap[litPrefix];
        if (nil != aParserBlock) {
            return aParserBlock(literal);
        }
    }
    
    return nil;
}


#pragma mark - built-in literal

- (void)_registerBuiltinLiteral
{
    [self _registerColorLiteral];
    [self _registerImageLiteral];
    [self _registerFontLiteral];
    [self _registerUUIDLiteral];
    [self _registerNilLiteral];
    [self _registerURLLiteral];
    [self _registerXibLiteral];
    [self _registerStoryboardLiteral];
}

/**
 *  $(rgb:#fff) $(rgb:black) $(rgb:darkGray) $(rgb:lightGray)
 *  $(rgb:white) $(rgb:gray) $(rgb:red) $(rgb:green)
 *  $(rgb:blue) $(rgb:cyan) $(rgb:yellow)
 *  $(rgb:magenta) $(rgb:orange)
 *  $(rgb:purple) $(rgb:brown)
 *  $(rgb:clear)
 */
- (void)_registerColorLiteral
{
    [self registerPrefix:@"rgb" forBlock:^id(NSString *literal) {
        if ('#' == literal.UTF8String[0]) {
            literal = [literal substringFromIndex:1];
            unsigned int aColorValue = 0;
            
            if (YES == [[NSScanner scannerWithString:literal] scanHexInt:&aColorValue]) {
                if (3 == literal.length) {
                    unsigned int r = (aColorValue & 0xf00) >> 8;
                    unsigned int g = (aColorValue & 0x0f0) >> 4;
                    unsigned int b = aColorValue & 0x00f;
                    return [UIColor colorWithRed:(r * 16 + r) / 255.0
                                           green:(g * 16 + g) / 255.0
                                            blue:(b * 16 + b) / 255.0
                                           alpha:1.0];
                } else if (4 == literal.length) {
                    unsigned int r = (aColorValue & 0xf000) >> 16;
                    unsigned int g = (aColorValue & 0x0f00) >> 8;
                    unsigned int b = (aColorValue & 0x00f0) >> 4;
                    unsigned int a = aColorValue & 0x000f;
                    return [UIColor colorWithRed:(r * 16 + r) / 255.0
                                           green:(g * 16 + g) / 255.0
                                            blue:(b * 16 + b) / 255.0
                                           alpha:(a * 16 + a) / 255.0];
                } else if (6 == literal.length) {
                    return [UIColor colorWithRed:((aColorValue & 0xff0000) >> 16) / 255.0
                                           green:((aColorValue & 0x00ff00) >> 8) / 255.0
                                            blue:(aColorValue & 0x0000ff) / 255.0
                                           alpha:1.0];
                } else if (8 == literal.length) {
                    return [UIColor colorWithRed:((aColorValue & 0xff000000) >> 24) / 255.0
                                           green:((aColorValue & 0x00ff0000) >> 16) / 255.0
                                            blue:((aColorValue & 0x0000ff00) >> 8) / 255.0
                                           alpha:(aColorValue & 0x000000ff) / 255.0];
                }
            }
        } else if (YES == [literal isEqualToString:@"black"]) {
            return [UIColor blackColor];
        } else if (YES == [literal isEqualToString:@"darkGray"]) {
            return [UIColor darkGrayColor];
        } else if (YES == [literal isEqualToString:@"lightGray"]) {
            return [UIColor lightGrayColor];
        } else if (YES == [literal isEqualToString:@"white"]) {
            return [UIColor whiteColor];
        } else if (YES == [literal isEqualToString:@"gray"]) {
            return [UIColor grayColor];
        } else if (YES == [literal isEqualToString:@"red"]) {
            return [UIColor redColor];
        } else if (YES == [literal isEqualToString:@"green"]) {
            return [UIColor greenColor];
        } else if (YES == [literal isEqualToString:@"blue"]) {
            return [UIColor blueColor];
        } else if (YES == [literal isEqualToString:@"cyan"]) {
            return [UIColor cyanColor];
        } else if (YES == [literal isEqualToString:@"yellow"]) {
            return [UIColor yellowColor];
        } else if (YES == [literal isEqualToString:@"magenta"]) {
            return [UIColor magentaColor];
        } else if (YES == [literal isEqualToString:@"orange"]) {
            return [UIColor orangeColor];
        } else if (YES == [literal isEqualToString:@"purple"]) {
            return [UIColor purpleColor];
        } else if (YES == [literal isEqualToString:@"brown"]) {
            return [UIColor brownColor];
        } else if (YES == [literal isEqualToString:@"clear"]) {
            return [UIColor clearColor];
        }
        return nil;
    }];
}

/// img:
- (void)_registerImageLiteral
{
    [self registerPrefix:@"img" forBlock:^id(NSString *literal) {
        UIImage * anInstance = [UIImage imageNamed:literal];
        if (nil == anInstance) {
            anInstance = [UIImage imageWithContentsOfFile:literal];
        }
        return anInstance;
    }];
}

/// font:
- (void)_registerFontLiteral
{
    [self registerPrefix:@"font" forBlock:^id(NSString *literal) {
        double aFontSize = 0.;
        if (YES == [[NSScanner scannerWithString:literal] scanDouble:&aFontSize]) {
            return [UIFont systemFontOfSize:aFontSize];
        }
        return nil;
    }];
}

/// uuid:
- (void)_registerUUIDLiteral
{
    [self registerPrefix:@"uuid" forBlock:^id(NSString *literal) {
        return [[NSUUID alloc] initWithUUIDString:literal];
    }];
}

/// null
- (void)_registerNilLiteral
{
    [self registerPrefix:@"null" forBlock:^id(NSString *literal) {
        return [NSNull null];
    }];
}

/// url:
- (void)_registerURLLiteral
{
    [self registerPrefix:@"url" forBlock:^id(NSString *literal) {
        if (YES == [literal hasPrefix:@"http:"]) {
            NSString * aUrlString = [literal substringFromIndex:5];
            return [NSURL URLWithString:[@"http://" stringByAppendingString:aUrlString]];
        }
        else if (YES == [literal hasPrefix:@"https:"]) {
            NSString * aUrlString = [literal substringFromIndex:6];
            return [NSURL URLWithString:[@"https://" stringByAppendingString:aUrlString]];
        }
        else {
            return [NSURL fileURLWithPath:literal];
        }
    }];
}

/// stor:
- (void)_registerStoryboardLiteral
{
    [self registerPrefix:@"stor" forBlock:^id(NSString *literal) {
        return [UIStoryboard storyboardWithName:literal bundle:nil];
    }];
}

/// xib:
- (void)_registerXibLiteral
{
    [self registerPrefix:@"xib" forBlock:^id(NSString *literal) {
        return [UINib nibWithNibName:literal bundle:nil];
    }];
}


#pragma mark - singleton

- (id)init
{
    if (self = [super init]) {
        _parserMap = [[NSMutableDictionary alloc] init];
        
        [self _registerBuiltinLiteral];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static HFLiterals * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[HFLiterals alloc] init];
    });
    return _instance;
}

@end