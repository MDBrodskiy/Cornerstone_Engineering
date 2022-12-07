/*
 * ===============================================================
 *
 *       Filename:  CP3H2_MBROD.cpp
 *       Assignment: C++ Lab #3 Homework 2
 *       Title: Thermocouple Benchmark Tests part 2
 *
 *    Description:  Takes in a plethora of values and calculates time for sphere temperature to equal liquid temperature of a thermocouple for a variety of radii, outputting these values to a file
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
#include <string> // To manipulate time-file names
using namespace std;

  // -- Declare Variables --
  const double timeStep = .01;
  const double minRad = .0003;
  const double radStep = .00005;
  const double pi = 3.1415926535; // Define pi
  const int tempS = 120;
  const int tempL = 30;
  const int c = 1200;
  int rho, h; // Define necessary variables

  string tinLeadRatio = ("");

void user_inputs() {

  //  Ask user for necessary inputs
  cout << "Please input the necessary material parameters:" << endl;
  cout << "Enter sphere density (kg/m3): ";
  cin >> rho;
  cout << "Enter sphere specific heat (J/kgK): ";
  cin >> h;
  cout << "Enter tin/lead ratio (x%-y%): ";
  cin >> tinLeadRatio;

}

double rate_of_change(double T, double rad) {

    return((3 * c * (tempL - T)) / (rad * rho * h));

}

void gen_time_file(ofstream &file, double rad) { // Generates a file calculating temperature changes until steady-state

    double tempChange = tempS;
    double time = 0; // Define changing variables

    // Output initial values to text file
    file << "Time (s)" << "\t" << "Temp (C)" << endl;
    file << time << "\t\t" << tempChange << endl;

    do { // Loop through values until temperature difference is less than 1C

      time = time + timeStep;
      tempChange = tempChange + timeStep * rate_of_change(tempChange, rad);
      file << time << "\t\t" << tempChange << endl;
  
    } while (tempChange - tempL > .1);

}

double time_to_steady_state(double rad) { // Returns time to steady-state for certain values

    double tempChange = tempS;
    double time = 0; // Changing variables

    do { // Loop through values until temperature difference is less than 1C

      time = time + timeStep;
      tempChange = tempChange + timeStep * rate_of_change(tempChange, rad);
  
    } while (tempChange - tempL > .1);

    return time;

}

void gen_rad_file(ofstream &file) { // Generates a file calculating times to steady-state depending on various radii

    double radChange = minRad;

    // Output initial values to text file
    file << "Time (s)" << "\t" << "Radius (m)" << endl;

    while (time_to_steady_state(radChange) < 5) {

        file << time_to_steady_state(radChange) << "\t\t" << radChange << endl;
        radChange = radChange + radStep;

    }

}

double max_weld_size() { // Returns the maximum weld size

    double radChange = minRad;

    while (time_to_steady_state(radChange) < 5) {

        radChange = radChange + radStep;

    } return radChange;

}

// PROGRAM CP3H2
int main() {

  user_inputs(); // Receive inputs from user

  ofstream outfile; // Create output file object

  outfile << fixed << setprecision(5); // Manipulate output

  for (int i = 0; i <= 2; i = i + 1) { // Generate three transient response curves

      if ( i == 0 ) {

          outfile.open(tinLeadRatio + "minRad.txt");
          gen_time_file(outfile, minRad);

      } else if ( i == 1 ) {

          outfile.open(tinLeadRatio + "midRad.txt");
          gen_time_file(outfile, ((minRad + max_weld_size()) / 2));

      } else {

          outfile.open(tinLeadRatio + "maxRad.txt");
          gen_time_file(outfile, max_weld_size());

      }

      outfile.close(); // Write to each file

  }

  // Open text file as an output stream
  outfile.open(tinLeadRatio + "RAD.txt"); // Generate material maximum weld size in time file
  gen_rad_file(outfile);
  outfile.close(); // Write to output file

  //  Check the output file was created

  if (!outfile) {

      cout << "Unable to write to file" << endl;
      cout << "No output generated...\n";
      return(1);

    }

}
