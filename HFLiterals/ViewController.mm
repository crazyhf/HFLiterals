//
//  ViewController.m
//  HFLiterals
//
//  Created by crazylhf on 16/9/18.
//  Copyright © 2016年 crazylhf. All rights reserved.
//

#import "ViewController.h"

#import "HFLiterals.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * anImageView0 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, 200, 200)];
    anImageView0.image = $(img:test.jpg);
    
    [self.view addSubview:anImageView0];
    
    NSLog(@"\n%@ ,\n\n%@ ,\n\n%@ ,\n\n%@ ,\n\n%@ ,\n\n%@ ,\n\n%@ ,\n\n%@",
          $(null),
          $(xib:View),
          $(font:17.9),
          $(stor:Main),
          $(img:test.jpg),
          $(rgb:#00ff0055),
          $(url:http:www.baidu.com),
          $(uuid:214C7B4F-7C20-4FD8-8DF8-6CC00D06A21B));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
