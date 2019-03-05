//
//  XBTextView.m
//  XBTextView
//
//  Created by xxb on 16/4/13.
//  Copyright © 2016年 XXB. All rights reserved.
//

#import "XBTextView.h"
#import "Masonry.h"

#define textViewTextChange @"textViewTextChange"
//移除字符串中的空格
//把strNeedChange中的currentStr替换成repalceStr (NSString)
#define replaceString_currentStr_To_repalceStr_For_strNeedChange(currentStr,repalceStr,strNeedChange)\
[strNeedChange stringByReplacingOccurrencesOfString:currentStr withString:repalceStr]

//字符串是否为空
#define StringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

@interface XBTextView ()<UITextViewDelegate>

@property (assign,nonatomic) CGFloat textCountLabelHeight;

@property (strong, nonatomic)  UILabel *textCountLabel;

@end

@implementation XBTextView

+(XBTextView *)textViewWithPlaceHolder:(NSString *)placeHolder
{
    XBTextView *textView=[[XBTextView alloc] init];
    textView.placeHolder=placeHolder;
    textView.placeHolderTextColor=[[UIColor grayColor] colorWithAlphaComponent:0.5];
    textView.maxTextCount=200;
    return textView;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder])
    {
        [self initParamsFirst];
        [self setupSubviews];
        [self initParamsLast];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame])
    {
        [self initParamsFirst];
        [self setupSubviews];
        [self initParamsLast];
    }
    return self;
}

-(void)initParamsFirst
{
    self.backgroundColor=[UIColor whiteColor];
    self.textCountLabelHeight=13;
}

-(void)initParamsLast
{
    self.maxTextCount=200;
    self.placeHolderTextColor=[[UIColor grayColor] colorWithAlphaComponent:0.7];
}

-(void)setupSubviews
{
    self.textView=[[UITextView alloc] init];
    [self addSubview:self.textView];
    self.textView.returnKeyType=UIReturnKeyDone;
    
    self.textCountLabel=[[UILabel alloc] init];
    [self addSubview:self.textCountLabel];
    self.textCountLabel.font=[UIFont systemFontOfSize:13];
    self.textCountLabel.textColor=[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:0.5];
    
    self.clearBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.clearBtn];
    self.clearBtn.hidden=YES;
    [self.clearBtn setBackgroundImage:[UIImage imageNamed:@"quickPay_close"] forState:UIControlStateNormal];
    [self.clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.textCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-5);
        make.trailing.equalTo(self).offset(-5);
        make.height.mas_equalTo(self.textCountLabelHeight);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self);
        make.trailing.equalTo(self).offset(-10);
        make.bottom.equalTo(self.textCountLabel.mas_top);
    }];
    self.textView.delegate=self;
    
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(9);
        make.top.equalTo(self.textView).offset(-9);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
    }];
}

#pragma mark - 点击事件
-(void)clearBtnClick:(UIButton *)button
{
    self.text=@"";
}


#pragma mark - 方法重写
-(void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder=placeHolder;
    self.textView.text=placeHolder;
    
    [self refreshTextUI];
}

-(void)setPlaceHolderTextColor:(UIColor *)placeHolderTextColor
{
    _placeHolderTextColor=placeHolderTextColor;
    self.textView.textColor=placeHolderTextColor;
}

-(void)setMaxTextCount:(NSUInteger)maxTextCount
{
    _maxTextCount=maxTextCount;
    [self refreshTextUI];
}

-(void)setText:(NSString *)text
{
    self.textView.text=text;
    self.textView.textColor=[UIColor blackColor];
    
    if (StringIsEmpty(text))
    {
        [self setClearBtnStateHidden];
    }
    
    [self refreshTextUI];
}

-(NSString *)text
{
    return self.textView.text;
}


#pragma mark - 其他方法
-(void)refreshTextUI
{
    if ([self.textView.text isEqualToString:self.placeHolder])
    {
        self.textCountLabel.text=[NSString stringWithFormat:@"0/%ld",(unsigned long)self.maxTextCount];
    }
    else
    {
        self.textCountLabel.text=[NSString stringWithFormat:@"%ld/%ld",(unsigned long)self.textView.text.length,(unsigned long)self.maxTextCount];
    }
}

#pragma mark - textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(xbTextViewShouldBeginEditing:)])
    {
        [self.delegate xbTextViewShouldBeginEditing:self];
    }
    
    if ([self.textView.text isEqualToString:self.placeHolder])
    {
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(xbTextViewShouldEndEditing:)])
    {
        [self.delegate xbTextViewShouldEndEditing:self];
    }
    
    if (self.textView.text.length<1)
    {
        textView.text=self.placeHolder;
        textView.textColor=self.placeHolderTextColor;
    }
    
    if (StringIsEmpty(self.textView.text) || [self.textView.text isEqualToString:self.placeHolder]) {
        [self setClearBtnStateHidden];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>=self.maxTextCount) {
        textView.text=[textView.text substringToIndex:self.maxTextCount];
    }
    
    if (StringIsEmpty(self.textView.text)) {
        [self setClearBtnStateHidden];
    }
    else
    {
        [self setClearBtnStateShow];
    }
    
    [self refreshTextUI];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    [textView scrollRangeToVisible:range];
    return YES;
}


#pragma mark - 其他方法
-(BOOL)isNoContent
{
    //去除空格
//    NSString *textViewText=[self.textView.text removeEmptyStr];
    NSString *textViewText=replaceString_currentStr_To_repalceStr_For_strNeedChange(@" ", @"", self.textView.text);
    
    if ([textViewText isEqualToString:self.placeHolder] || [textViewText isEqualToString:@""] || textViewText.length<1)
    {
        return YES;
    }
    return NO;
}

-(void)setClearBtnStateHidden
{
    self.clearBtn.hidden=YES;
}
-(void)setClearBtnStateShow
{
    self.clearBtn.hidden=NO;
}
@end
