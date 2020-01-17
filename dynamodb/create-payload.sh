#!/bin/bash

# script parameters
DYNAMODB_TABLENAME=$1

# Colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT_GRAY='\033[0;37m'
DARK_GRAY='\033[1;30m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHT_BLUE='\033[1;34m'
LIGHT_PURPLE='\033[1;35m'
LIGHT_CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Global variable declarations
DATALOAD_FILE_1=dataload-1.json
DATALOAD_FILE_2=dataload-2.json

###########################################################
#                                                         #
#  Create the json files that will be used                #
#  for the data load                                      #
#                                                         #
###########################################################

# batch-write-item onlys supports up to 25 writes per request, therefore we chunk the uploads

# delete any previous instance of DATALOAD_FILE_1
if [ -f "$DATALOAD_FILE_1" ]; then
    rm $DATALOAD_FILE_1
fi

cat > $DATALOAD_FILE_1 <<EOF
{
    "${DYNAMODB_TABLENAME}": [
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e33efc4-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "2-1B"},
                    "Image": {"S": "starwars/images/figures/2-1B.jpg"},
                    "Movie": {"S": "The Empire Strikes Back"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e33f33e-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Nein Nunb"},
                    "Image": {"S": "starwars/images/figures/nein-nunb.jpg"},
                    "Movie": {"S": "Return of the Jedi"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e33f4a6-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Tie Fighter Pilot"},
                    "Image": {"S": "starwars/images/figures/tie-fighter-pilot.jpg"},
                    "Movie": {"S": "The Empire Strikes Back"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e33f776-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Walrusman"},
                    "Image": {"S": "starwars/images/figures/walrusman.jpg"},
                    "Movie": {"S": "Star Wars"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e33f8d4-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Hammerhead"},
                    "Image": {"S": "starwars/images/figures/hammerhead.jpg"},
                    "Movie": {"S": "Star Wars"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e33fa00-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Admiral Ackbar"},
                    "Image": {"S": "starwars/images/figures/admiral-ackbar.jpg"},
                    "Movie": {"S": "Return of the Jedi"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e33fc76-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Yoda"},
                    "Image": {"S": "starwars/images/figures/yoda.jpg"},
                    "Movie": {"S": "The Empire Strikes Back"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e33fdc0-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "R2-D2"},
                    "Image": {"S": "starwars/images/figures/r2-d2.jpg"},
                    "Movie": {"S": "Star Wars"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e33fef6-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Darth Vader"},
                    "Image": {"S": "starwars/images/figures/darth-vader.jpg"},
                    "Movie": {"S": "Star Wars"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e340022-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Luke Skywalker (Bespin Fatigues)"},
                    "Image": {"S": "starwars/images/figures/luke-skywalker-bespin-fatigues.jpg"},
                    "Movie": {"S": "The Empire Strikes Back"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e34039c-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Han Solo (Hoth Outfit)"},
                    "Image": {"S": "starwars/images/figures/han-solo-hoth-outfit.jpg"},
                    "Movie": {"S": "The Empire Strikes Back"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e340504-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Chewbacca"},
                    "Image": {"S": "starwars/images/figures/chewbacca.jpg"},
                    "Movie": {"S": "Star Wars"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e34064e-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "AT-AT Driver"},
                    "Image": {"S": "starwars/images/figures/at-at-driver.jpg"},
                    "Movie": {"S": "The Empire Strikes Back"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e340900-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Stormtrooper"},
                    "Image": {"S": "starwars/images/figures/stormtrooper.jpg"},
                    "Movie": {"S": "Star Wars"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e340a40-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Luke Skywalker (Hoth Battle Gear)"},
                    "Image": {"S": "starwars/images/figures/luke-skywalker-hoth-battle-gear.jpg"},
                    "Movie": {"S": "The Empire Strikes Back"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e340b76-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Dengar"},
                    "Image": {"S": "starwars/images/figures/dengar.jpg"},
                    "Movie": {"S": "The Empire Strikes Back"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e340dc4-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Logray"},
                    "Image": {"S": "starwars/images/figures/logray.jpg"},
                    "Movie": {"S": "The Empire Strikes Back"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e340f0e-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Weequay"},
                    "Image": {"S": "starwars/images/figures/weequay.jpg"},
                    "Movie": {"S": "Return of the Jedi"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e341044-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Rebel Commander"},
                    "Image": {"S": "starwars/images/figures/rebel-commander.jpg"},
                    "Movie": {"S": "The Empire Strikes Back"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e34117a-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Rebel Soldier"},
                    "Image": {"S": "starwars/images/figures/rebel-soldier-hoth-battle-gear.jpg"},
                    "Movie": {"S": "The Empire Strikes Back"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e3413c8-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Emperor Palpatine"},
                    "Image": {"S": "starwars/images/figures/emperor.jpg"},
                    "Movie": {"S": "Return of the Jedi"},
                    "Obtained": {"BOOL": true}
                }
            }
        },
        {
            "PutRequest": {
                "Item": {
                    "Id": {"S": "7e34151c-307d-11ea-978f-2e728ce88125"},
                    "Name": {"S": "Biker Scout"},
                    "Image": {"S": "starwars/images/figures/biker-scout.jpg"},
                    "Movie": {"S": "Return of the Jedi"},
                    "Obtained": {"BOOL": true}
                }
            }
        }
    ]
}
EOF

chmod +x $DATALOAD_FILE_1

# delete any previous instance of DATALOAD_FILE_2
if [ -f "$DATALOAD_FILE_2" ]; then
    rm $DATALOAD_FILE_2
fi

cat > $DATALOAD_FILE_2 <<EOF
{
   "${DYNAMODB_TABLENAME}":[
      {
         "PutRequest":{
            "Item":{
               "Id":{
                  "S":"fb994840-307f-11ea-978f-2e728ce88125"
               },
               "Name":{
                  "S":"Princess Leia Bounty Hunter Disguise (Boushh)"
               },
               "Image":{
                  "S":"starwars/images/figures/leia-boushh.jpg"
               },
               "Movie":{
                  "S":"Return of the Jedi"
               },
               "Obtained":{
                  "BOOL": true
               }
            }
         }
      },
      {
         "PutRequest":{
            "Item":{
               "Id":{
                  "S":"fb994afc-307f-11ea-978f-2e728ce88125"
               },
               "Name":{
                  "S":"Princess Leia Bespin"
               },
               "Image":{
                  "S":"starwars/images/figures/leia-bespin.jpg"
               },
               "Movie":{
                  "S":"The Empire Strikes Back"
               },
               "Obtained":{
                  "BOOL": true
               }
            }
         }
      },
      {
         "PutRequest":{
            "Item":{
               "Id":{
                  "S":"fb994c5a-307f-11ea-978f-2e728ce88125"
               },
               "Name":{
                  "S":"Imperial Commander"
               },
               "Image":{
                  "S":"starwars/images/figures/imperial-commander.jpg"
               },
               "Movie":{
                  "S":"The Empire Strikes Back"
               },
               "Obtained":{
                  "BOOL": true
               }
            }
         }
      },
      {
         "PutRequest":{
            "Item":{
               "Id":{
                  "S":"fb996640-307f-11ea-978f-2e728ce88125"
               },
               "Name":{
                  "S":"Lobot"
               },
               "Image":{
                  "S":"starwars/images/figures/lobot.jpg"
               },
               "Movie":{
                  "S":"The Empire Strikes Back"
               },
               "Obtained":{
                  "BOOL": true
               }
            }
         }
      },
      {
         "PutRequest":{
            "Item":{
               "Id":{
                  "S":"fb994fc0-307f-11ea-978f-2e728ce88125"
               },
               "Name":{
                  "S":"Luke Skywalker X-Wing Pilot"
               },
               "Image":{
                  "S":"starwars/images/figures/luke-x-wing.jpg"
               },
               "Movie":{
                  "S":"Star Wars"
               },
               "Obtained":{
                  "BOOL": true
               }
            }
         }
      },
      {
         "PutRequest":{
            "Item":{
               "Id":{
                  "S":"fb995128-307f-11ea-978f-2e728ce88125"
               },
               "Name":{
                  "S":"Tuscan Raider"
               },
               "Image":{
                  "S":"starwars/images/figures/tuscan-raider.jpg"
               },
               "Movie":{
                  "S":"Star Wars"
               },
               "Obtained":{
                  "BOOL": true
               }
            }
         }
      },
      {
         "PutRequest":{
            "Item":{
               "Id":{
                  "S":"fb99525e-307f-11ea-978f-2e728ce88125"
               },
               "Name":{
                  "S":"Han Solo"
               },
               "Image":{
                  "S":"starwars/images/figures/han-solo-star-wars.jpg"
               },
               "Movie":{
                  "S":"Star Wars"
               },
               "Obtained":{
                  "BOOL": true
               }
            }
         }
      },
      {
         "PutRequest":{
            "Item":{
               "Id":{
                  "S":"fb995394-307f-11ea-978f-2e728ce88125"
               },
               "Name":{
                  "S":"Bib Fortuna"
               },
               "Image":{
                  "S":"starwars/images/figures/bib-fortuna.jpg"
               },
               "Movie":{
                  "S":"Return of the Jedi"
               },
               "Obtained":{
                  "BOOL": true
               }
            }
         }
      },
      {
         "PutRequest":{
            "Item":{
               "Id":{
                  "S":"fb9954d4-307f-11ea-978f-2e728ce88125"
               },
               "Name":{
                  "S":"Emperor's Royal Guard"
               },
               "Image":{
                  "S":"starwars/images/figures/royal-guard.jpg"
               },
               "Movie":{
                  "S":"Return of the Jedi"
               },
               "Obtained":{
                  "BOOL": true
               }
            }
         }
      },
      {
          "PutRequest": {
              "Item": {
                  "Id": {"S": "7e3417ec-307d-11ea-978f-2e728ce88125"},
                  "Name": {"S": "8D8"},
                  "Image": {"S": "starwars/images/figures/8d8.jpg"},
                  "Movie": {"S": "Return of the Jedi"},
                  "Obtained": {"BOOL": true}
              }
          }
      },
      {
          "PutRequest": {
              "Item": {
                  "Id": {"S": "7e341936-307d-11ea-978f-2e728ce88125"},
                  "Name": {"S": "Han Solo Bespin"},
                  "Image": {"S": "starwars/images/figures/han-solo-bespin.jpg"},
                  "Movie": {"S": "The Empire Strikes Back"},
                  "Obtained": {"BOOL": true}
              }
          }
      },
      {
          "PutRequest": {
              "Item": {
                  "Id": {"S": "fb995f38-307f-11ea-978f-2e728ce88125"},
                  "Name": {"S": "Klaatu"},
                  "Image": {"S": "starwars/images/figures/klaatu.jpg"},
                  "Movie": {"S": "Return of the Jedi"},
                  "Obtained": {"BOOL": true}
              }
          }
      }
   ]
}
EOF

chmod +x $DATALOAD_FILE_2