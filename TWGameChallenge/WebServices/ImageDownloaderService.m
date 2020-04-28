//
//  ImageDownloaderService.m
//

#import "ImageDownloaderService.h"
#include <AppKit/AppKit.h>

@interface ImageDownloaderService()
@property(nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation ImageDownloaderService

- (id)init {
  self = [super init];
  if (self) {
    _operationQueue = [[NSOperationQueue alloc] init];
    _operationQueue.maxConcurrentOperationCount = 3;
    _operationQueue.name = @"com.image.service";
    
    NSURLSessionConfiguration *sessionImageConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionImageConfiguration.timeoutIntervalForResource = 6;
    sessionImageConfiguration.HTTPMaximumConnectionsPerHost = 2;
    sessionImageConfiguration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;

    _imageSession = [NSURLSession sessionWithConfiguration:sessionImageConfiguration delegate: nil delegateQueue: _operationQueue];
  }
  return self;
}

- (NSURLSessionTask *)imageWithURL:(NSURL *)url
                           success:(void (^)(NSImage *image))success
                           failure:(void (^)(NSError *error))failure {
  
  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

  NSURLSessionTask *task = [_imageSession dataTaskWithURL: url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    if (error != nil) {
      dispatch_semaphore_signal(semaphore);
      NSLog(@"Failed to download image with url = %@ with status code = %ld", url, (long)httpResponse.statusCode);
      failure(error);
    }
    if (response != nil && httpResponse.statusCode == 200) {
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSImage *image = [[NSImage alloc] initWithData: data];
        if (image) {
          success(image);
          dispatch_semaphore_signal(semaphore);
        }
      });
    } else {
      failure(nil);
      dispatch_semaphore_signal(semaphore);
    }
  }];
  
  [task resume];
  
  if (![NSThread isMainThread]) {
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
  } else {
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
      [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    }
  }
  return task;
}

@end
