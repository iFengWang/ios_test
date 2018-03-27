//
//  XSYQuickOperationView.h
//  ingage
//
//  Created by AJ-1993 on 2018/2/27.
//  Copyright © 2018年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XSYEntityDetailInterface.h"

@interface XSYQuickOperationView : UIView <XSYEntityDetailComponent>


- (void)selectedItem:(UIButton *)btn;

@end
