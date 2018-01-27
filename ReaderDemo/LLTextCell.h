//
//  LLTextCell.h
//  ReaderDemo
//
//  Created by 李璐 on 2018/1/27.
//  Copyright © 2018年 LULI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLTextCell : UITableViewCell

@property(nonatomic,strong)NSString * text;

+(LLTextCell*)cellWithTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;
@end
