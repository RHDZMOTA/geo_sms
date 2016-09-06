echo
echo ::::::::::::::: Log Location/Position ::::::::::::::: 
echo This program will record the device s postion
echo and evaluate whenever you go in or out of a
echo fixed area.
echo
# needs bc and jq (apt-install if needed)

# H O M E
# Latitude and longitude of reference (origin): home rhm
a_lat=20.68984931	
a_lon=-103.444991036		

# Latitude and longitude of reference (origin): university iteso
b_lat=0
b_lon=0
j=0


# U I V E R S I T Y
# Latitude and longitude of reference (origin): home rhm
# Cafedela:{lat:20.6053712272	, lon:-103.415487669}
# Estacion:{lat: , lon: }
# Edif.J  :{lat: , lon: }
# Edif.T	  :{lat: , lon: }
# Edif.W  :{lat: , lon: }
# Edif.D  :{lat: , lon: }
# Edif.C  :{lat: , lon: }
# Edif.GYM:{lat: , lon: }
# ombligo :{lat: , lon: }

a_latu=20.68984931	
a_lonu=-103.444991036		

# Latitude and longitude of reference (origin): university iteso
b_latu=0
b_lonu=0
ju=0

# variables for leaving 
leave_home=0

k=1
i=0
while true
do
    echo --------------------------------------
    echo recording... -- iter.num: $k
    
    sleep 50
    
    # Get the current location using termux 
    loc=$(termux-location)

    # Save the date and time in variables
    day=$(date "+%d-%m-%Y")
    time=$(date "+%H:%M:%S")
    
    # Save the relevat info. in loc
    lat=$(echo $loc | jq .latitude)
    lon=$(echo $loc | jq .longitude)
    alt=$(echo $loc | jq .altitude)
    
    # H O M E
    
    # limits in lat and long: home
    ls_lat=$(echo $a_lat + 0.015 | bc)
    li_lat=$(echo $a_lat - 0.015 | bc)
    ls_lon=$(echo $a_lon + 0.003 | bc)
    li_lon=$(echo $a_lon - 0.003 | bc	)
    
    # conditional to enter the zone: home
    if [ $(echo "${lat} < ${ls_lat}" | bc) -eq 1 ] && [ $(echo "${lon} < ${ls_lon}" | bc) -eq 1 ];
    then
        if [ $(echo "	${lat} > ${li_lat}" | bc) -eq 1 ] && [ $(echo "${lon} > ${li_lon}" | bc) -eq 1 ];
        then
            if [ "$i" -eq "$j" ];
            then
                j=$(($j+1))
                echo 
                echo Just arriving home. Reseting 'k' variable...
                k=0
                echo Done.
                echo	
                ans=$(echo ${day}: Arriving home aprox. at ${time}. Coord - {lat.${lat}, lon.${lon}, alt.${alt}})
                #echo $ans
                termux-sms-send -n 3314105505 $(echo ${ans})
                termux-sms-send -n 3310097615 $(echo ${ans})
            fi
        fi
    fi
    # conditional to leave zone: home
    if [ $(echo "${lat} > ${ls_lat}" | bc) -eq 1 ] || [ $(echo "${lon} > ${ls_lon}" | bc) -eq 1 ];
    then
        if [ "$i" -ne "$j" ];
        then
            # leaving home, turn on leave_home
            leave_home=1
        fi
    fi
    
    if [ $(echo "	${lat} < ${li_lat}" | bc) -eq 1 ] || [ $(echo "${lon} < ${li_lon}" | bc) -eq 1 ];
    then
        if [ "$i" -ne "$j" ];
        then
            # leaving home, turn on leave_home
            leave_home=1
        fi
    fi
    
    if [ "$leave_home" -eq "1" ];
    then
        j=$(($j-1))
        echo 
        echo Just leaving home. Reseting 'k' variable...
        k=0
        echo Done.
        echo	
        ans=$(echo ${day}: Leaving		 home aprox. at ${time}. Coord - {lat.${lat}, lon.${lon}, alt.${alt}})
        #echo $ans
        termux-sms-send -n 3314105505 $(echo ${ans})
        termux-sms-send -n 3310097615 $(echo ${ans})
        leave_home=0
    fi
    
    
    #if [ $(echo "${lat} > ${ls_lat}" | bc) -eq 1 ] && [ $(echo "${lon} > ${ls_lon}" | bc) -eq 1 ];
    #then
    #    if [ $(echo "	${lat} < ${li_lat}" | bc) -eq 1 ] && [ $(echo "${lon} < ${li_lon}" | bc) -eq 1 ];
    #    then
    #        if [ "$i" -ne "$j" ];
    #        then
    #            j=$(($j-1))
    #            echo 
    #            echo Just leaving home. Reseting 'k' variable...
    #            k=0
    #            echo Done.
    #            echo	
    #            ans=$(echo ${day}: Leaving		 home aprox. at ${time}. Coord - {lat.${lat}, lon.${lon}, alt.${alt}})
    #            #echo $ans
    #            termux-sms-send -n 3314105505 $(echo ${ans})
    #            termux-sms-send -n 3310097615 $(echo ${ans})
    #        fi
    #    fi
    #fi
    
    # U N I V E R S I T Y - I T E S O 
    
    # add_code
    
    
    # Autoincrement k-variable
    k=$((k+1))
    echo Ok!
    
done

	



