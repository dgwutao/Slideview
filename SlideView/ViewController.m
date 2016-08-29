//
//  ViewController.m
//  SlideView
//
//  Created by Ghost on 8/29/16.
//  Copyright © 2016 axel. All rights reserved.
//

#import "ViewController.h"
#import "CATextLayerView.h"
#import "BitmapCreater.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CATextLayerView *textView1 = [[CATextLayerView alloc]initWithFrame:CGRectMake(0, 20.0f, [UIScreen mainScreen].bounds.size.width, 100.0f)];
    textView1.string = @"Core Animation 提供了一个叫 CATextLayer 的 CALayer 子类，它包含了 UILabel 中所有图层组成的字符串绘制特性，还增添了一些额外的特性……。 CATextLayer 也比 UILabel 渲染快。它在iOS6及之前是不为人知的事实， UIlabel 实际上使用 WebKit 来进行文本绘制，这在你绘制大量文本时带来显著的性能负担";
    
    CATextLayerView *textView2 = [[CATextLayerView alloc]initWithFrame:CGRectMake(0, 20.0f + textView1.frame.size.height, [UIScreen mainScreen].bounds.size.width, 100.0f)];
    textView2.string = @"深陷“邮件门”的美国下届总统候选人希拉里·克林顿的IT团队被传使用了一款名为BleachBit的开源软件删除了服务器上的电子邮件。而这款软件声称能够彻底粉碎文件和覆盖写入硬盘数据，从而实现文件的永久删除。";
    
    UIImageView *thirdView = [[UIImageView alloc]initWithFrame:CGRectZero];
    thirdView.backgroundColor = [UIColor whiteColor];
    [BitmapCreater createBitmapWithText:@"Postgres的副本并没有真正支持多版本并发控制（MVCC）。副本必须和主节点使用一致的预写式日志（WAL:Write Ahead Log）。加上如果更新操作涉及其他事务中已打开的行，Postgres会将其阻塞，这在很大程度上会影响长事务（long running transaction）。一旦长事务阻塞了预写式日志线程，就会被Postgres终止，如果应用开发人员没有意识到这点，特别是在使用事务边界不透" to:thirdView];
    //[self.view addSubview:textView1];
    //[self.view addSubview:textView2];
    [self.view addSubview:thirdView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
