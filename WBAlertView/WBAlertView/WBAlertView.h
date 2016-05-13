//
//  WBAlertView.h


#import <UIKit/UIKit.h>


@class WBAlertView;
@protocol WBAlertViewDelegate <NSObject>
@optional

- (void)cancelButtonClickedOnAlertView:(WBAlertView *)alertView;
- (void)confirmButtonClickedOnAlertView:(WBAlertView *)alertView;

@end

@interface WBAlertView : UIView

@property (nonatomic, strong) id <WBAlertViewDelegate> delegate;

/** 自定义alert视图 */
@property (nonatomic, strong) UIView *contentView;
/** 自定义视图时是否隐藏按钮 */
@property (nonatomic, assign) BOOL hideButton;

/** 普通的alertView */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
           confirmButtonTitle:(NSString *)confirmButtonTitle;

/** 动画进度展示 */
- (instancetype)initWithProgressOfTitle:(NSString *)title;


/** 文字toast提醒 */
+ (void)showMessageToast:(NSString *)message toView:(UIView *)view;

- (void)show;
- (void)dismiss;

@end


