//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Kev Jackson on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userHasEnteredOneDecimalPointInThisNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize history = _history;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userHasEnteredOneDecimalPointInThisNumber = _userHasEnteredOneDecimalPointInThisNumber;
@synthesize brain = _brain;

//lazy instantiation again
-(CalculatorBrain *) brain 
{
    if(!_brain) {
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString* digit = [sender currentTitle];
    // [digit description]
    //NSLog(@"digit pressed = %@", digit);
    /*
     Original implementation
    UILabel *myDisplay = self.display; //[self display];
    NSString *currentText = myDisplay.text; //[myDisplay text];
    NSString *newText = [currentText stringByAppendingString:digit];
    myDisplay.text = newText; //[myDisplay setText:newText];
     
    */
    
    if(self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
}

- (IBAction)enterPressed 
{
    //NSLog(@"number = %g", [self.display.text doubleValue]);
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasEnteredOneDecimalPointInThisNumber = NO;
    
    // add the number to the history label
    self.history.text = [self.history.text stringByAppendingFormat:
                         @" %@", self.display.text];
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    if(self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    double result = [self.brain performOperation:[sender currentTitle]];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    
    // add the operation to the history label
    self.history.text = [self.history.text stringByAppendingFormat:
                         @" %@", [sender currentTitle]];
}

- (IBAction)pointPressed:(UIButton *)sender 
{
    if(!self.userHasEnteredOneDecimalPointInThisNumber) {
        self.display.text = [self.display.text stringByAppendingString:@"."];
        self.userHasEnteredOneDecimalPointInThisNumber = YES;
    }
}
- (IBAction)clearPressed:(UIButton *)sender 
{
    // wipe everything
    [self.brain clear];
    self.display.text = @"";
    self.history.text = @"";
}

- (void)viewDidUnload {
    [self setHistory:nil];
    [super viewDidUnload];
}
@end
