/*
 * ===============================================================
 *
 *       Filename:  CP1H3_MBROD.cpp
 *       Assignment: C++ Lab #1 Homework 3
 *       Title: Molecular Weight Calculator
 *
 *    Description:  Takes atomic information to calculate weight
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
#include <iostream>  // Include header file to input/output
#include <iomanip>  // Include header file to manipulate input
#include <string>   // Include header file for string variable

using namespace std; // Declare standard namespace use

// Declare Variables
string ans("Yes");
string name("");
double oxygenWeight = 15.9994; 
double carbonWeight = 12.011; 
double nitrogenWeight = 14.00674;
double sulfurWeight = 32.066;
double hydrogenWeight = 1.00794;
double totalWeight;
int oCount, cCount, nCount, sCount, hCount, allCount;

// Main Program
int main() {

do { // Keep looping until user says no

    cout << "Enter the name of the acid: ";
    // Request name of acid
    cin >> name; // Store name in variable

    // Ask for all atom quantities
    cout << "Enter # of atoms of Oxygen: ";
    cin >> oCount; 
    // Add to total weight
    totalWeight = oCount * oxygenWeight;

    cout << "Enter # of atoms of Carbon: ";
    cin >> cCount; 
    totalWeight = totalWeight + cCount * carbonWeight;

    cout << "Enter # of atoms of Nitrogen: ";
    cin >> nCount;
    totalWeight = totalWeight + nCount * nitrogenWeight;

    cout << "Enter # of atoms of Sulfur: ";
    cin >> sCount;
    totalWeight = totalWeight + sCount * sulfurWeight;

    cout << "Enter # of atoms of Hydrogen: ";
    cin >> hCount; 
    totalWeight = totalWeight + hCount * hydrogenWeight;

    // Count all atoms
    allCount = oCount + cCount + nCount + sCount + hCount;

    cout << fixed << setprecision(3);
    cout << "The total molecular weight of " << name << " is: "                     << totalWeight << " u" << endl;
    cout << "The average atomic weight of " << name << " is: "                      << (totalWeight / allCount) << " u" << endl;

    // Ask user if they would like to calculate again
    cout << "Would you like to calculate another acid?" << endl;

    cout << "Enter 'Yes' or 'No': ";
    cin >> ans; // Store user input

} while(ans!="No");

}
