//
//  CCViewController.h
//  JS2OCDemo
//
//  Created by Fruit on 16/7/26.
//  Copyright © 2016年 chao. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol CCViewControllerDelegate <NSObject>

- (void)CCViewControllerDidClickBtn:(NSString *)text;

@end

@interface CCViewController : UIViewController

@property (nonatomic,assign)id<CCViewControllerDelegate> delegate;

@end
