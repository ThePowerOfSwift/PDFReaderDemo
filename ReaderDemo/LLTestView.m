//
//  LLTestView.m
//  ReaderDemo
//
//  Created by 李璐 on 2018/1/24.
//  Copyright © 2018年 LULI. All rights reserved.
//

#import "LLTestView.h"

@implementation LLTestView

/**
 *  设置label可以成为第一响应者
 *
 *  @注意：不是每个控件都有资格成为第一响应者
 */
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
/**
 *  设置label能够执行那些具体操作
 *
 *  @param action 具体操作
 *
 *  @return YES:支持该操作
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    //    NSLog(@"%@",NSStringFromSelector(action));
    return YES;
    if(action == @selector(cut:) || action == @selector(copy:) || action == @selector(myCut:)|| action == @selector(myPaste:)) return YES;
    return NO;
}

@end
