//
//  LLTextCell.m
//  ReaderDemo
//
//  Created by 李璐 on 2018/1/27.
//  Copyright © 2018年 LULI. All rights reserved.
//

#import "LLTextCell.h"

@interface LLTextCell()

@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation LLTextCell

+(LLTextCell*)cellWithTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath
{
    UINib * nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

-(void)setText:(NSString *)text
{
    _text = text;
    
    self.label.text = text;
}

@end
