//
//  ViewController.m
//  ReaderDemo
//
//  Created by 李璐 on 2018/1/20.
//  Copyright © 2018年 LULI. All rights reserved.
//

#import "ViewController.h"
#import <PDFKit/PDFKit.h>
#import "LLTestView.h"
#import "LLToolBar.h"
#import "OutlineController.h"
#import "LLPDFView.h"

@interface ViewController ()<LLToolBarProctol>

@property(nonatomic,strong)LLPDFView * pdfview;

@property(nonatomic,strong)LLTestView * testView;

@property(nonatomic,strong)LLToolBar * toolBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat heightOfTool = 100;
    
    LLPDFView * pdfview = [[LLPDFView alloc]init];
    self.pdfview = pdfview;
    pdfview.displayMode = kPDFDisplaySinglePageContinuous;
    pdfview.displayDirection = kPDFDisplayDirectionHorizontal;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    pdfview.frame = CGRectMake(0, 0, screenSize.width, screenSize.height - heightOfTool);
    [self.view addSubview:pdfview];
    [pdfview usePageViewController:YES withViewOptions:nil];
    
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"sample" withExtension:@"pdf"];
    PDFDocument * pdfdocument = [[PDFDocument alloc]initWithURL:url];
    
    pdfview.document = pdfdocument;
    pdfview.displayMode = kPDFDisplaySinglePageContinuous;
    pdfview.autoScales = true;
    
    self.toolBar = [LLToolBar toolBarWithDelegate:self];
    [self.view addSubview:self.toolBar];
    self.toolBar.frame = CGRectMake(0, screenSize.height - heightOfTool, screenSize.width, heightOfTool);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:pan];
    
    [tap requireGestureRecognizerToFail:doubleTap];
    [tap requireGestureRecognizerToFail:pan];
    [pan requireGestureRecognizerToFail:doubleTap];
}

-(void)outlineAction
{
    NSMutableArray<NSArray<PDFAnnotation*>*>* annotationArr = [NSMutableArray array];
    NSArray<PDFPage*>* pageArray = [self allPageInDoc:self.pdfview.document];
    for (PDFPage * page in pageArray) {
        NSArray<PDFAnnotation*>* array = [page annotations];
        
        NSLog(@"%@",array);
        for (PDFAnnotation * annotation in array) {
            NSLog(@"%@",annotation.fieldName);
        }
        
        [annotationArr addObject:array];
    }
    
    OutlineController * control = [[OutlineController alloc]init];
    control.annotationArray = annotationArr;
    [self presentViewController:control animated:YES completion:nil];
}

-(NSArray<PDFPage*>*)allPageInDoc:(PDFDocument*)document
{
    NSMutableArray<PDFPage*>* pageArr = [NSMutableArray array];
    for (int i = 0; i < document.pageCount; i++) {
        PDFPage * page = [document pageAtIndex:i];
        [pageArr addObject:page];
    }
    return pageArr;
}

-(void)tapAction:(UITapGestureRecognizer*)tapGes
{
    UIMenuController * menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO];
    
    [self.testView removeFromSuperview];
    
    NSArray<PDFAnnotation*>* array = [self.pdfview.currentPage annotations];
    PDFAnnotation * annotate = [array firstObject];
    self.pdfview.activeAnnotate = annotate;
    [self.pdfview setNeedsDisplay];
//    [self insertTextWidget];
    /*
    //接下来做tap输入文字
    [self.textField removeFromSuperview];
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 100, 40)];
    [self.view addSubview:self.textField];
    self.textField.backgroundColor = [UIColor orangeColor];
    [self.textField becomeFirstResponder];
    self.textField.delegate = self;
    */
}

-(void)panAction:(UIPanGestureRecognizer*)ges
{
    if (ges.state == UIGestureRecognizerStateBegan) {
        //是否在拖动当前annotate
        CGPoint loactionInPDFView = [ges locationInView:self.pdfview];
        CGPoint locationInPDF = [self.pdfview convertPoint:loactionInPDFView toPage:self.pdfview.currentPage];
        CGRect activeFrame = self.pdfview.activeAnnotate.bounds;
        self.pdfview.isMove = YES;
//        BOOL isHit = CGRectContainsPoint(activeFrame, locationInPDF);
//        if (isHit) {
//            //移动active annotate
//            self.pdfview.isMove = YES;
//            NSLog(@"hit annote %@",NSStringFromCGPoint(locationInPDF));
//        }
//        else
//        {
//            //        [super touchesBegan:touches withEvent:event];
//            NSLog(@"没有hit annote");
//        }
    }
    else if (ges.state == UIGestureRecognizerStateChanged)
    {
        if (self.pdfview.isMove) {
            CGPoint loactionInPDFView = [ges locationInView:self.pdfview];
            CGPoint locationInPDF = [self.pdfview convertPoint:loactionInPDFView toPage:self.pdfview.currentPage];
            self.pdfview.activeAnnotate.bounds = CGRectMake(self.pdfview.activeAnnotate.bounds.origin.x - CGRectGetMidX(self.pdfview.activeAnnotate.bounds) + locationInPDF.x, self.pdfview.activeAnnotate.bounds.origin.y - CGRectGetMidY(self.pdfview.activeAnnotate.bounds) + locationInPDF.y, self.pdfview.activeAnnotate.bounds.size.width, self.pdfview.activeAnnotate.bounds.size.height);
            
            [self.pdfview setNeedsDisplayInRect:CGRectMake(loactionInPDFView.x-10, loactionInPDFView.y-10, self.pdfview.activeAnnotate.bounds.size.width, self.pdfview.activeAnnotate.bounds.size.height)];
        }
        else
        {
            NSLog(@"没有hit annote move");
        }
    }
    else if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateCancelled)
    {
        NSLog(@"结束pan手势");
        self.pdfview.isMove = NO;
    }
}

-(void)doubleTapAction:(UIGestureRecognizer*)ges
{
    NSLog(@"%s",__func__);
    
    UIMenuController * menu = [UIMenuController sharedMenuController];
    if (menu.menuVisible) {
        [menu setMenuVisible:NO];
        [self.testView removeFromSuperview];
    }
    else
    {
        CGPoint touchPoint = [ges locationInView:self.view];
        
        [self.testView removeFromSuperview];
        self.testView = [[LLTestView alloc]init];
        CGFloat width = 70;
        CGFloat height = 40;
        self.testView.frame = CGRectMake(touchPoint.x - width/2, touchPoint.y - height/2, width, height);
        [self.view addSubview:self.testView];
        self.testView.backgroundColor = [UIColor greenColor];
        
        [self.testView becomeFirstResponder];
        UIMenuItem * item1 = [[UIMenuItem alloc]initWithTitle:@"TextWidget" action:@selector(insertTextWidget)];
        UIMenuItem * item2 = [[UIMenuItem alloc]initWithTitle:@"Text" action:@selector(insertText)];
        menu.menuItems = @[item1,item2];
        
        [menu setTargetRect:CGRectMake(0, 0, 80, 50) inView:self.testView];
        
        [menu setMenuVisible:YES animated:YES];
    }
}

//PDFAnnotationSubtypeWidget
-(void)insertTextWidget
{
    [self.testView removeFromSuperview];
    
    PDFPage * page = self.pdfview.currentPage;
    
    CGRect frame = self.testView.frame;
    CGRect textFrameInPDF = [self.pdfview convertRect:frame toPage:page];
    
    PDFAnnotation * annotation = [[PDFAnnotation alloc]initWithBounds:textFrameInPDF forType:PDFAnnotationSubtypeWidget withProperties:nil];
    annotation.font = [UIFont systemFontOfSize:28];
    annotation.widgetFieldType = PDFAnnotationWidgetSubtypeText;
    annotation.alignment = NSTextAlignmentCenter;
    annotation.backgroundColor = [UIColor orangeColor];
    [page addAnnotation:annotation];
    [self.pdfview setNeedsDisplay];
}

-(void)insertText
{
    [self.testView removeFromSuperview];

    __weak typeof(self) weakSelf = self;
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"输入要插入的文本" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * textField = [[alert textFields] firstObject];
        
        NSString * string = textField.text;
        CGSize sizeOfString = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        PDFPage * page = weakSelf.pdfview.currentPage;
        CGRect frame = weakSelf.testView.frame;
        frame.size = sizeOfString;
        CGRect textFrameInPDF = [weakSelf.pdfview convertRect:frame toPage:page];
        PDFAnnotation * annotation = [[PDFAnnotation alloc]initWithBounds:textFrameInPDF forType:PDFAnnotationSubtypeFreeText withProperties:nil];
        annotation.font = [UIFont systemFontOfSize:14];
        annotation.contents = textField.text;
        annotation.alignment = NSTextAlignmentCenter;
        [page addAnnotation:annotation];
        [self.pdfview setNeedsDisplay];

    }];
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入文本";
    }];
    
    [alert addAction:cancleAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)insertCircle
{
    NSLog(@"%s",__func__);
    
    PDFPage * page = self.pdfview.currentPage;
    
    PDFAnnotation * annotation = [[PDFAnnotation alloc]initWithBounds:CGRectMake(0, 0, 500, 500) forType:PDFAnnotationSubtypeCircle withProperties:nil];
    annotation.font = [UIFont systemFontOfSize:18];
    annotation.fieldName = @"ll-fieldName";
    [page addAnnotation:annotation];
    
    [self.pdfview setNeedsDisplay];
}

@end
