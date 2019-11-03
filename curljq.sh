#! /bin/bash

DEFAULT="0.0.0.0:8000"

ADDR=http://"${TODO_ADDR:-$DEFAULT}"

daysoffset() {
	if [ "$(uname)" == "Darwin" ]; then
		echo "-v$1d"
	elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
		echo "-d $1 days"
	fi
}

rfcdate() {
	date "$@" -u +"%Y-%m-%dT%H:%M:%SZ"
}

todoid() {
	echo $(echo "$@" | python -c "import json,sys;obj=json.load(sys.stdin);print obj['id'];")
}

url="$ADDR/?state=todo&due:gt=$(rfcdate)&due:lt="$(rfcdate "$(daysoffset '+10')")"&page=1&count=20"
# echo $url
curl -sX GET $url | jq -r

curl -sX GET "$ADDR/1/" | jq -r
curl -sX POST $ADDR -d '{"desc":"My Todo", "due":"'$(rfcdate "$(daysoffset '+10')")'", "state": "todo"}' -H "Content-Type: application/json" | jq -r

result=$(curl -sX POST $ADDR -d '{"desc":"My Todo", "due":"'$(rfcdate "$(daysoffset '+10')")'", "state": "todo"}' -H "Content-Type: application/json")
echo $result | jq -r

id=$(echo $result | python -c "import json,sys;obj=json.load(sys.stdin);print obj['id'];")

result=$(curl -sX PATCH "$ADDR/$id/" -d '{"state": "in_progress"}' -H "Content-Type: application/json")
echo $result | jq -r

curl -sX GET "$ADDR/$id/" | jq -r

result=$(curl -sX PATCH "$ADDR/$id/" -d '{"state": "done"}' -H "Content-Type: application/json")
echo $result | jq -r

curl -sX GET "$ADDR/$id/" | jq -r

result=$(curl -sX PATCH "$ADDR/$id/" -d '{"due":"'$(rfcdate "$(daysoffset '+20')")'", "state": "in_progress"}' -H "Content-Type: application/json")
echo $result | jq -r

curl -sX GET "$ADDR/$id/" | jq -r

curl -sX DELETE "$ADDR/$id/" | jq -r

curl -sX GET "$ADDR/$id/" | jq -r

result=$(curl -sX POST $ADDR -d '{"desc":"In progress TODO", "due":"'$(rfcdate "$(daysoffset '+10')")'", "state": "in_progress"}' -H "Content-Type: application/json")
echo $result | jq -r

ida=$(todoid $result)

curl -sX GET "$ADDR/$ida/" | jq -r

result=$(curl -sX POST $ADDR -d '{"desc":"Done TODO", "due":"'$(rfcdate "$(daysoffset '+10')")'", "state": "done"}' -H "Content-Type: application/json")
echo $result | jq -r
idb=$(todoid $result)

curl -sX GET "$ADDR/$idb/" | jq -r

curl -sX GET "$ADDR/?state=in_progress" | jq -r
curl -sX GET "$ADDR/?state=done" | jq -r
curl -sX GET "$ADDR/?state=todo" | jq -r

echo -e "\nERRORS\n"

curl -sX POST $ADDR -d '{"desc":"My Gabagoo", "due":"gabagoo", "state": "todo"}' -H "Content-Type: application/json" | jq -r
curl -sX POST $ADDR -d '{"due":"gabagoo", "state": "todo"}' -H "Content-Type: application/json" | jq -r
