//
//  JWViewController.m
//  JWAppIconUpdate
//
//  Created by Justin.wang on 02/02/2018.
//  Copyright (c) 2018 Justin.wang. All rights reserved.
//

#import "JWViewController.h"
#import <JWAppIconUpdate/JWAppIconUpdate.h>

@interface JWViewController ()

@property (nonatomic, assign) BOOL isMainIcon;

@end

@implementation JWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)switchIcon:(UIButton *)sender {
    self.isMainIcon = !self.isMainIcon;
    if (self.isMainIcon) {
        [[UIApplication sharedApplication] updateAppIconWithName:@"新年"];
    } else {
        [[UIApplication sharedApplication] updateAppIconWithName:nil];
    }
}

@end
