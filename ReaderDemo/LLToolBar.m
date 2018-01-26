//
//  LLToolBar.m
//  ReaderDemo
//
//  Created by 李璐 on 2018/1/26.
//  Copyright © 2018年 LULI. All rights reserved.
//

#import "LLToolBar.h"

@implementation LLToolBar

+(LLToolBar*)toolBarWithDelegate:(id<LLToolBarProctol>)delegate
{
    UINib * nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    LLToolBar * view = [[nib instantiateWithOwner:nil options:nil] lastObject];
    view.eventDelegate = delegate;
    return view;
}
- (IBAction)outlineAction:(id)sender
{
    if ([self.eventDelegate respondsToSelector:@selector(outlineAction)]) {
        [self.eventDelegate outlineAction];
    }
}

@end
