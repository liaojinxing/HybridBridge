//
//  WishViewController.m
//  Example
//
//  Created by liaojinxing on 14-3-26.
//  Copyright (c) 2014年 douban. All rights reserved.
//

#import "WishViewController.h"

@interface WishViewController ()

@end

@implementation WishViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  UILabel *label = [[UILabel alloc] initWithFrame:self.view.frame];
  label.text = @"hello, world";
  [self.view addSubview:label];
}

@end
