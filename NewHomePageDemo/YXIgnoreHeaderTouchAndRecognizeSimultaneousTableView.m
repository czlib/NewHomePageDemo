//
//  YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView.m
//  商品详情页
//
//  Created by
//  Copyright © All rights reserved.
//

#import "YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView.h"

@implementation YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
