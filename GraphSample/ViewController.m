//
//  ViewController.m
//  GraphSample
//
//  Created by 酒井文也 on 2015/02/06.
//  Copyright (c) 2015年 just1factory. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    //グラフの選択フラグ
    NSString *graphSelectFlag;
    
    //サンプルデータ格納用メンバ変数
    int fetchCount;
    NSArray *dataArray;
    NSArray *colorArray;
}
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //メンバ変数を設定する
    fetchCount = 3;
    dataArray  = @[@"740",@"580",@"340"];
    colorArray = @[@"f8c6c7",@"f2cb24",@"87c9a3"];
    
    //忘れずデリゲート（webViewDidFinishLoadを拾うため）
    self.graphWebView.delegate = self;
    
    //忘れずデリゲート（tableViewを使用するため）
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    
    //セグメントの初期値を取る
    self.switchGraphSegment.selectedSegmentIndex = 0;
    
    //最初はバーチャートを表示
    [self initializeBarChart];
    
    //グラフチャートを表示する
    NSString *path = [[NSBundle mainBundle]pathForResource:@"barchart" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.graphWebView loadRequest:req];
    
    //テーブルセルのxibファイルを読み込む
    UINib *nib = [UINib nibWithNibName:@"ListTableViewCell" bundle:nil];
    [self.listTableView registerNib:nib forCellReuseIdentifier:@"dataCell"];
}

//ウェブビューが読み込み完了の際に実行される関数
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //対象年月のバーチャートを設定する
    if(self.switchGraphSegment.selectedSegmentIndex == 0){
        
        //バーチャートを呼び出す
        [self initializeBarChart];
        
    }else if(self.switchGraphSegment.selectedSegmentIndex == 1){
        
        //パイチャートを呼び出す
        [self initializePieChart];
        
    }
}

//ロード時に呼び出されて、セクション内のセル数を返す ※必須
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return fetchCount;
}

//ロード時に呼び出されて、セクション内のセル数を返す ※必須
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//ロード時に呼び出されて、セルの内容を返す ※任意
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //ListTableViewCellクラスのセルレイアウトを呼び出して、Identifierを’dataCell’という名前で設定
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dataCell" forIndexPath:indexPath];
    
    //色付きテキスト(ListTableViewCell.xib参照)
    int countNumber = (int)indexPath.row + 1;
    cell.colorText.text = [NSString stringWithFormat:@"SAMPLE%d", countNumber];
    
    //詳細テキスト(ListTableViewCell.xib参照)
    cell.detailText.text = [NSString stringWithFormat:@"%d番目のデータ [%@]", countNumber, dataArray[indexPath.row]];
    
    //クリック時のハイライトをオフにする
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //アクセサリタイプの指定
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

//セルの高さを返す ※任意
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 59.0;
}

//バーチャートの描画を実行する
- (void)initializeBarChart {
    
    //バーチャートを作成するJavaScriptの関数に入れるデータを作成する
    NSString *initBarChart = [NSString stringWithFormat:@"drawBarChart(['SAMPLE1','SAMPLE2','SAMPLE3'],[%@,%@,%@]);", dataArray[0], dataArray[1], dataArray[2]];
        
    //バーチャートを作成するJavaScriptの関数に、変数initBarChartを入れて実行
    [self.graphWebView stringByEvaluatingJavaScriptFromString:initBarChart];
}

//パイチャートの描画を実行する
- (void)initializePieChart {
    
    //連結文字列の初期値を設定する
    NSString *targetString = @"";
    
    for(int i=0; i<dataArray.count; i++){
        
        //データが2つ以上の場合
        int counter = i + 1;
        NSString *targetSampleString = [NSString stringWithFormat:@"SAMPLE%d", counter];
        
        //今回は3つしかデータがないけど、連結文字列の変数に順次文字列をつなげていく
        if(i == 0){
            
            targetString = [targetString stringByAppendingString:[NSString stringWithFormat:@"[{value:%@,color:'#%@',label:'%@'},", dataArray[i], colorArray[i], targetSampleString]];
            
        }else if(i == dataArray.count - 1){
            
            targetString = [targetString stringByAppendingString:[NSString stringWithFormat:@"{value:%@,color:'#%@',label:'%@'}]", dataArray[i], colorArray[i], targetSampleString]];
            
        }else{
            
            targetString = [targetString stringByAppendingString:[NSString stringWithFormat:@"{value:%@,color:'#%@',label:'%@'},", dataArray[i], colorArray[i], targetSampleString]];
            
        }
    }
    
    //パイチャートを作成するJavaScriptの関数に入れるデータを作成する
    NSString *initPieChart = [NSString stringWithFormat:@"drawPieChart(%@);", targetString];
    
    //パイチャートのデータをinitする
    [self.graphWebView stringByEvaluatingJavaScriptFromString:initPieChart];
}

//セグメントコントロールクリック時に実行される
- (IBAction)changeGraphType:(UISegmentedControl *)sender {
    
    NSString *path = [NSString new];
    
    //セグメントコントロールのインデックス値で表示するグラフを決定する
    switch (sender.selectedSegmentIndex) {
        case 0:
            path = [[NSBundle mainBundle]pathForResource:@"barchart" ofType:@"html"];
            break;
        case 1:
            path = [[NSBundle mainBundle]pathForResource:@"piechart" ofType:@"html"];
            break;
    }
    
    //ローカルのHTMLファイルを描画する
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.graphWebView loadRequest:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
