/*
 * ===============================================================
 *
 *       Filename:  CP3H1_MBROD.cpp
 *       Assignment: C++ Lab #3 Homework 1
 *       Title: Thermocouple Benchmark Tests
 *
 *    Description:  Takes in a plethora of values and calculates time for sphere temperature to equal liquid temperature of a thermocouple 
 *
 *        Version:  1.0
 *        Created:  12/06/2022
 *       Revision:  N/A
 *       Compiler:  GCC
 *
 *         Author:  M.Brodskiy
 *
 * ===============================================================
 */

// -- Libraries & Directives --
#include <iostream> // Needed for normal cin & cout
#include <fstream> // Needed to read or write files on disk
#include <iomanip> // For Formatting Communications
using namespace std;

  const double pi = 3.1415926535; // Define pi

double rate_of_change(int htc, double rad, double T, int Tl, int dens, int specH) {

    return((3 * htc * (Tl - T)) / (rad * dens * specH));

}

// PROGRAM CP3H1
int main() {

  // -- Declare Variables --
  double radius, timeStep, tempS, time = 0;
  int c, rho, h, tempL; // Define necessary variables
  ofstream outfile; // An output stream object to output data
  
  //  Ask user for necessary inputs
  cout << "Enter initial temperature of thermocouple junction (sphere) (C): ";
  cin >> tempS;
  cout << "Enter liquid temperature (C): ";
  cin >> tempL;
  cout << "Enter heat transfer coefficient (W/m2K): ";
  cin >> c;
  cout << "Enter sphere density (kg/m3): ";
  cin >> rho;
  cout << "Enter sphere specific heat (J/kgK): ";
  cin >> h;
  cout << "Enter sphere radius (m): ";
  cin >> radius;
  cout << "Enter desired time step for temperature history (s): ";
  cin >> timeStep;

  // Open text file as an output stream
  outfile.open("test.txt"); 
  outfile << fixed << setprecision(4); // Set output file number formatting

  // Output initial values to text file
  outfile << "Time (s)" << "\t" << "Temp (C)" << endl;
  outfile << time << "\t\t" << tempS << endl;
  
  do { // Loop through values until temperature difference is less than 1C

      time = time + timeStep;
      tempS = tempS + timeStep * rate_of_change(c, radius, tempS, tempL, rho, h);
      outfile << time << "\t\t" << tempS  << endl;
  
  } while (tempS - tempL > .1);

  outfile.close(); // Write to output file

  // Print steady-state time
  cout << "Time to steady-state temperature: " << fixed << setprecision(4) << time << " Seconds" << endl;

  //  Check the output file was created

  if (!outfile) {

      cout << "Unable to write to file" << endl;
      cout << "No output generated...\n";
      return(1);

    }

}
