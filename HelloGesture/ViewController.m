//
//  ViewController.m
//  HelloGesture
//
//  Created by XueXin Tsai on 2016/5/16.
//  Copyright © 2016年 XueXin Tsai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong,nonatomic) NSMutableArray * fonts;
@property (nonatomic) NSUInteger currentFontIndex;
@property (nonatomic) CGFloat currentFontSize;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 字型初始化
    self.fonts = [NSMutableArray array];
    // 詢訪所有的字型
    for (NSString * familyName in [UIFont familyNames]) {
        for (NSString * fontname in [UIFont fontNamesForFamilyName:familyName]) {
            [self.fonts addObject:fontname];
        }
    }
    
    // 字型設定在第 0 個
    self.currentFontIndex = 0;
    
    // 字型大小預設為 12
    self.currentFontSize = 12.0;
    
    // 更新畫面上的文字
    [self refreshDisplayText];
    
    //Swipe （滑動）
    UISwipeGestureRecognizer * leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeFont:)];
    //設定往左滑動
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    //向右滑動
    UISwipeGestureRecognizer * rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeFont:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.label addGestureRecognizer:leftSwipeGesture];
    [self.label addGestureRecognizer:rightSwipeGesture];
    
    
    //pinch
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(changeFontSize:)];
    [self.label addGestureRecognizer:pinch];
    
    //DoubleTap
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeText)];
    tap.numberOfTapsRequired = 2;
    [self.label addGestureRecognizer:tap];
    
}

-(void)refreshDisplayText {
    //從陣列中拿到字型的名稱
    NSString * fontname = [self.fonts objectAtIndex:self.currentFontIndex];
    //將字型的名稱轉成字體
    UIFont * font = [UIFont fontWithName:fontname size:self.currentFontSize];
    //將字型指定給Label
    self.label.font = font;
}

-(void)changeText {
    // 準備警告窗
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"請輸入新的文字" message:nil preferredStyle:UIAlertControllerStyleAlert];
    // 加文字框在警告視窗上
    [alertController addTextFieldWithConfigurationHandler:nil];
    // 準備警告視窗上的按鈕
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 取得警告視窗上的文字框
        UITextField * textField = alertController.textFields[0];
        // 將文字框上的文字指給 Label
        self.label.text = textField.text;
    }];
    // 將按鈕加到視窗上
    [alertController addAction:action];
    // 顯示警告視窗
    [self presentViewController:alertController animated:true completion:nil];
}

-(void)changeFontSize:(UIPinchGestureRecognizer*)pinch
{
    self.currentFontSize *= pinch.scale;
    pinch.scale = 1.0;
    [self refreshDisplayText];
}

-(void)changeFont:(UISwipeGestureRecognizer*)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        //前進到下一個字體
        if (self.currentFontIndex<_fonts.count) {
            self.currentFontIndex += 1;
        }
        
    } else {
        //回到前一個字體
        if (self.currentFontIndex > 0) {
            self.currentFontIndex -= 1;
        }
        
    }
    [self refreshDisplayText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
