//
//  Calculator.m
//  calculator
//
//  Created by Brokmeier, Pascal on 23/03/16.
//  Copyright © 2016 Pascal Brokmeier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Calculator.h"
#include<stdio.h> /*printf*/


int performCalculation(Symbol formula[], int len){
    bool done = false;
    while(!done){
        if(verboseFlag) printCurrentFormula(formula, len);
        //look for the next operator that has presedence
        int nextOp = scanForNextOperator(formula, len, 1);
        //if we found an operator lets perform that part subcalculation
        if(nextOp > 0){
            performOpAt(formula, nextOp, len);
        }
        //we didn't find any more operators in the array. all operators have been used up.
        else{
            done = true;
        }
    }
    return formula[0].val.ival;
}


int scanForNextOperator( Symbol formula[], int len, int level){
    int pos;
    switch (level) {
        case 1:
            pos = scanForMulti(formula, len);
            if(pos<0){
                return scanForNextOperator(formula, len, ++level); //increase level by one. next recursive function will look for operators of lesser importance
            }
            return pos;
            break;
        case 2:
            return scanForAdds(formula, len);
        default:
            return -1;
            break;
    }
}

int scanForMulti( Symbol formula[],int len){
    //we want to find the first next operator that is either *,/,%
    for(int i = 0;i<len;i++){
        if(formula[i].type == is_char && (formula[i].val.cval == 'x' || formula[i].val.cval == '/' || formula[i].val.cval == '%')){
            return i;
        }
        //we didnt find any good operators.
    }
    return -1;
}

int scanForAdds( Symbol formula[],int len){
    //we want to find the first next operator that is either *,/,%
    for(int i = 0;i<len;i++){
        //if element is char and + or -
        if(formula[i].type == is_char && (formula[i].val.cval == '+' || formula[i].val.cval == '-')){
            return i;
        }
        //we didnt find any good operators.
    }
    return -1;
}

void performOpAt ( Symbol formula[], int i, int len){
    //perform operation at given position in array
    int a = findOperand(formula, i, -1, len);
    int b = findOperand(formula, i, 1, len);
    switch(formula[i].val.cval){
        case '+':
            formula[a].val.ival += formula[b].val.cval;
            clean(formula, i, b);
            break;
        case '-':
            formula[a].val.ival -= formula[b].val.cval;
            clean(formula, i, b);
            break;
        case 'x':
            formula[a].val.ival *= formula[b].val.cval;
            clean(formula, i, b);
            break;
        case '/':
            formula[a].val.ival /= formula[b].val.cval;
            clean(formula, i, b);
            break;
        case '%':
            formula[a].val.ival %= formula[b].val.cval;
            clean(formula, i, b);
            break;
        default:
            errorExit("unrecognised operator! Try one of these: + - x / %\n");
            break;
    }
}

int findOperand ( Symbol formula[], int i, int dir, int len){
    while(i > 0 && i < len){
        i += dir;
        if(formula[i].type == is_int){
            return i;
        }
    }
    return -1;
}

void copyArgsArrToSymbolArr(const char* source[],  Symbol destination[], int len, int start){
    for(int i = 0; i<len-start;i++){
        if(i%2==0){
            destination[i] = ((Symbol){
                .type = is_int,
                .val.ival = getInt((char*)source[i+start])
            });
            
        }else{
            destination[i] = ((Symbol){
                .type = is_char,
                .val.cval = source[i+start][0]
            });
        }
    }
}

void clean( Symbol
           formula[], int oprndI, int bI){
     //clean i & i+1
    formula[oprndI].type = is_null;
    formula[bI].type = is_null;
}




/**
 helper function to convert a char* to an integer. For now fairly basic but can encapsulate error handling later on.
 */

void setVerbose(bool verbFlag){
    verboseFlag = verbFlag;
}

int getInt(char* c){
    char *ptr;
    long ret;
    ret =strtol(c, &ptr, 10);
    if(*ptr == '\0'){
        return (int)ret;
    }
    else{
        errorExit("Error in character conversion. Unrecognized Operand. Make sure your numbers are looking good.\n");
        return -1;
    }
}

void printCurrentFormula(Symbol formula[], int len){
    printf("Current Formula: ");
    for(int i = 0; i<len; i++){
        if(formula[i].type == is_int){
            printf("%i ", formula[i].val.ival);
        }
        if(formula[i].type == is_char){
            printf("%c ", formula[i].val.cval);
        }
        if(formula[i].type == is_null){
            printf("_ ");
        }
    }
    printf("\n");
}

void errorExit(char* message){
    printf("%s", message);
    exit(-1);
}