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

typedef NS_ENUM(NSInteger, MoveType) {
    MoveType_None = 0,
    MoveType_Move = 1,
    MoveType_Scale = 2,
};

@interface ViewController ()<LLToolBarProctol>

@property(nonatomic,strong)LLPDFView * pdfview;

@property(nonatomic,strong)LLTestView * testView;

@property(nonatomic,strong)LLToolBar * toolBar;

@property(nonatomic, assign)MoveType moveType;

@property(nonatomic, assign) CGPoint lastTouchPoint;

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

#pragma mark 点击选中annotate
-(void)tapAction:(UITapGestureRecognizer*)ges
{
    UIMenuController * menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO];
    
    [self.testView removeFromSuperview];
    
    CGPoint locationInPDFView = [ges locationInView:self.pdfview];
    CGPoint locationInPDF = [self.pdfview convertPoint:locationInPDFView toPage:self.pdfview.currentPage];
    
    BOOL haveHit = NO;
    NSArray<PDFAnnotation*>* array = [self.pdfview.currentPage annotations];
    for (PDFAnnotation * annotate in array) {
        BOOL isHit = CGRectContainsPoint(annotate.bounds, locationInPDF);
        if (isHit) {
            if ([self.pdfview.activeAnnotate isEqual:annotate]) {
                self.pdfview.activeAnnotate = nil;
            }
            else
            {
                self.pdfview.activeAnnotate = annotate;
            }
            [self.pdfview setNeedsDisplayInRect:self.pdfview.activeAnnotate.bounds];
            haveHit = YES;
            break;
        }
    }
    if (!haveHit) {
        PDFAnnotation * annotate = self.pdfview.activeAnnotate;
        self.pdfview.activeAnnotate = nil;
        [self.pdfview setNeedsDisplayInRect:annotate.bounds];
    }
}

#pragma mark 拖动annotate
-(void)panAction:(UIPanGestureRecognizer*)ges
{
    if (ges.state == UIGestureRecognizerStateBegan) {
        //是否在拖动当前annotate
        CGPoint locationInPDFView = [ges locationInView:self.pdfview];
        CGPoint locationInPDF = [self.pdfview convertPoint:locationInPDFView toPage:self.pdfview.currentPage];
        self.moveType = [self moveType:locationInPDF annotate:self.pdfview.activeAnnotate inPDF:self.pdfview];
        self.lastTouchPoint = locationInPDF;
    }
    else if (ges.state == UIGestureRecognizerStateChanged)
    {
        CGPoint loactionInPDFView = [ges locationInView:self.pdfview];
        CGPoint locationInPDF = [self.pdfview convertPoint:loactionInPDFView toPage:self.pdfview.currentPage];

        switch (self.moveType) {
            case MoveType_Move:
            {
                self.pdfview.activeAnnotate.bounds = CGRectMake(self.pdfview.activeAnnotate.bounds.origin.x - CGRectGetMidX(self.pdfview.activeAnnotate.bounds) + locationInPDF.x, self.pdfview.activeAnnotate.bounds.origin.y - CGRectGetMidY(self.pdfview.activeAnnotate.bounds) + locationInPDF.y, self.pdfview.activeAnnotate.bounds.size.width, self.pdfview.activeAnnotate.bounds.size.height);
                
                [self.pdfview setNeedsDisplayInRect:self.pdfview.activeAnnotate.bounds];
            }
                break;
            case MoveType_Scale:
            {
                CGSize scaleSize = CGSizeMake(locationInPDF.x - self.lastTouchPoint.x, locationInPDF.y - self.lastTouchPoint.y);
                CGRect bounds = self.pdfview.activeAnnotate.bounds;
                bounds.size = CGSizeMake(bounds.size.width + scaleSize.width, bounds.size.height + scaleSize.height);
                self.pdfview.activeAnnotate.bounds = bounds;
                [self.pdfview setNeedsDisplayInRect:self.pdfview.activeAnnotate.bounds];
                
                self.lastTouchPoint = locationInPDF;
            }
                break;
            case MoveType_None:
            {
                //
            }
                break;
        }
    }
    else if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateCancelled)
    {
        NSLog(@"结束pan手势");
        self.moveType = MoveType_None;
    }
}

-(MoveType)moveType:(CGPoint)locationInPDF annotate:(PDFAnnotation*)annotate inPDF:(PDFView*)pdfview
{
    //1.检查是否命中周边缩放区域
    CGFloat widthOfScale = [pdfview convertRect:CGRectMake(0, 0, 100, 100) toPage:self.pdfview.currentPage].size.width;
    CGFloat originYOfScale = CGRectGetMaxY(annotate.bounds) - widthOfScale/2;
    CGFloat originXOfScale = CGRectGetMaxX(annotate.bounds) - widthOfScale/2;
    CGRect rectOfScale = CGRectMake(originXOfScale, originYOfScale, widthOfScale, widthOfScale);
    
    BOOL isHit = CGRectContainsPoint(rectOfScale, locationInPDF);
    if (isHit) {
        NSLog(@"判断为scale");
        return MoveType_Scale;
    }
    
    //2.检查是否命中annotate
    isHit = CGRectContainsPoint(annotate.bounds, locationInPDF);
    if (isHit) {
        NSLog(@"判断为move");
        return MoveType_Move;
    }
    
    return MoveType_None;
}
#pragma mark 工具栏action
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

#pragma mark 双击
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

#pragma mark 插入annotate
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
