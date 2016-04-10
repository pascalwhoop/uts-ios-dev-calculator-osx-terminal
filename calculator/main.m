//
//  main.m
//  calculator
//
//  Created by Brokmeier, Pascal on 23/03/16.
//  Copyright © 2016 Pascal Brokmeier. All rights reserved.
//

#import <Foundation/Foundation.h>
#include<stdio.h> /*printf*/
#include <stdlib.h>     /* atoi */
#import "Calculator.h"

// The calculator program has been written following a style of functional programming. The reason is obvious.
// A simple calculator has a very functional structure. There is hardly any reason for OO programming so the concept of functional programming is better suited.

int main(int argc, const char * argv[]) {
    
    printf("Calculator by Pascal Brokmeier\n");
    if(argc == 1){
        printf("This is a calculator by Pascal Brokmeier. Enter a formula (spacing between each operands and operators) and see the result.");
        printf("\n\nYou can use: + - x / and %%. \n");
        printf("\nA -v flag shows how the algorithm processes your formula step by step. Enjoy!\n\n");
        exit(0);
    }
    
    int formulaStart = 1;
    int eq = strcmp("-v", argv[1]);
    if(eq == 0){
        printf("Verbose mode\n");
        setVerbose(true);
        formulaStart++;
    }
    
    
    
    
    //copy const input array into non const array so we can work with it
    Symbol *formula = malloc(sizeof(Symbol)* argc-formulaStart);
    copyArgsArrToSymbolArr(argv, formula, argc, formulaStart);
    
    //initialise calculation
    int result = performCalculation(formula, argc-formulaStart);
    
    //return result
    printf("The result is %d\n", result);
    
}



