//
//  NSMutableArray+QueueAdditions.h
//  circleDial
//
//  Created by raymond chen on 2014-02-15.
//  Copyright (c) 2014 EvidencePix Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (QueueAdditions)
- (id) dequeue;
- (void) enqueue:(id)obj;
@end
