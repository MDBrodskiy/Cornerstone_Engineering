/*
 * ===============================================================
 *
 *       Filename:  CP1H1_MBROD.cpp
 *       Assignment: C++ Lab #1 Homework 1
 *       Title: Powers of 2 Calculator
 *
 *    Description:  Displays 2 to the power of 0 through 8
 *
 *        Version:  1.0
 *        Created:  11/05/2022
 *       Revision:  none
 *       Compiler:  GCC
 *
 *         Author:  M.Brodskiy
 *
 * ===============================================================
 */

#include <iostream> // Include header file for input/output
#include <cmath>  // Include header file for powers

using namespace std; // Declare standard namespace use

int main() {

    // Print first line of table
    cout << "Power (P)\tValue of 2^P" << endl;


    for (int i = 0; i <= 8; i += 1) {// Loop through values 0-8

        cout << "    " << i << "\t\t    " << pow(2,i) << endl; 
        // Perform math and spacing assignments

    }

    return 0; // Return 0 to signify successful exit code

}
