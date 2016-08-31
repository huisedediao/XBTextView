//
//  XBTextView.m
//  XBTextView
//
//  Created by xxb on 16/4/13.
//  Copyright © 2016年 XXB. All rights reserved.
//

#import "XBTextView.h"
#import "XBExtension.h"
#import "Masonry.h"

#define textViewTextChange @"textViewTextChange"

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
    if (self=[super initWithCoder:aDecoder]) {
        
    }
    return self;
}
-(instancetype)init
{
    if (self==[super init])
    {
        [self initParams];
        
        [self setupSubviews];
    }
    return self;
}

-(void)initParams
{
    self.textCountLabelHeight=13;
    
    self.maxTextCount=200;
}

-(void)setupSubviews
{
    self.textView=[[UITextView alloc] init];
    [self addSubview:self.textView];
    self.textView.returnKeyType=UIReturnKeyDone;
    
    self.textCountLabel=[[UILabel alloc] init];
    [self addSubview:self.textCountLabel];
    self.textCountLabel.font=[UIFont systemFontOfSize:13];
    self.textCountLabel.textColor=ColorRGBA(80, 80, 80, 0.5);
    
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
    XBFlog(@"");
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
    
    if ([text isNullOrEmpty])
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
    
    if ([self.textView.text isNullOrEmpty] || [self.textView.text isEqualToString:self.placeHolder]) {
        [self setClearBtnStateHidden];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>=self.maxTextCount) {
        textView.text=[textView.text substringToIndex:self.maxTextCount];
    }
    
    if ([self.textView.text isNullOrEmpty]) {
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
    NSString *textViewText=[self.textView.text removeEmptyStr];
    
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
