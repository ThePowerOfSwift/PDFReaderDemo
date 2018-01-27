//
//  LLPDFView.h
//  ReaderDemo
//
//  Created by 李璐 on 2018/1/27.
//  Copyright © 2018年 LULI. All rights reserved.
//

#import <PDFKit/PDFKit.h>

@interface LLPDFView : PDFView

@property(nonatomic,strong)PDFAnnotation * activeAnnotate;

@end
