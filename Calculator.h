/*
   Project: Calculate

   Copyright (C) 2018 Free Software Foundation

   Author: meguca

   Created: 2018-08-27 10:56:15 +0100 by meguca

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

#ifndef _CALCULATOR_H_
#define _CALCULATOR_H_

#import <Foundation/Foundation.h>

enum
{
  CalculatorButtonNone = -1,
  CalculatorButtonClear = 10,
  CalculatorButtonPoint,
  CalculatorButtonEqual,
  CalculatorButtonPlus,
  CalculatorButtonPercent,
  CalculatorButtonMinus,
  CalculatorButtonSqrt,
  CalculatorButtonTimes,
  CalculatorButtonDeltaPercent,
  CalculatorButtonDivide,
  CalculatorButtonMemAdd,
  CalculatorButtonMemMinus,
  CalculatorButtonMemRecall,
  CalculatorButtonMemClear,
  CalculatorButtonPlusMinus,
};
typedef NSInteger CalculatorButton;

enum
{
  CalculatorOperationNone,
  CalculatorOperationPlus,
  CalculatorOperationMinus,
  CalculatorOperationTimes,
  CalculatorOperationDivide,
  CalculatorOperationDeltaPercent
};
typedef NSInteger CalculatorOperation;

enum
{
  CalculatorErrorNone,
  CalculatorErrorDivideByZero
};
typedef NSInteger CalculatorError;

@interface Calculator : NSObject
{
  double scratch;
  int decimalPosition;
  double working;
  double memory;
  BOOL clearOnNextNumber;
  CalculatorButton lastButton;
  CalculatorButton lastNonNumberButton;
  CalculatorOperation operation;
  CalculatorError error;
}
- (id) init;
- (void) activateButton: (CalculatorButton)button;
- (NSNumber*) getDisplay;
@end

#endif // _CALCULATOR_H_

