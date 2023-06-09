/********************************************************
*	DESCRIPTION	: Atomic model Node generator
* 
*	AUTHOR		: Monageng Kgwadi
* 
*	DATE		: 26-10-2007
********************************************************/


/********** file includes ****************************/

#include "NodeGenerator.h"
#include <math.h>
#include <stdlib.h>
#include <iostream>
#include "randlib.h"         // Random numbers library
#include "message.h"         // InternalMessage 
#include "distri.h"          // class Distribution
#include "mainsimu.h"        // class MainSimulator
#include "strutil.h"   

#include <cstdlib>
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>


/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*Function Name: NodeGenerator
* 
* Description: Constructor
* 
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

NodeGenerator::NodeGenerator( const string &name) :
	Atomic(name),
	aout( addOutputPort("aout")){	
		
	}
Model &NodeGenerator::initFunction()
{
	                    
	    holdIn(Atomic::active, Time::Zero);
		return *this ; 
		};
/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*Function Name: external function
* 
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/	
Model &NodeGenerator::externalFunction(const ExternalMessage & ){
	
	  cout<< "we shouldnt see this message no inputs"<<endl;
return *this;
}
/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*Function Name: internal function
* 
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/	
Model &NodeGenerator::internalFunction(const InternalMessage & )
{
	
	double x = rand()/(double)RAND_MAX *5;

	Time t(0,0,x,0) ;
	
	holdIn(active, t);
	return *this;
}
/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*Function Name: output function
* 
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/	
Model &NodeGenerator::outputFunction(const InternalMessage &msg)
{
	
	//*****************************************************************//
	    //*****************************************************************//
	    //Falta el codigo que ejecuta el script de python
		//Py_Initialize();

	    system("php -f parser.php");

		//*****************************************************************//
	    //*****************************************************************//
	    //El siguiente codigo levanta el valor de Bz
	    //Este valor fue recolectado de la web por el codigo python
	    //Se deja el valor en la variable double Bzvalue para ser pasado a la simulacion
	    ifstream myfile;
	    myfile.open("Bz.txt");
	    string Bzvalue_string;
	    getline(myfile,Bzvalue_string);
	    double Bzvalue=::atof(Bzvalue_string.c_str());
	    myfile.close();

	    //Chequeamos el caso de que Bzvalue es negativo
	    //en este caso le invertimos el signo para que las reglas sigan funcionando}
	    Bzvalue=-Bzvalue;
	    std::ostringstream os;
	    os << Bzvalue;
	    std::string str = os.str();
	    Bzvalue_string=str;

	    //*****************************************************************//
	    //*****************************************************************//
	    //Ahora se vuelca el valor de Bzvalue al archivo de macros
	    fstream input_file("macros.inc",ios::in);
	    ofstream output_file("macros0.inc");
	    string inbuf;
	    while(!input_file.eof())
	    {
	         getline(input_file,inbuf);

	         int spot =inbuf.find("#BeginMacro(E_max)");
	         //if(inbuf=="#BeginMacro(E_max)")
	         if(spot>=0)
	         {
	             output_file << inbuf << endl;
	             getline(input_file,inbuf);//me como el parentesis}
	             output_file << inbuf << endl;
	             getline(input_file,inbuf);//me como el numero
	             output_file << Bzvalue_string << endl;
	             getline(input_file,inbuf);//me como el parentesis}
	         }
	         output_file << inbuf << endl;
	    }
	    input_file.close();
	    output_file.close();

	    remove("macros.inc");
	    rename("macros0.inc","macros.inc");
	    //*****************************************************************//
	    //*****************************************************************//

	    sendOutput( msg.time(), aout, Bzvalue);

	return *this;
}
