//
//  LLAnnotationTextField.h
//  ReaderDemo
//
//  Created by 李璐 on 2018/2/7.
//  Copyright © 2018年 LULI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <PDFKit/PDFKit.h>

@interface LLAnnotationTextField : NSObject

@property(nonatomic,strong)PDFAnnotation * annotate;

@property(nonatomic,strong)PDFView * pdfview;

@property(nonatomic,strong)UITextField * textField;

-(instancetype)init NS_UNAVAILABLE;

-(instancetype)initWithAnnotate:(PDFAnnotation*)annotate pdfview:(PDFView*)pdfview NS_DESIGNATED_INITIALIZER;
@end
