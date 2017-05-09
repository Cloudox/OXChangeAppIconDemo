//
//  ViewController.m
//  OXChangeAppIconDemo
//
//  Created by csdc-iMac on 2017/5/9.
//  Copyright © 2017年 Cloudox. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

// 设备的宽高
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 利用runtime来替换展现弹出框的方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method presentM = class_getInstanceMethod(self.class, @selector(presentViewController:animated:completion:));
        Method presentSwizzlingM = class_getInstanceMethod(self.class, @selector(ox_presentViewController:animated:completion:));
        // 交换方法实现
        method_exchangeImplementations(presentM, presentSwizzlingM);
    });
    
    // 男生按钮
    UIButton *boyBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREENWIDTH-100)/2, 200, 100, 30)];
    [boyBtn setTitle:@"Boy" forState:UIControlStateNormal];
    [boyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    boyBtn.backgroundColor = [UIColor darkGrayColor];
    [boyBtn addTarget:self action:@selector(toBoy) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:boyBtn];
    
    // 女生按钮
    UIButton *girlBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREENWIDTH-100)/2, 300, 100, 30)];
    [girlBtn setTitle:@"Girl" forState:UIControlStateNormal];
    [girlBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    girlBtn.backgroundColor = [UIColor darkGrayColor];
    [girlBtn addTarget:self action:@selector(toGirl) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:girlBtn];
}

// 自己的替换展示弹出框的方法
- (void)ox_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
        NSLog(@"title : %@",((UIAlertController *)viewControllerToPresent).title);
        NSLog(@"message : %@",((UIAlertController *)viewControllerToPresent).message);
        
        // 换图标时的提示框的title和message都是nil，由此可特殊处理
        UIAlertController *alertController = (UIAlertController *)viewControllerToPresent;
        if (alertController.title == nil && alertController.message == nil) {// 是换图标的提示
            return;
        } else {// 其他提示还是正常处理
            [self ox_presentViewController:viewControllerToPresent animated:flag completion:completion];
            return;
        }
    }
    
    [self ox_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

// 变男生图标
- (void)toBoy {
    if (![[UIApplication sharedApplication] supportsAlternateIcons]) {// 系统不支持换图标
        return;
    }
    
    [[UIApplication sharedApplication] setAlternateIconName:@"boy.jpg" completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换app图标发生错误了 ： %@",error);
        }
    }];
}

// 变女生图标
- (void)toGirl {
    if (![[UIApplication sharedApplication] supportsAlternateIcons]) {// 系统不支持换图标
        return;
    }
    
    [[UIApplication sharedApplication] setAlternateIconName:@"girl.jpg" completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换app图标发生错误了 ： %@",error);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
