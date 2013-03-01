using namespace std;

#include <iostream>
#include <cmath>

void change(double &r, double s)
{
	r = 100; 
	s = 200;
}


int main()
{
	double a;
	a = 1.2;
	a = sin(a);

	cout<<a<<endl;

	char s[100];
	cout<<"Enter your name:";
	cin>>s;
	cout<<endl;
	cout<<"Hi "<<s<<"!"<<endl;

	///////////////////
	
	double k=3, m=4;
	change(k,m);
	cout<<k<<", "<<m<<endl;
	return 0;
}
