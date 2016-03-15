

#import "UIScreen+WF.h"

@implementation UIScreen (WF)

-(CGFloat)screenH{
    return [UIScreen mainScreen].bounds.size.height;
}

-(CGFloat)screenW{
    return [UIScreen mainScreen].bounds.size.width;
}

@end
