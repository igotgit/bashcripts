#!/usr/bin/env bash

# Gets the response of submitting the Passport Number
# and sends out a mail as soon as "negresponse" is not found any more on the result page
# Replace at least the first two variables (passport_nr and email) with your own data

passport_nr="XXXXXXXXXX"
email="something@example.com"

# A text the page returns in case the passport is not available yet. Separate possible negative responses with a pipe |
# String "kein Ergebnis" is returned if passport number is not in the system (neither waiting, nor available)
negresponse="liegt nicht vor|kein Ergebnis"
defaultresponse="kein Ergebnis"
query_page="https://www.stadt-koeln.de/service/onlinedienste/ist-ihr-pass-oder-personalausweis-abholbereit"

# Optionally you can parse the site with lynx: | lynx -dump -nolist -stdin
# curl returns 0 if searchphrase is found
response=$(curl -sd "nummer=${passport_nr}&submit=B1" "${query_page}" | egrep -qi "${negresponse}" ; echo $?)

# Check Response and send email if curl response is not 0
if [[ "$response" -ne "0" ]]; then
	        echo "Reisepass ist da" | mail -s "Reisepass ist abholbereit" "${email}"
fi

exit $?
