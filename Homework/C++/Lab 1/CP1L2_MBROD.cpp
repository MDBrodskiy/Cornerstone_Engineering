/*
 * ===============================================================
 *
 *       Filename:  CP1L2_MBROD.cpp
 *       Assignment: C++ Lab #1 Part 2
 *       Title: Circular Calculator
 *
 *    Description:  Calculates circumference and area until user                                                                                                                        requests loop to stop
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
#include <cmath>    // Include header file for more math function 
#include <string>   // Include header file for string variable

using namespace std; // Declare standard namespace use

// Declare Variables
double pi = 3.1415926535898;
double r, c, a; // radius, circumference, area
string ans("Yes");

// Main Program
int main() {

// Introduce and explain the program for the user
cout << "Welcome to the Great Circular Calculator!" << endl;

do {

    cout << "Please Enter a Radius Value: "; // Request a radius                                                                                                                                                value from the user
    cin >> r;

    c = 2 * pi * r; // Calculate circumference and area
    a = pi * pow(r, 2);

    cout << scientific << setprecision(3); // Set cout to scientific                                                                                                                                            and set precision

    cout << "The circumference is: " << c << endl; // Print out
    cout << "The area is: " << a << endl; // calculated info


// Ask user if they would like to calculate again
cout << "Would you like to make another calculation?" << endl;

cout << "Enter 'Yes' or 'No': ";
cin >> ans;

} while(ans!="No");

}
