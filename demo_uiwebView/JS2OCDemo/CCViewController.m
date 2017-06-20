//
//  CCViewController.m
//  JS2OCDemo
//
//  Created by Fruit on 16/7/26.
//  Copyright © 2016年 chao. All rights reserved.
//

#import "CCViewController.h"

@interface CCViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textView;
@end

@implementation CCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (IBAction)clickButton
{
    
    if ([self.delegate respondsToSelector:@selector(CCViewControllerDidClickBtn:)]) {
        [_delegate CCViewControllerDidClickBtn:_textView.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
