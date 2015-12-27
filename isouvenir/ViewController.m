//
//  ViewController.m
//  ISouvenir
//
//  Created by m2sar on 27/11/2014.
//  Copyright (c) 2014 m2sar. All rights reserved.
//

#import "ViewController.h"
#import "MaVue.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MaVue *vue;

    UIScreen * ecran = [UIScreen mainScreen];
    CGRect rect = [ecran bounds];
    vue = [[MaVue alloc] initWithFrame:rect];
    vue.mycontroller = self;
    self.view = vue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
