//
//  ViewController.m
//  WBAlertView
//
//  Created by 李伟宾 on 16/5/12.
//  Copyright © 2016年 dylan_lwb. All rights reserved.
//

#import "ViewController.h"
#import "WBAlertView.h"
@interface ViewController () <WBAlertViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)type1:(id)sender {
    WBAlertView *alert = [[WBAlertView alloc] initWithTitle:@"提示"
                                                    message:@"Copyright © 2016年 dylan_lwb. All rights reserved."
                                          cancelButtonTitle:nil
                                         confirmButtonTitle:@"知道了"];
    [alert show];
}

- (IBAction)type2:(id)sender {
    WBAlertView *alert = [[WBAlertView alloc] initWithTitle:nil
                                                    message:@"Copyright © 2016年 dylan_lwb. All rights reserved."
                                          cancelButtonTitle:@"取消"
                                         confirmButtonTitle:@"确定"];
    alert.delegate = self;
    [alert show];
}

- (IBAction)type3:(id)sender {
    WBAlertView  *alert = [[WBAlertView alloc] initWithProgressOfTitle:@"努力加载ing..."];\
    [alert show];
}


- (IBAction)type4:(id)sender {
    [WBAlertView showMessageToast:@"Copyright © 2016年 dylan_lwb." toView:self.view];
}

- (IBAction)type5:(id)sender {
    WBAlertView *customAlert = [[WBAlertView alloc] initWithTitle:nil
                                                   message:nil
                                         cancelButtonTitle:nil
                                        confirmButtonTitle:nil];
    
    customAlert.delegate = self;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 255, 196)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"xiugaitouxing_btn"];
    imageView.userInteractionEnabled = YES;
    
    customAlert.contentView = imageView;
    customAlert.hideButton = YES;
    [customAlert show];
}
- (IBAction)type6:(id)sender {
    WBAlertView *customAlert = [[WBAlertView alloc] initWithTitle:nil
                                                          message:nil
                                                cancelButtonTitle:@"取消"
                                               confirmButtonTitle:@"确定"];
    
    customAlert.delegate = self;
    
    UIView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 255, 196)];
    view.backgroundColor = [UIColor redColor];
    view.tag = 100;
    customAlert.contentView = view;
    customAlert.hideButton = NO;
    [customAlert show];
}

// delegate
- (void)confirmButtonClickedOnAlertView:(WBAlertView *)alertView {
    NSLog(@"confirmButtonClickedOnAlertView");
}

- (void)cancelButtonClickedOnAlertView:(WBAlertView *)alertView {
    NSLog(@"cancelButtonClickedOnAlertView");
}

@end
