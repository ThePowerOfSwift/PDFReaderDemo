//
//  LLOverlayView.h
//  ReaderDemo
//
//  Created by 李璐 on 2018/2/5.
//  Copyright © 2018年 LULI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>

@interface LLOverlayView : UIView

@property(nonatomic,strong)NSArray<PDFAnnotation*>* annotations;

@end
