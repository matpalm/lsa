#include <iostream>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_permutation.h>
#include <gsl/gsl_linalg.h>

using namespace std;

/*
	solve Ax=b
	for
	|1 0||x| = |1|
  |2 1|      |5|
*/

int main() {
    const int n = 2;

    gsl_matrix* a = gsl_matrix_alloc(n,n);
    gsl_matrix_set(a, 0,0, 1);
    gsl_matrix_set(a, 0,1, 0);
    gsl_matrix_set(a, 1,0, 2);
    gsl_matrix_set(a, 1,1, 1);

    gsl_permutation* p = gsl_permutation_alloc(n);
    int* signum = new int;

    gsl_linalg_LU_decomp(a, p, signum);

    gsl_vector* x = gsl_vector_alloc(n);
    gsl_vector* b = gsl_vector_alloc(n);
    gsl_vector_set(b, 0, 1);
    gsl_vector_set(b, 1, 5);

    gsl_linalg_LU_solve(a, p, b, x);

    for(int i=0;i<n;i++) {
        cout << gsl_vector_get(x,i) << " ";
    }
    cout << endl;

    gsl_matrix_free(a);
    gsl_permutation_free(p);
    gsl_vector_free(x);
    gsl_vector_free(b);
    delete signum;

    return 0;
}


