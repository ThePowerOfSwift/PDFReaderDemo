//
//  OutlineController.h
//  ReaderDemo
//
//  Created by 李璐 on 2018/1/26.
//  Copyright © 2018年 LULI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>

@interface OutlineController : UIViewController

@property(nonatomic,strong)NSArray<NSArray<PDFAnnotation*>*>* annotationArray;
@end
