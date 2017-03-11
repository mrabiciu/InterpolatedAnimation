//
//  ObjCBoxControllerViewController.m
//  Animation
//
//  Created by Max on 3/8/17.
//  Copyright © 2017 Maxim Rabiciuc. All rights reserved.
//

#import "ObjCBoxController.h"

#import <InterpolatedAnimation/InterpolatedAnimation.h>



@interface ObjCBoxController ()
@property (strong, nonatomic) InterpolatedAnimation *animation;
@property (strong, nonatomic) UIView *box;
@property (strong, nonatomic) UISlider *slider;
@end

@implementation ObjCBoxController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.slider = [[UISlider alloc] init];
  [self.slider addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:self.slider];
  self.slider.frame = CGRectMake(15, self.view.frame.size.height - 40, self.view.frame.size.width - 30, 20);
  
  self.box = [[UIView alloc] init];
  [self.view addSubview:self.box];
  
  self.box.backgroundColor = [UIColor redColor];
  self.box.frame = CGRectMake(self.view.frame.size.width / 2 - 20, self.view.frame.size.height / 2 + 100, 40, 40);
  
  self.animation = [self.view interpolatedAnimation:^{
    self.box.frame = CGRectMake(self.view.frame.size.width / 2 - 20, self.view.frame.size.height / 2 - 100, 40, 40);
    self.box.backgroundColor = [UIColor greenColor];
    self.box.transform = CGAffineTransformMakeScale(5, 2);
    self.box.alpha = 0.1;
  }];
}

- (void)valueChanged {
  self.animation.percent = self.slider.value;
}

@end
