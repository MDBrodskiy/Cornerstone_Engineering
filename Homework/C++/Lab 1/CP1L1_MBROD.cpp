/*
 * ===============================================================
 *
 *       Filename:  CP1L1_MBROD.cpp
 *       Assignment: C++ Lab #1 Part 1
 *       Title: Simple Addition Calculator
 *
 *    Description:  Displays the sum of two numbers chosen by user
 *
 *        Version:  1.0
 *        Created:  11/01/2022
 *       Revision:  none
 *       Compiler:  GCC
 *
 *         Author:  M.Brodskiy
 *
 * ===============================================================
 */

#include <iostream> // Include header file for input/output
#include <iomanip>  // Include header file to manipulate input

using namespace std; // Declare standard namespace use

float a,b;

int main() {

    // Introduce user to program
    cout << "Welcome to the Great Addition Calculator!" << endl;

    // Instruct for input
    cout << "Please enter the first number: "; 
    cin >> a;
    cout << "Please enter the second number: "; 
    cin >> b;


    // Set output to fixed and 3-point precision
    cout << fixed << setprecision(3);

    // Print out result
    cout << "The sum of " << a << " and " 
      << b << " is " << (a + b) << endl;

    return 0; // Return 0 to signify successful exit code

}
