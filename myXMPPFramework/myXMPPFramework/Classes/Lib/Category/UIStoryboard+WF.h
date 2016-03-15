

#import <UIKit/UIKit.h>

@interface UIStoryboard (WF)

/**
 * 1.显示Storybaord的第一个控制器到窗口
 */
+(void)showInitialVCWithName:(NSString *)name;
+(id)initialVCWithName:(NSString *)name;
@end
