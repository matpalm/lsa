#include <iostream>
#include "math.h"

using namespace std;

int main() {
    int num_terms, num_docs;
    scanf("%d",&num_terms);
    scanf("%d",&num_docs);
    printf("%d %d\n", num_terms, num_docs);

    int* row = new int[num_docs];
    for(int r=0; r<num_terms; r++) {
        int row_total = 0;
        int number_non_zero = 0;

        // first pass to collect stats
        int* row_ptr = row;
        for (int c=0; c<num_docs; c++) {
            int val;
            scanf("%d", &val);
            *row_ptr = val;
            if (val!=0) {
                row_total += val;
                number_non_zero += 1;
            }
            row_ptr++;
        }
        const float idf = log((float)num_docs / number_non_zero);

        // second pass to write out values
        row_ptr = row;
        for (int c=0; c<num_docs; c++) {
            float tf = (float)*row_ptr / row_total;
            float tf_idf = tf * idf;
            if (tf_idf==0)
                printf("0 ");
            else
                printf("%f ", tf_idf);
            row_ptr++;
        }
        printf("\n");
    }
    delete [] row;
    return 0;
}
