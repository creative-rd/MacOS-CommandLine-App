//
//  ImageDownloaderService.m
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/27/20.
//

#import "ImageDownloaderService.h"
#include <AppKit/AppKit.h>

@interface ImageDownloaderService()
@property(nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation ImageDownloaderService

+ (id)sharedService {
  static ImageDownloaderService *service = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    service = [[self alloc] init];
  });
  return service;
}

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
    if (error != nil) {
      dispatch_semaphore_signal(semaphore);
      failure(error);
    }
    if (response != nil) {
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSImage *image = [[NSImage alloc] initWithData: data];
        if (image)
          success(image);
          dispatch_semaphore_signal(semaphore);
      });
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