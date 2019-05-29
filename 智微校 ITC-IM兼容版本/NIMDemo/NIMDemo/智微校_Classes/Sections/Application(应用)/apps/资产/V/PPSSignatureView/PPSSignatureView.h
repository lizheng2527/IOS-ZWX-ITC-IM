#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@protocol PPSSignatureViewDelegate <NSObject>

@end

@interface PPSSignatureView : GLKView

@property (assign, nonatomic) UIColor *strokeColor;
@property (assign, nonatomic) BOOL hasSignature;
@property (strong, nonatomic) UIImage *signatureImage;

- (void)erase;
@property(nonatomic,assign)id <PPSSignatureViewDelegate> delegateee;

@end
