//
//  MLScopeBusinessViewController.m
//  民乐支付
//
//  Created by SZVETRON-iMAC on 16/11/9.
//  Copyright © 2016年 SZVETRON-iMAC. All rights reserved.
//

#import "MLScopeBusinessViewController.h"
@interface MLScopeBusinessViewController ()
@property (nonatomic, strong) MLMyNavigationView *naView;
@property (nonatomic, strong) UILabel *lable;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation MLScopeBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUI
{
    [self.view addSubview:self.naView];
    [self.view addSubview:self.scrollView];
}

- (MLMyNavigationView *)naView
{
    if (!_naView) {
        _naView = [[MLMyNavigationView alloc] initWithFrame:CGRectMake(0, 0, widthss, 64) withColor:[UIColor whiteColor] withTitle:[CommenUtil LocalizedString:@"Account.ScopeBusiness"]];
    }
    return _naView;
}


- (UILabel *)lable
{
    if (!_lable) {
        CGFloat HH = [self onRect:self.business_scope withWidth:widthss-30];
        _lable = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, widthss-30, HH)];
        _lable.text = self.business_scope;
        _lable.numberOfLines = 0;
    }
    return _lable;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        CGFloat contentH = [self setTextHeight:self.lable textW:widthss-30].height;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, widthss, heightss-64)];
        _scrollView.contentSize = CGSizeMake(widthss, contentH+30);
        _scrollView.scrollEnabled = YES;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [_scrollView addSubview:self.lable];
        _scrollView.backgroundColor = RGB(231, 231, 231);
    }
    return _scrollView;
}


- (CGFloat)onRect:(NSString *)text withWidth:(CGFloat)w
{
    CGRect rect;
    //获取文字高度
    rect = [text boundingRectWithSize:CGSizeMake(w, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} context:nil];
    return rect.size.height;
}

//计算高度
- (CGSize)setTextHeight:(UILabel *)label textW:(CGFloat)textW
{
    CGSize size = CGSizeMake(textW, 0);
    NSDictionary *attribute = @{NSFontAttributeName: label.font};
    CGSize retSize = [label.text boundingRectWithSize:size
                                              options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                           attributes:attribute
                                              context:nil].size;
    
    return retSize;
}


@end
