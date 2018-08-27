/*
   Project: Calculate

   Copyright (C) 2018 Free Software Foundation

   Author: anthony cohn-richardby

   Created: 2018-08-27 10:56:15 +0100 by anthony cohn-richardby

   This application is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This application is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
*/

#import "math.h"
#import "Calculator.h"

#define BASE 10.0f

@implementation Calculator

- (id) init
{
  self = [super init];
  if (self == nil)
  {
    return self;
  }
  scratch = 0;
  decimalPosition = 0;
  working = 0;
  memory = 0;
  clearOnNextNumber = NO;
  operation = CalculatorOperationNone;
  lastButton = CalculatorButtonNone;
  lastNonNumberButton = CalculatorButtonNone;
  return self;
}

- (void) appendNumber: (int) number
{
  if (decimalPosition > 0)
  {
    scratch += number / pow(BASE, decimalPosition);
    decimalPosition += 1;
    return;
  }
  scratch *= BASE;
  scratch += (double)number;
}

- (void) calculate
{
  if (error != CalculatorErrorNone)
  {
    NSLog(@"Ignoring calculate due to error state");
    return;
  }
  NSLog(@"Performing calculator operation %d", operation);
  switch (operation)
  {
    case CalculatorOperationTimes:
      working *= scratch;
      break;
    case CalculatorOperationDivide:
      if (scratch == 0)
      {
        error = CalculatorErrorDivideByZero;
        break;
      }
      working /= scratch;
      break;
    case CalculatorOperationPlus:
      working += scratch;
      break;
    case CalculatorOperationMinus:
      working -= scratch;
      break;
    case CalculatorOperationDeltaPercent:
      working = (scratch - working) / working;
      break;
    default:
      working = scratch;
      break;
  }
  scratch = working;
  operation = CalculatorOperationNone;
}

- (void) calculatePlusMinus
{
  scratch = -scratch;
}

- (void) calculatePercent
{
  scratch /= 100.0;
}

- (void) calculateSqrt
{
  scratch = sqrt(scratch);
}

- (void) memAdd
{
  memory = memory + scratch;
}

- (void) memMinus
{
  memory = memory - scratch;
}

- (void) memRecall
{
  if (operation != CalculatorOperationNone)
  {
    working = scratch;
  }
  scratch = memory;
}

- (void) memClear
{
  memory = 0;
}

- (CalculatorOperation) getOperationForButton: (CalculatorButton) button
{
  switch (button)
  {
    case CalculatorButtonPlus:
      return CalculatorOperationPlus;
    case CalculatorButtonMinus:
      return CalculatorOperationMinus;
    case CalculatorButtonDeltaPercent:
      return CalculatorOperationDeltaPercent;
    case CalculatorButtonTimes:
      return CalculatorOperationTimes;
    case CalculatorButtonDivide:
      return CalculatorOperationDivide;
    default:
      return CalculatorOperationNone;
  }
}

- (NSString*) getDisplay
{
  return [NSString stringWithFormat: @"%f", scratch];
}

- (void) activateButton: (CalculatorButton) button
{
  NSLog(@"Button activate: %d", button);
  CalculatorOperation op = [self getOperationForButton: button];
  
  if (button < 10 || button == CalculatorButtonPoint)
  {
    if (clearOnNextNumber)
    {
      working = scratch;
      scratch = 0;
      decimalPosition = 0;
    }
    if (decimalPosition < 1 && button == CalculatorButtonPoint) {
      decimalPosition = 1;
    }
    else 
    {
      [self appendNumber: button];
    }
    clearOnNextNumber = NO;
  }
  else if (op != CalculatorOperationNone)
  {
    if (lastButton == CalculatorButtonEqual)
    {
      working = scratch;
    }
    else if (operation != CalculatorOperationNone)
    {
      [self calculate];
    }
    operation = op;
    clearOnNextNumber = YES;
  }
  else {
    switch (button)
    {
      case CalculatorButtonClear:
        scratch = 0;
        decimalPosition = 0;
        working = 0;
        error = CalculatorErrorNone;
        operation = CalculatorOperationNone;
        break;
      case CalculatorButtonEqual:
        [self calculate];
        break;
      case CalculatorButtonPercent:
        [self calculatePercent];
        break;
      case CalculatorButtonMinus:
        operation = CalculatorOperationMinus;
        break;
      case CalculatorButtonSqrt:
        [self calculateSqrt];
        break;
      case CalculatorButtonMemAdd:
        [self memAdd];
        break;
      case CalculatorButtonMemMinus:
        [self memMinus];
        break;
      case CalculatorButtonMemRecall:
        [self memRecall];
        break;
      case CalculatorButtonMemClear:
        [self memClear];
        break;
      case CalculatorButtonPlusMinus:
       [self calculatePlusMinus];
       break;
    }
    clearOnNextNumber = YES;
  }
  lastButton = button;
}
@end
