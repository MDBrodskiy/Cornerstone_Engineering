/*
 * ===============================================================
 *
 *       Filename:  CP2L1_MBROD.cpp
 *       Assignment: C++ Lab #2 Lesson 1 
 *       Title: Ticker Tape Calculator
 *
 *    Description:  Outputs calculation information to file
 *
 *        Version:  1.0
 *        Created:  11/08/2022
 *       Revision:  none
 *       Compiler:  GCC
 *
 *         Author:  M.Brodskiy
 *
 * ===============================================================
 */


// -- Libraries & Directives --
#include <iostream> // For Console Window Communication
#include <string> // For Using Strings
#include <fstream> // For Output File Communication
#include <iomanip> // For Formatting Communications

using namespace std;

// PROGRAM TickerTapeCalculator:
int main() {
  // -- Declare Variables --
  ofstream outfile; 
  //  An output stream object will be needed
  string filename(""); 
  //  The user must establish the filename
  int accuracy; 
  //  The user must define the accuracy of                                      information recorded to the output
  char oper; 
  //  The user must input an operation based                                    on a limited set of characters
  double num; 
  //  The user must input a numerical value                                     to be used in a calculation
  double total = 0; 
  //  A total must be updated by each calculation

  // -- Main Program --
  //  Introduce Program to user
  cout << " --- Ticker Tape Calculator --- " << endl;
  cout << " Enter operator and operand to " << endl;
  cout << " run and record calculations.  " << endl << endl;
  //  Ask user for filename for ticker tape
  cout << "Enter the output file name: ";
  cin >> filename;
  //  Specify accuracy for output
  cout << "Enter the decimal point accuracy: ";
  cin >> accuracy;
  cout << fixed << setprecision(accuracy);
  outfile << fixed << setprecision(accuracy);
  //  Establish output file stream
  outfile.open(filename);
  
  while (oper != 'e') {
  //    Ask user for intended operation (+,-,*,/,=,e)
    cout << "Enter operation (+,-,*,/,=,e): ";
    cin >> oper;
  //    IF operation is = or e
    if (oper == '=' || oper == 'e') {
  //      Print total to ticker tape
        cout << "Print total" << endl;
        outfile << "=\t" << total << endl;
  //      reset total
        total = 0;
  //      IF operation is e
        if (oper == 'e') break;
  //        end forever loop
    }  //      ENDIF
  //    ELSE
    else {
  //      ask user for operand
        cout << "Enter operand: ";
        cin >> num;
  //      Print operation and operand to ticker tape
        outfile << oper << "\t" << num << endl;
  //      SWITCH operation
        switch (oper) {
  //      CASE +,-,*,/
            case '+': 
  //        Calculate update to total based on operator and operand
                cout << total;
                total = total + num;
  //        Print mathematical operation and updated                total to console
                cout << " " << oper << " " << num <<                    " = " << total << endl;
                break;
            case '-': 
  //        Calculate update to total based on operator and operand
                cout << total;
                total = total - num;
  //        Print mathematical operation and updated                total to console
                cout << " " << oper << " " << num <<                    " = " << total << endl;
                break;               
            case '*': 
  //        Calculate update to total based on operator and operand
                cout << total;
                total = total * num;
  //        Print mathematical operation and updated                total to console
                cout << " " << oper << " " << num <<                    " = " << total << endl;
                break;                
            case '/': 
  //        Calculate update to total based on operator and operand
                cout << total;
                total = total / num;
  //        Print mathematical operation and updated                total to console
                cout << " " << oper << " " << num <<                    " = " << total << endl;
                break;
  //      CASE default
            default: 
  //        Print warning to console and ticker tape
                cout << "ERROR: character " << oper <<                  " unknown" << endl;
                outfile << "ERROR: character " << oper <<               " unknown" << endl;
            }  //      ENDCASE
        } //    ENDIF
    } //  ENDWHILE

    outfile.close();
  //  Check the output file was created
  
    if (!outfile) {

        cout << "Unable to write to file" << endl;
        cout << "No output generated...\n";
        return(1);

    }

} // ENDPROGRAM
