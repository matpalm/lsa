let F=${1}+1
echo "top"
sort -k$F -n urls_with_features | tail -20 | tac | cut -f$F,1,2 -d\ 
echo "bottom"
sort -k$F -nr urls_with_features | tail -20 | cut -f$F,1,2 -d\ 


