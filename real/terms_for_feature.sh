let F=${1}+1
N=15
echo ">>> top"
sort -k$F -n terms_with_features | tail -$N | tac | cut -f$F,1,2 -d\ 
echo ">>> bottom"
sort -k$F -nr terms_with_features | tail -$N | cut -f$F,1,2 -d\ 
