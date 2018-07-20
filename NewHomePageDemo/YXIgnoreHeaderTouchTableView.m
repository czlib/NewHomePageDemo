//
//  YXIgnoreHeaderTouchTableView.m
//  商品详情页
//
//  Created by 
//  Copyright ©. All rights reserved.
//

#import "YXIgnoreHeaderTouchTableView.h"

@implementation YXIgnoreHeaderTouchTableView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.tableHeaderView && CGRectContainsPoint(self.tableHeaderView.frame, point)) {
        return NO;

    }
    return [super pointInside:point withEvent:event];
}

@end
