#!/bin/bash

echo
echo ::::::::::::: Log Location/Position ::::::::::::: 
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
j=0


# U I V E R S I T Y
# Latitude and longitude of reference (origin): home rhm
# Cafedela:{lat:20.6053712272, lon:-103.415487669}
# Estacion:{lat:20.60789339  , lon:-103.41867427 }
# Sill_t  :{lat:20.60868543  , lon:-103.41601339 }
# D-I     :{lat:20.60733863  , lon:-103.41713981 }
# Edif.W  :{lat:20.60817997  , lon:-103.41293266 }
# Cafe_cet:{lat:20.60714689  , lon:-103.41637681 }
# Edif.J  :{lat:20.60808981  , lon:-103.41659186 }
# Edif.GYM:{lat:20.60663732  , lon:-103.41357498 }
# ombligo :{lat:20.60735495  , lon:-103.41594987 }
# Arrupe  :{lat:20.60863197  , lon:-103.41431816 }


a_latu=20.607	#+- 0.0021 
a_lonu=-103.415		#+- 0.0032

# Latitude and longitude of reference (origin): university iteso
ju=0

# variables for leaving 
leave_home=0
leave_univ=0

k=1
i=0
while true
do
    echo --------------------------------------
    echo recording... -- iter.num: $k
    
    sleep 50
    
    # General use variables
    
    # Get the current location using termux 
    loc=$(termux-location)
    

    # Save the date and time in variables
    day=$(date "+%d-%m-%Y")
    time=$(date "+%H:%M:%S")
    
    # Save the relevat info. in loc
    lat=$(echo $loc | jq .latitude)
    lon=$(echo $loc | jq .longitude)
    alt=$(echo $loc | jq .altitude)
    
    echo {lat:$lat, lon:$lon, alt:$alt}
    
    # Test if the location is available.
    {	
        [ $(echo "${lat} < 1000000" | bc) -eq 1 ]
    } || {
        echo
        echo warning: unavailable...
        continue 
    }
    
    
    
    
    
    
    
    
    
    
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
        ans=$(echo ${day}: Leaving	 home aprox. at ${time}. Coord - {lat.${lat}, lon.${lon}, alt.${alt}})
        #echo $ans
        termux-sms-send -n 3314105505 $(echo ${ans})
        termux-sms-send -n 3310097615 $(echo ${ans})
        leave_home=0
    fi
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    # U N I V E R S I T Y - I T E S O 
    
    # limits in lat and long: university  
    ls_lat=$(echo $a_latu + 0.0021 | bc)
    li_lat=$(echo $a_latu - 0.0021 | bc)
    ls_lon=$(echo $a_lonu + 0.0032 | bc)
    li_lon=$(echo $a_lonu - 0.0032 | bc	)
    
    # conditional to enter the zone: home
    if [ $(echo "${lat} < ${ls_lat}" | bc) -eq 1 ] && [ $(echo "${lon} < ${ls_lon}" | bc) -eq 1 ];
    then
        if [ $(echo "	${lat} > ${li_lat}" | bc) -eq 1 ] && [ $(echo "${lon} > ${li_lon}" | bc) -eq 1 ];
        then
            if [ "$i" -eq "$ju" ];
            then
                ju=$(($ju+1))
                echo 
                echo Just arriving to ITESO UNIV.. Reseting 'k' variable...
                k=0
                echo Done.
                echo	
                ans=$(echo ${day}: Arriving ITESO aprox. at ${time}. Coord - {lat.${lat}, lon.${lon}, alt.${alt}})
                #echo $ans
                termux-sms-send -n 3314105505 $(echo ${ans})
                termux-sms-send -n 3310097615 $(echo ${ans})
            fi
        fi
    fi
    # conditional to leave zone: home
    if [ $(echo "${lat} > ${ls_lat}" | bc) -eq 1 ] || [ $(echo "${lon} > ${ls_lon}" | bc) -eq 1 ];
    then
        if [ "$i" -ne "$ju" ];
        then
            # leaving home, turn on leave_home
            leave_univ=1
        fi
    fi
    
    if [ $(echo "	${lat} < ${li_lat}" | bc) -eq 1 ] || [ $(echo "${lon} < ${li_lon}" | bc) -eq 1 ];
    then
        if [ "$i" -ne "$ju" ];
        then
            # leaving home, turn on leave_home
            leave_univ=1
        fi
    fi
    
    if [ "$leave_univ" -eq "1" ];
    then
        ju=$(($ju-1))
        echo 
        echo Just leaving ITESO UNIV. Reseting 'k' variable...
        k=0
        echo Done.
        echo	
        ans=$(echo ${day}: Leaving		ITESO aprox. at ${time}. Coord - {lat.${lat}, lon.${lon}, alt.${alt}})
        #echo $ans
        termux-sms-send -n 3314105505 $(echo ${ans})
        termux-sms-send -n 3310097615 $(echo ${ans})
        leave_univ=0
    fi
    
    
    
    
    
    
    
    
    
    
    
    
    # E N D
    
    # Autoincrement k-variable
    k=$((k+1))
    echo Ok!
    
done

	



