//
//  XBTextView.h
//  XBTextView
//
//  Created by xxb on 16/4/13.
//  Copyright © 2016年 XXB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XBTextView;
@protocol XBTextViewDelegate <NSObject>

-(void)xbTextViewShouldBeginEditing:(XBTextView *)xbTextView;
-(void)xbTextViewShouldEndEditing:(XBTextView *)xbTextView;

@end




@interface XBTextView : UIView

@property (strong, nonatomic)  UITextView *textView;

@property (strong,nonatomic) UIButton *clearBtn;

/** 占位文字:placeHolder */
@property (copy,nonatomic) NSString *placeHolder;

/** 占位文字的颜色,默认灰色 */
@property (strong,nonatomic) UIColor *placeHolderTextColor;

/** 最大输入文字,如果未设置,默认200 */
@property (assign,nonatomic) NSUInteger maxTextCount;

/** 内容 */
@property (copy,nonatomic) NSString *text;

/** 创建textView */
+(XBTextView *)textViewWithPlaceHolder:(NSString *)placeHolder;


/**
 * 未填写内容
 */
@property (assign,nonatomic,getter=isNoContent) BOOL noContent;

@property (nonatomic,weak) id <XBTextViewDelegate> delegate;

@end
