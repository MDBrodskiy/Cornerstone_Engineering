/*
 * ===============================================================
 *
 *       Filename:  CP1H2_MBROD.cpp
 *       Assignment: C++ Lab #1 Homework 2
 *       Title: Debugging Code
 *
 *    Description:  Displays the division of two numbers
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

#include <iostream> // Corrected iosteam to iostream
#include <iomanip> // Included header for i/o manipulation

using namespace std; // Added line to default to std

int main () { 

    double X, Y; // Corrected X and Y to be doubles
    cout << "Enter X:  "; 
    cin >> X; 
    cout << "Enter Y:  "; 
    cin >> Y; 
    double Z = X/Y; // Declared Z as a double
    cout<< "  X/Y="  << fixed << setprecision(2) << Z << endl; 
    // End line with endl and set decimal precision to 2
    cout<< "End of program." << endl; // Added "<<" before endl

} // Added brace at end to close main
