while true
do
echo --------------------------
echo User Name: $(whoami)
echo Student Number : 12174819
echo [ MENU ]
echo 1. Get the data of the movie identified by a specific 'movie id' from 'u.item'
echo 2. Get the data of action genre movies from 'u.item'
echo 3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'
echo 4. Delete the 'IMDb URL' from 'u.item'
echo 5. Get the data about users from 'u.user'
echo 6. Modify the format of 'release date' in 'u.item'
echo 7. Get the data of movies rated by a specific 'user id' from 'u.data'
echo 8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'
echo 9. Exit
echo --------------------------
read -p "Enter your choice [ 1-9 ] " menu
	case $menu in
	1) read -p "Please enter 'movie id'(1~1682):" mvid
	   cat u.item | awk -F\| '$1=='"$mvid"'{print $0}'
	   ;;
   	2) read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n):" yn
	  	 if [ "$yn" == "y" ]
	  	 then cat u.item | awk -F\| '$7==1 {print $1, $2}' | head -10
		 fi ;;
	3) read -p "Please enter the 'movie id'(1~1682):" mvid
	   cat u.data | awk -v sum=0 -v num=0 '$2=='"$mvid"'{sum+=$3} $2=='"$mvid"'{num+=1} END {printf("%.5f\n",sum/num)}';;
   	4) read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n):" yn
	  	 if [ "$yn" == "y" ]
	  	 then cat u.item | sed -E 's/http.*\)//g' | head -10
		 fi ;;
	5) read -p "Do you want to get the data about users from 'u.user'?(y/n):" yn
		 if [ "$yn" == "y" ]
	  	 then cat u.user | awk -F\| '{print "user", $1, "is", $2, "years old",$3,$4}' | sed -E 's/M/male/g' | sed -E 's/F/female/g' | head -10
		 fi ;;
	6) read -p "Do you want to Modify the format of 'release data' in 'u.item'?(y/n):" yn
		 if [ "$yn" == "y" ]
		 then cat u.item | awk -F '[|-]' -v d=$d -v m=$m -v y=$y '{d=$3}{m=$4}{y=$5} {print $1"|"$2"|"$5$4$3"|"$6"|"$7"-"$8"|"$9"|"$10"|"$11"|"$12"|"$13"|"$14"|"$15"|"$16"|"$17"|"$18"|"$19"|"$20"|"$21"|"$22"|"$23"|"$24"|"$25"|"$26"|"$27}' | sed -e 's/Jan/01/g' -e 's/Feb/02/g' -e 's/Mar/03/g' -e 's/Apr/04/g' -e 's/May/05/g' -e 's/Jun/06/g' -e 's/Jul/07/g' -e 's/Aug/08/g' -e 's/Sep/09/g' -e 's/Oct/10/g' -e 's/Nov/11OB/g' -e 's/Dec/12/g' | tail -10
		 fi ;;
	7) read -p "Please enter the 'user id' (1~943):" userid
	    cat u.data | awk '$1=='"$userid"' {print $2}' | sort -g | xargs echo | sed 's/ /|/g'
	   printf "\n\n"
	   for i in $(awk '$1=='"$userid"'{print $2 | "sort -g"}' u.data | head -10)
	   do awk -F\| '$1=='"$i"' {print $1"|"$2}' u.item
	   done ;;
	8) read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):" yn
	         if [ "$yn" == "y" ]
                 then
             	 	awk -F\| '20<=$2&&$2<=29&&$4=="programmer" {print $1}' u.user > temp
		 	for i in $(cat temp);do cat u.data | awk '$1=='"$i"' {print $2" "$3}'; done > temp1
			for i in $(cat temp);do cat u.data | awk '$1=='"$i"' {print $2}'; done | sort -g | uniq > temp2
		        for i in $(cat temp2);do cat temp1 | awk -v sum=0 -v num=0 '$1=='"$i"'{sum+=$2} $1=='"$i"'{num++} END { printf("%d %g\n",'"$i"',sum/num)}';done
		 fi ;;
	 9) printf "Bye!"
		 break ;;
	 *) continue;;
 	 esac
done
