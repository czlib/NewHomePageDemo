//
//  MainViewController.h
//  BannerAndListTableView
//
//  Created by Derek on 26/06/18.
//  Copyright © 2018年 Derek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property (nonatomic,strong) NSString *myTitle;
-(void)postNetWorkingWithTitle:(NSString *)titleStr;
@end
