//
//  JWAppIconUpdate.m
//  JWAppIconUpdate
//
//  Created by Justin.wang on 2018/2/2.
//

#import "JWAppIconUpdate.h"
#import <objc/runtime.h>

@interface UIViewController (JWAppIconUpdate)


@end

@implementation UIViewController (JWAppIconUpdate)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod(self.class, @selector(presentViewController:animated:completion:));
        Method swizzMethod = class_getInstanceMethod(self.class, @selector(gs_presentViewController:animated:completion:));
        method_exchangeImplementations(originMethod, swizzMethod);
    });
}

- (void)gs_presentViewController:(UIViewController *)viewController
                        animated:(BOOL)animated
                      completion:(void (^)(void))completion {
    if ([viewController isKindOfClass:[UIAlertController class]]) {
        UIAlertController *alertController = (UIAlertController *)viewController;
        if (alertController.actions.count == 1 &&
            alertController.childViewControllers.count == 1) {
            NSString *actionTitle = [alertController.actions firstObject].title;
            NSString *message = [[alertController.childViewControllers firstObject] valueForKeyPath:@"_messageLabel.text"];
            if ([actionTitle isEqualToString:@"好"] &&
                [message containsString:@"的图标"] &&
                [message containsString:@"您已更改"]) {
                return;
            }
            if ([actionTitle isEqualToString:@"OK"] &&
                [message containsString:@"You have changed the icon for"]) {
                return;
            }
        }
    }
    [self gs_presentViewController:viewController animated:animated completion:completion];
}

@end


@implementation UIApplication (JWAppIconUpdate)

- (void)updateAppIconWithName:(NSString *)name {
    NSString *version = [[UIDevice currentDevice] systemVersion];
    if ([version compare:@"10.3" options:NSNumericSearch] == NSOrderedAscending) {
        return;
    }
    
    if (![self supportsAlternateIcons]) {
        return;
    }
    
    if ([name isEqualToString:@""]) {
        name = nil;
    }
    
    if ([[self alternateIconName] isEqualToString:name]) {
        return;
    }
    
    if (![self alternateIconName] && !name) {
        return;
    }
    
    [self setAlternateIconName:name completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换app图标发生错误了 ： %@",error);
        }
    }];
}

@end
