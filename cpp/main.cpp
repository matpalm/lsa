#include <iostream>
#include <vector>
#include <boost/algorithm/string.hpp>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_permutation.h>
#include <gsl/gsl_linalg.h>

using namespace std;

void dump_matrix(gsl_matrix* m, const int ni, const int nj) {
    for(int i=0;i<ni;i++) {
        for (int j=0;j<nj;j++) {
            cout << gsl_matrix_get(m,i,j) << " ";
        }
        cout << endl;
    }
}

void dump_vector(gsl_vector* v, const int n) {
    for (int j=0;j<n;j++) {
        cout << gsl_vector_get(v,j) << " ";
    }
    cout << endl;
}

int* read_ints_from_stdin(const int num_ints_to_read) {
    string nextline;
    if (std::getline(cin, nextline)) {
        const char* chars = nextline.c_str();
        if (chars[0]=='#') {
            // comment line
            return read_ints_from_stdin(num_ints_to_read);
        }
        else {
            vector<string> strs;
            boost::split(strs, nextline, boost::is_any_of(" "));
            int* ints = new int[num_ints_to_read];
            vector<string>::iterator iter = strs.begin();
            for(int i=0;i<num_ints_to_read;i++) {
                ints[i] = atoi(iter->c_str());
                ++iter;
            }
            return ints;
        }
    }
    cerr << "end of file when expecting more ints?" << endl;
    return 0;
}

int read_int_from_stdin() {
    int* ints = read_ints_from_stdin(1);
    int to_return = ints[0];
    delete ints;
    return to_return;
}

int main() {

    int* sizes_num_entries = read_ints_from_stdin(3);
    const int n_terms     = sizes_num_entries[0]; // rows
    const int n_docs      = sizes_num_entries[1]; // cols
    const int num_entries = sizes_num_entries[2]; // num_entries in file for sparse matrix
    delete sizes_num_entries;

    cout << "n_terms (rows)=" << n_terms << endl;
    cout << "n_docs (cols)=" << n_docs << endl;
    cout << "num_entries=" << num_entries << endl;

    gsl_matrix* a = gsl_matrix_alloc(n_terms, n_docs);

    for(int col=0; col<n_docs; col++) {
        int num_entries_for_column = read_int_from_stdin();
        for(int e=0; e<num_entries_for_column; e++) {
            int* row_value = read_ints_from_stdin(2);
            int row = row_value[0];
            int value = row_value[1];
            gsl_matrix_set(a, row,col, value);
            delete row_value;
        }
    }

    //cout << "read in" << endl;
    //cout << "a" << endl; dump_matrix(a, n_terms, n_docs);

    gsl_matrix* v = gsl_matrix_alloc(n_docs, n_docs);
    gsl_vector* s = gsl_vector_alloc(n_docs);
    gsl_vector* work = gsl_vector_alloc(n_docs);

    gsl_linalg_SV_decomp(a, v, s, work);

    //cout << "done" << endl;
    cout << "u" << endl; dump_matrix(a, n_terms, n_docs);
    cout << "v" << endl; dump_matrix(v, n_docs, n_docs);
    cout << "s" << endl; dump_vector(s, n_docs);

    gsl_matrix_free(a);
    gsl_matrix_free(v);
    gsl_vector_free(s);
    gsl_vector_free(work);

    return 0;
}

