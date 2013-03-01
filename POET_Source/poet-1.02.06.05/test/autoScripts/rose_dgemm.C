
void dgemm(double *a,double *b,double *c,int n)
{
  int i;
  int j;
  int k;
/*@; BEGIN(nest1=Nest) @*/
  for (k = 0; k <= -1 + n; k += 1) {
/*@; BEGIN(nest3=Nest) @*/
    for (j = 0; j <= -1 + n; j += 1) {
/*@; BEGIN(nest2=Nest) @*/
      for (i = 0; i <= -1 + n; i += 1) {
        c[(j * n) + i] = ((c[(j * n) + i]) + ((a[(k * n) + i]) * (b[(j * n) + k])));
      }
    }
  }
}

