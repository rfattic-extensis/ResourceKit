//
// MIT License
//
// Copyright (c) 2017 Tom Hancocks
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import "RKType.h"
#import "RKResource.h"

@implementation RKType {
    __strong NSString *_code;
    __strong NSMutableArray <RKResource *> *_resources;
}

#pragma mark - Initialisers

+ (nonnull instancetype)withCode:(nonnull NSString *)code
{
    RKType *type = RKType.new;
    type->_code = code.copy;
    type->_resources = NSMutableArray.new;
    return type;
}


#pragma mark - Calculated Properties

- (NSUInteger)resourceCount
{
    return _resources.count;
}

- (NSString *)code
{
    return _code.copy;
}

- (NSArray<RKResource *> *)allResources
{
    return _resources.copy;
}


#pragma mark - Equality

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    else if (![object isMemberOfClass:self.class]) {
        return NO;
    }
    else {
        return [self.code isEqual:((RKType *)object).code];
    }
}

- (BOOL)isEqualTo:(id)object
{
    return [self isEqual:object];
}


#pragma mark - Resource Management

- (void)addResource:(nonnull RKResource *)resource
{
    [self addResource:resource replacingDuplicates:YES];
}

- (void)addResource:(nonnull RKResource *)resource replacingDuplicates:(BOOL)replaceDuplicates
{
    if (![resource.type isEqual:self]) {
        return;
    }
    
    if (!replaceDuplicates && [_resources containsObject:resource]) {
        return;
    }
    
    [_resources removeObject:resource];
    [resource switchTypeTo:self];
    [_resources addObject:resource];
}

- (void)mergeType:(nonnull RKType *)type
{
    [self mergeType:type replacingDuplicates:YES];
}

- (void)mergeType:(nonnull RKType *)type replacingDuplicates:(BOOL)replaceDuplicates
{
    for (RKResource *resource in type.allResources) {
        [self addResource:resource replacingDuplicates:replaceDuplicates];
    }
}

- (nullable RKResource *)resourceWithId:(int16_t)id
{
    for (RKResource *resource in _resources) {
        if (resource.id == id) {
            return resource;
        }
    }
    return nil;
}

@end
