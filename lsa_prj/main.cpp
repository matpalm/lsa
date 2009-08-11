#include <iostream>
#include <vector>
#include <boost/algorithm/string.hpp>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_permutation.h>
#include <gsl/gsl_linalg.h>
#include <fstream>

using namespace std;

gsl_matrix* read_matrix_from_file(string filename, int& n_rows, int& n_cols) {
    ifstream in;
    in.open(filename.c_str());

    string line;
    in >> line;

    vector<string> strs;
    boost::split(strs, line, boost::is_any_of(" "));
    n_rows = atoi(strs[0].c_str());
    n_cols = atoi(strs[1].c_str());
    cout << "n_rows=" << n_rows << " n_cols=" << n_cols << endl;
    in.close();

    return gsl_matrix_alloc(n_rows, n_cols);
}

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

/*
    int* sizes_num_entries = read_ints_from_stdin(3);
    const int n_terms     = sizes_num_entries[0]; // rows
    const int n_docs      = sizes_num_entries[1]; // cols
    const int num_entries = sizes_num_entries[2]; // num_entries in file for sparse matrix
    delete sizes_num_entries;

    cout << "n_terms (rows)=" << n_terms << endl;
    cout << "n_docs (cols)=" << n_docs << endl;
    cout << "num_entries=" << num_entries << endl;
    */

    int n_terms, n_docs;
    gsl_matrix* u = read_matrix_from_file("test.3-Ut", n_terms, n_docs);
    cout << "u" << endl; dump_matrix(u, n_terms, n_docs);
    delete u;
    return 0;
}

