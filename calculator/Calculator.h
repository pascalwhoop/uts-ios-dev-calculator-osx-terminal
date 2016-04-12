//
//  Calculator.h
//  calculator
//
//  Created by Brokmeier, Pascal on 25/03/16.
//  Copyright © 2016 Pascal Brokmeier. All rights reserved.
//

#ifndef Calculator_h
#define Calculator_h


#endif /* Calculator_h */

typedef struct {
    enum { is_int, is_char, is_null} type;
    union
    {
        int ival;
        char cval;
    } val;
}Symbol;

static bool verboseFlag = false;



//calculation algorithm core
int performCalculation(Symbol formula[], int len); //performs calculation and returns result
int scanForNextOperator(Symbol formula[], int len, int level); //returns -1 if no more operators present
int scanForAdds     (Symbol formula[],int len);     //find + or - and return position
int scanForMulti    (Symbol formula[],int len); //find * % or / and return position
void performOpAt    (Symbol formula[], int i, int len); //perform operation at given position in array
int findOperand     (Symbol formula[], int i, int dir, int len);//find operand and return position of it based on direction


//transform functions
void copyArgsArrToSymbolArr(const char* source[], Symbol destination[], int len, int start); //copies the pointers of the chars into a non const array and converts integers when possible

//helper functions
void catchOverflows(int iResult, long lResult); // verify operations of integer arithmetics;
void catchDivZeros(int num); // checks if num is 0. if so we throw an error
void setVerbose(bool verbFlag);
void clean(Symbol formula[], int oprndI, int bI); //place result at i-1 and clear i & i+1
bool isOperand(char p); //determines wether we have an operand (or an operator). True = operand false = operator
int getInt(char* c);  //helper to convert string integer form to int object
void printCurrentFormula(Symbol formula[], int len);
void errorExit(char* message);