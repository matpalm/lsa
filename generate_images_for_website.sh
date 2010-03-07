set -x
rm SVD_EG-*
./svd -r dt SVD_EG -o SVD_EG

./transpose < SVD_EG-Ut > SVD_EG-U
./multiply_by_column.rb SVD_EG-U SVD_EG-S > SVD_EG-US
./matrix_to_csv_for_r.rb < SVD_EG-US > SVD_EG-US.csv

./transpose < SVD_EG-Vt > SVD_EG-V
./multiply_by_column.rb SVD_EG-U SVD_EG-S > SVD_EG-US
./multiply_by_column.rb SVD_EG-V SVD_EG-S > SVD_EG-VS
./matrix_to_csv_for_r.rb < SVD_EG-VS > SVD_EG-VS.csv

mkdir site 2>/dev/null
R --vanilla < render_graphs.R
