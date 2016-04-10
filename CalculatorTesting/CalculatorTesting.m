//
//  CalculatorTesting.m
//  CalculatorTesting
//
//  Created by Brokmeier, Pascal on 27/03/16.
//  Copyright © 2016 Pascal Brokmeier. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Calculator.h"

@interface CalculatorTesting : XCTestCase

@end

@implementation CalculatorTesting

const int fLength = 17;
Symbol formula[fLength];
int result = 13;

- (void)setUp {
    [super setUp];
    //Formula: 3 + 4 * 4 - 100 / 5 % 7
    //expected result: 13
    //reset our array of Symbols to represent our testing formula
    formula[0].type = is_int;
    formula[0].val.ival = 3;
    formula[1].type = is_char;
    formula[1].val.cval = '+';
    formula[2].type = is_int;
    formula[2].val.ival = 4;
    //an empty stretch in a half processed formula
    formula[3].type = is_null;
    formula[4].type = is_null;
    formula[5].type = is_null;
    //end
    formula[6].type = is_char;
    formula[6].val.cval = 'x';
    formula[7].type = is_null;
    formula[8].type = is_null;
    formula[9].type = is_null;
    formula[10].type = is_int;
    formula[10].val.ival = 4;
    formula[11].type = is_char;
    formula[11].val.cval = '-';
    formula[12].type = is_int;
    formula[12].val.ival = 100;
    formula[13].type = is_char;
    formula[13].val.cval = '/';
    formula[14].type = is_int;
    formula[14].val.ival = 5;
    formula[15].type = is_char;
    formula[15].val.cval = '%';
    formula[16].type = is_int;
    formula[16].val.ival = 7;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFindOperand {
    XCTAssertEqual(findOperand(formula, 1, -1, fLength), 0, "findOperand should find 3 at location 1 withdirection -1");
    
    XCTAssertEqual(findOperand(formula, 6,  -1, fLength), 2, "findOperand should find 3 at location 1 withdirection -1");
    
    XCTAssertEqual(findOperand(formula, 6,  1, fLength), 10, "findOperand should find 3 at location 1 withdirection -1");
}

- (void)testScanForNextOperator {
    XCTAssertEqual(scanForNextOperator(formula, fLength, 1), 6, "scanForNextOperator should find the next * at location 6 ");
    clean(formula, 6, 10);
    XCTAssertEqual(scanForNextOperator(formula, fLength, 1), 13, "scanForNextOperator should now find the next / at location 13 ");
    
    XCTAssertEqual(scanForNextOperator(formula, fLength, 2), 1, "scanForNextOperator should find the next + at location 1 ");
}

- (void)testPerformOpAt {
    
    //before: |3|+|4|...
    performOpAt(formula, 1, fLength);
    //after: |7|+|4|...
    XCTAssertEqual(formula[0].val.ival, 7, "after performing the operation, formula[0] should be equal to 7");
    XCTAssertEqual(formula[1].type, is_null, "after performing the operation, formula[1] type should be is_null");
    XCTAssertEqual(formula[2].type, is_null, "after performing the operation, formula[1] type should be is_null");
    
    //before: |7|N|N|...|*|N|...|4|...
    performOpAt(formula, 6, fLength);
    //after: |28|N|N|...|N|N|...|N|...
    XCTAssertEqual(formula[0].val.ival, 28, "after performing the operation, formula[0] should be equal to 7");
    XCTAssertEqual(formula[6].type, is_null, "after performing the operation, formula[1] type should be is_null");
    XCTAssertEqual(formula[10].type, is_null, "after performing the operation, formula[1] type should be is_null");
    
    //before: |7|N|N|...|*|N|...|4|...
    performOpAt(formula, 13, fLength);
    
    XCTAssertEqual(formula[12].val.ival, 20, "after performing the operation, formula[12] should be equal to 20");
    XCTAssertEqual(formula[13].type, is_null, "after performing the operation, formula[13] type should be is_null");
    XCTAssertEqual(formula[14].type, is_null, "after performing the operation, formula[14] type should be is_null");
    
}

- (void) testCopyCharArrToSymbolArr {
    const char* cmdLineInput[6] = {
        "command", "1", "x", "2", "+", "3"
    };
    Symbol *formula = malloc(sizeof(Symbol)* 6);
    copyArgsArrToSymbolArr(cmdLineInput, formula, 6, 1);
    
    XCTAssertEqual(formula[0].type, is_int, "expect 1 to be in the first slot of the formula array");
    XCTAssertEqual(formula[0].val.ival, 1, "expect 1 to be in the first slot of the formula array");
    XCTAssertEqual(formula[1].type, is_char, "expect x to be in the 2nd slot of the formula array");
    XCTAssertEqual(formula[1].val.cval, 'x', "expect x to be in the 2nd slot of the formula array");
}

- (void) testVerboseFlagCopyCharArrToSymbolArr {
    const int size = 7;
    const char* cmdLineInput[size] = {
        "command","-v", "1", "x", "2", "+", "3"
    };
    Symbol *formula = malloc(sizeof(Symbol)* size-2);
    copyArgsArrToSymbolArr(cmdLineInput, formula, 7, 2);
    
    XCTAssertEqual(formula[0].type, is_int, "expect 1 to be in the first slot of the formula array");
    XCTAssertEqual(formula[0].val.ival, 1, "expect 1 to be in the first slot of the formula array");
    XCTAssertEqual(formula[1].type, is_char, "expect x to be in the 2nd slot of the formula array");
    XCTAssertEqual(formula[1].val.cval, 'x', "expect x to be in the 2nd slot of the formula array");
}

- (void) testPerformCalculation{
    int result = performCalculation(formula, fLength);
    
    XCTAssertEqual(result, 13, "expect the result to be in the first slot of the formula array");
    for(int i = 1; i<fLength;i++){
        XCTAssertEqual(formula[i].type, is_null, "expect all other slots to be nulled out");
    }
    
}
@end
