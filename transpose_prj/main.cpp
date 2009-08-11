#include <iostream>
#include <math.h>

using namespace std;

int main()
{

    int num_rows, num_cols;
    scanf("%d",&num_rows);
    scanf("%d",&num_cols);
    printf("%d %d\n",num_cols,num_rows);

    const int r_idx = sqrt(num_rows);

    // alloc memory for transposed matrix
    // do as array of arrays to avoid list structures
    // first idx are rows in transpose
    // second idx are cols in transpose
    float** data = new float*[num_cols];
    for (int c=0; c<num_cols; c++)
        data[c] = new float[num_rows];

    // transpose
    for (int r=0; r<num_rows; r++) {
        for (int c=0; c<num_cols; c++) {
            float tmp;
            scanf("%f",&tmp);
            data[c][r] = tmp;
        }
    }

    // write out
    for (int c=0; c<num_cols; c++) {
        for (int r=0; r<num_rows; r++) {
            float val = data[c][r];
            if (val==0)
                printf("0 ");
            else
                printf("%f ",val);
        }
        printf("\n");
    }

    return 0;

}
