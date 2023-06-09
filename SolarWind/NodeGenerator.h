/********************************************************
*	DESCRIPTION	: Atomic model Node generator
* 
*	AUTHOR		: Monageng Kgwadi
* 
*	DATE		: 26-10-2007
* 
*
********************************************************/


#ifndef NODEGENERATOR_H
#define NODEGENERATOR_H

//****    file includes    *********/
#include "atomic.h"



class NodeGenerator: public Atomic 
{

public: 
	
	
	NodeGenerator(const string &name = "NodeGenerator");
	
	
	virtual string className() const
		{return "NodeGenerator";}
		
protected:
	Model &initFunction();
	
	Model &externalFunction( const ExternalMessage & );
	
	Model &internalFunction( const InternalMessage & );
	
	Model &outputFunction( const InternalMessage &);
	
private:
	
	Port &aout;
	
		
}; //Class NodeGenerator

#endif  //_NODEGENERATOR_H