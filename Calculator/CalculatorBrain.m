//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Kev Jackson on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
#import <math.h>

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack
{
    // lazy instantiation
    if(_operandStack == nil) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

/* the setter is created by @synthesize
-(void) setOperandStack:(NSMutableArray *)operandStack
{
    _operandStack = operandStack;
}
*/

-(void) pushOperand:(double)operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

-(double) popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    //like python an object resolves to true, but nil is false
    if(operandObject) {
        [self.operandStack removeLastObject];
    }
        
    return [operandObject doubleValue];
}

-(double) performOperation:(NSString *)operation
{
    double result = 0;
    // calculate result 
    if([@"+" isEqualToString:operation]) {
        result = [self popOperand] + [self popOperand];
    } else if([@"*" isEqualToString:operation]) {
        result = [self popOperand] * [self popOperand];
    } else if([@"/" isEqualToString:operation]) {
        //stack means that the values are the opposite away around
        double divisor = [self popOperand];
        double dividend = [self popOperand];
        result = dividend / divisor;
    } else if([@"-" isEqualToString:operation]) {
        double subtrahend = [self popOperand];
        double minuhend = [self popOperand];
        result = minuhend - subtrahend;
    } else if([@"sin" isEqualToString:operation]) {
        result = sin([self popOperand]);
    } else if([@"cos" isEqualToString:operation]) {
        result = cos([self popOperand]);
    } else if([@"\u03c0" isEqualToString:operation]) {
        result = M_PI;
    }
    
    [self pushOperand:result];
    return result;
}

-(void) clear
{
    // wipe stack
    [self.operandStack removeAllObjects];
}
@end
