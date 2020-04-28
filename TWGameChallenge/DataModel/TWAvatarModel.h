//
//  AvatarModel.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWAvatarModel : NSObject

- (instancetype) initWithAvatarData: (NSString *)name andURL: (NSString *)url;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;

@end

NS_ASSUME_NONNULL_END
