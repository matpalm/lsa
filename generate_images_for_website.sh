set -x

if [ $# -ne 1 ]
then
    echo "usage: generate_images_for_website EG_NUMBER"
    exit -1
fi

rm SVD_EG*

ln -s A${1} SVD_EG

./svd -r dt SVD_EG -o SVD_EG

NUM_FEATURES=`./number_of_features_given_input_matrix.rb SVD_EG` 

./transpose < SVD_EG-Ut > SVD_EG-U
./convert_from_svd_s_matrix_to_2d_matrix.rb $NUM_FEATURES < SVD_EG-S > SVD_EG-S.square
./multiply.rb SVD_EG-U SVD_EG-S.square > SVD_EG-US
./matrix_to_csv_for_r.rb < SVD_EG-US > SVD_EG-US.csv
./matrix_to_csv_for_r.rb < SVD_EG-U > SVD_EG-U.csv

./transpose < SVD_EG-Vt > SVD_EG-V
./multiply.rb SVD_EG-V SVD_EG-S.square > SVD_EG-VS
./matrix_to_csv_for_r.rb < SVD_EG-VS > SVD_EG-VS.csv
./matrix_to_csv_for_r.rb < SVD_EG-V > SVD_EG-V.csv

mkdir site 2>/dev/null
R --vanilla < render_graphs.R
mv SVD_EG-US.png site/SVD_EG-US.${1}.png
mv SVD_EG-US.V0V1.png site/SVD_EG-US.V0V1.${1}.png
mv SVD_EG-VS.png site/SVD_EG-VS.${1}.png
mv SVD_EG-VS.V0V1.png site/SVD_EG-VS.V0V1.${1}.png
