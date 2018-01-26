//
//  LLToolBar.h
//  ReaderDemo
//
//  Created by 李璐 on 2018/1/26.
//  Copyright © 2018年 LULI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLToolBarProctol<NSObject>

-(void)outlineAction;

@end

@interface LLToolBar : UIView

@property(nonatomic,strong)IBOutlet UIButton * listB;

@property(nonatomic,strong)IBOutlet UIButton * readB;

@property(nonatomic,strong)IBOutlet UIButton * annotateB;

@property(nonatomic,strong)IBOutlet UIButton * signB;

@property(nonatomic,weak)id<LLToolBarProctol> eventDelegate;

+(LLToolBar*)toolBarWithDelegate:(id<LLToolBarProctol>)delegate;

@end
