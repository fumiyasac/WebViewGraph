//
//  ListTableViewCell.h
//  GraphSample
//
//  Created by 酒井文也 on 2015/02/06.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewCell : UITableViewCell

//色付きラベル
@property (strong, nonatomic) IBOutlet UILabel *colorText;

//詳細表示のテキスト
@property (strong, nonatomic) IBOutlet UILabel *detailText;

@end
