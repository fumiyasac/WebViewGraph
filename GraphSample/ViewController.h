//
//  ViewController.h
//  GraphSample
//
//  Created by 酒井文也 on 2015/02/06.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import <UIKit/UIKit.h>

//ListTableViewCellクラスを使うためにインポート
#import "ListTableViewCell.h"

@interface ViewController : UIViewController<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>

//グラフ表示用のWebView
@property (strong, nonatomic) IBOutlet UIWebView *graphWebView;

//データ表示用のTableView
@property (strong, nonatomic) IBOutlet UITableView *listTableView;

//表示グラフ切り替えのセグメントコントロール
@property (strong, nonatomic) IBOutlet UISegmentedControl *switchGraphSegment;

//セグメントコントロール切り替え時の関数
- (IBAction)changeGraphType:(UISegmentedControl *)sender;

@end

