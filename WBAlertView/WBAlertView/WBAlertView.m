//
//  WBAlertView.m


#import "WBAlertView.h"

#define IS_IOS_8_OR_HIGHER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define WBDefaultColor  [UIColor colorWithRed:255/255.f green: 163/255.f blue:64/255.f alpha:1.000] //默认主题颜色

#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define alertWidth      250
#define alertHeight     150
#define buttonHeight    35      // 按钮高度
#define titleHeight     35      // 标题高度
#define blackMaskAlpha  0.5     // 蒙版透明度
#define viewPadding     15 // 间隙


@interface WBAlertView ()
{
    CGFloat     _alertWidth;
    CGFloat     _alertHeight;

    UIView      *_blackMaskView;    // 黑色背景蒙版
    UILabel     *_titleLabel;       // 标题
    UILabel     *_messageLabel;     // 内容
    UIButton    *_cancelButton;     // 取消按钮
    UIButton    *_confirmButton;    // 确定按钮
    
    BOOL    _hasContentView;    // 是否添加了自定义视图
    BOOL    _hasHideButton;     // 是否隐藏按钮
    
    
    UITableView      *_tableView;
    UICollectionView *_collectionView;
}

@end

@implementation WBAlertView


#pragma mark - 图片progress

- (instancetype)initWithProgressOfTitle:(NSString *)title {
    
    _alertWidth = 96;
    _alertHeight = 96 + 30;
    
    self = [super initWithFrame:CGRectMake(0, 0, _alertWidth, _alertHeight)];
    if (self) {

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 98)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.userInteractionEnabled = YES;
        
        CGPoint center = CGPointMake(_alertWidth/2, imageView.frame.size.height/2);
        imageView.center = center;
        
        NSMutableArray *imageAarry = [NSMutableArray array];
        for (int i = 1; i < 13; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"bei%d",i]];
            [imageAarry addObject:image];
        }
        imageView.animationImages = imageAarry;
        imageView.animationDuration = 0.3;
        imageView.animationRepeatCount = 0;
        [imageView startAnimating];
        
        // 内容
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(-50, _alertHeight - 30, _alertWidth+80, 30)];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:13];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [imageView addSubview: label];
        
        self.contentView  = imageView;
    }
    return self;
}

#pragma mark - 加载失败时展示图片提醒

+ (void)showNoDataImageToastToView:(UIView *)view {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 2;
    titleLabel.tag = 9999;
    titleLabel.text = @"正在努力制作中\n敬请期待哦～";
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = CGPointMake(SCREEN_WIDTH*0.5, SCREEN_HEIGHT*0.3);
    [view addSubview:titleLabel];
    
    // 150 200
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90*1.3)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.userInteractionEnabled = YES;
    
    NSMutableArray *imageAarry = [NSMutableArray array];
    for (int i = 1; i < 13; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"bei%d",i]];
        [imageAarry addObject:image];
    }
    imageView.animationImages = imageAarry;
    imageView.animationDuration = 0.3;
    imageView.animationRepeatCount = 0;
    imageView.tag = 9999;
    imageView.center = CGPointMake(SCREEN_WIDTH*0.5, SCREEN_HEIGHT*0.45);
    [imageView startAnimating];
    [view addSubview:imageView];
}

#pragma mark - 文字提醒

+ (void)showMessageToast:(NSString *)message toView:(UIView *)view {
    
    UILabel *toastLabel = [[UILabel alloc] init];
    toastLabel.frame = CGRectMake(0, 0, 200, 35);
    toastLabel.backgroundColor = [UIColor colorWithRed:0.118 green:0.125 blue:0.157 alpha:1.000];
    toastLabel.text = message;
    toastLabel.textColor = [UIColor whiteColor];
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.layer.masksToBounds = YES;
    toastLabel.layer.cornerRadius = 8;
    toastLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:toastLabel];

    CGSize size = [message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, toastLabel.frame.size.height)
                                        options: NSStringDrawingTruncatesLastVisibleLine
                                     attributes:@{ NSFontAttributeName:toastLabel.font }
                                        context:nil].size;
    CGRect frame = toastLabel.frame;
    frame.size.width = size.width + 40;
    toastLabel.frame = frame;
    
    CGPoint center = toastLabel.center;
    center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*0.7);
    toastLabel.center = center;
    
    toastLabel.alpha = 0.3;
    [UIView animateWithDuration:0.5 animations:^{
        toastLabel.alpha = 1;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            toastLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [toastLabel removeFromSuperview];
        }];
    });
}

#pragma mark - 普通的alert

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)otherButtonTitle {
    
    _alertWidth = alertWidth;
    _alertHeight = alertHeight;
    
    self = [super initWithFrame:CGRectMake(0, 0, _alertWidth, _alertHeight)];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.cornerRadius = 5;
        
        // 默认不隐藏按钮
        _hasHideButton = NO;

        // 标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.text = title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        
        // 内容
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.text = message;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor blackColor];
        
        // 取消按钮
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.layer.cornerRadius = 5;
        _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:WBDefaultColor];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // 确定按钮
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.layer.cornerRadius = 5;
        _confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_confirmButton setTitle:otherButtonTitle forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setBackgroundColor:WBDefaultColor];
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - 视图出现/消失

- (void)show {

    UIView *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *superView = IS_IOS_8_OR_HIGHER ? window : ([[window subviews] lastObject]);
    
    _blackMaskView = [[UIView alloc] initWithFrame:window.bounds];
    _blackMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:blackMaskAlpha];
    [_blackMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchViewRestureRecognizer:)]];

    [superView addSubview:_blackMaskView];
    
    // 刷新frame
    [self reloadFrame];
    
    // 内容label适配
    if (_titleLabel.text) {
        [_messageLabel sizeToFit];
        CGRect myFrame = _messageLabel.frame;
        myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, _alertWidth -  2 * viewPadding, myFrame.size.height);
        _messageLabel.frame = myFrame;
    }
    
    // 设置隐藏标题和内容
    if (!_hasContentView) {
        [self addSubview:_titleLabel];
        [self addSubview:_messageLabel];
    }
    
    // 设置隐藏按钮
    if (!_hasHideButton) {
        [self addSubview:_cancelButton];
        [self addSubview:_confirmButton];
    }
    
    self.frame = CGRectMake((superView.frame.size.width - self.frame.size.width )/2,
                            (superView.frame.size.height - self.frame.size.height) /2,
                            self.frame.size.width,
                            self.frame.size.height);
    
    
    [superView addSubview:self];
    
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    self.alpha = 0.6;

    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    }];
}

// 触摸事件
- (void)touchViewRestureRecognizer:(UITapGestureRecognizer*)recognizer {
    [self dismiss];
}

- (void)dismiss {
    
    self.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    if (_blackMaskView) {
        [UIView animateWithDuration:0.1 animations:^{
            _blackMaskView.alpha = 0;
        } completion:^(BOOL finished) {
            [_blackMaskView removeFromSuperview];
        }];
    }
}

#pragma mark - 刷新控件frame

- (void)reloadFrame {

    if (!_hasContentView) {
        
        _titleLabel.frame = _titleLabel.text ? CGRectMake(viewPadding, 5, _alertWidth - viewPadding * 2, titleHeight) : CGRectZero;
        
        // 根据内容文字长度来计算视图高度
        CGFloat messageHeight = [_messageLabel.text boundingRectWithSize:CGSizeMake(_alertWidth - viewPadding * 2, FLT_MAX)
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName:_messageLabel.font}
                                                                 context:nil].size.height;
        
        _alertHeight = messageHeight + _titleLabel.frame.size.height + buttonHeight + viewPadding*3;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _alertHeight);
        
        
        _messageLabel.frame = _messageLabel.text ? CGRectMake(viewPadding,
                                                              _titleLabel.frame.size.height + viewPadding,
                                                              _alertWidth - viewPadding * 2,
                                                              messageHeight) : CGRectZero;
    }

    _cancelButton.frame = _cancelButton.titleLabel.text ? CGRectMake(viewPadding,
                                                                     _alertHeight - buttonHeight - viewPadding,
                                                                     _alertWidth / 2 - viewPadding*2,
                                                                     buttonHeight) : CGRectZero;
    
    _confirmButton.frame = _cancelButton.titleLabel.text ?  CGRectMake(_alertWidth / 2 + viewPadding,
                                                            _alertHeight - buttonHeight - viewPadding,
                                                            _alertWidth / 2 - viewPadding*2,
                                                            buttonHeight) : CGRectMake(_alertWidth*0.25,
                                                                                       _alertHeight - buttonHeight - viewPadding,
                                                                                       _alertWidth*0.5,
                                                                                       buttonHeight);
}

#pragma mark - 重写set方法

- (void)setContentView:(UIView *)contentView {
    
    _hasContentView = YES;
    _alertWidth  = contentView.frame.size.width;
    _alertHeight = contentView.frame.size.height;

    contentView.frame = contentView.bounds;
    
    // 可以根据tag来设置特殊颜色
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _alertWidth, _alertHeight);

    [self addSubview:contentView];
    
    [self reloadFrame];

}

- (void)setHideButton:(BOOL)hideButton {
    _hasHideButton = hideButton;
}

#pragma mark - 代理方法

- (void)cancelButtonClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(cancelButtonClickedOnAlertView:)]) {
        [self.delegate cancelButtonClickedOnAlertView:self];
    }
    
    [self dismiss];
}

- (void)confirmButtonClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(confirmButtonClickedOnAlertView:)]) {
        [self.delegate confirmButtonClickedOnAlertView:self];
    }
    
    [self dismiss];
}

@end
