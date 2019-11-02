#! /bin/bash

DEFAULT="0.0.0.0:8000"

ADDR=http://"${TODO_ADDR:-$DEFAULT}"

daysoffset() {
	if [ "$(uname)" == "Darwin" ]; then
		echo "-v$1d"
	elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
		echo "-d \"$1 days\""
	fi
}

rfcdate() {
	date "$@" -u +"%Y-%m-%dT%H:%M:%SZ"
}

todoid() {
	echo $(echo "$@" | python -c "import json,sys;obj=json.load(sys.stdin);print obj['id'];")
}

url="$ADDR/?state=todo&due:gt=$(rfcdate)&due:lt="$(rfcdate $(daysoffset '+10'))"&page=1&count=20"
echo $url

curl -X GET $url

curl -X GET "$ADDR/1/"
curl -X POST $ADDR -d '{"desc":"My Todo", "due":"'$(rfcdate $(daysoffset '+10'))'", "state": "todo"}' -H "Content-Type: application/json"

result=$(curl -s -X POST $ADDR -d '{"desc":"My Todo", "due":"'$(rfcdate $(daysoffset '+10'))'", "state": "todo"}' -H "Content-Type: application/json")

echo $result

id=$(echo $result | python -c "import json,sys;obj=json.load(sys.stdin);print obj['id'];")

result=$(curl -s -X PATCH "$ADDR/$id/" -d '{"state": "in_progress"}' -H "Content-Type: application/json")

curl -X GET "$ADDR/$id/"

result=$(curl -s -X PATCH "$ADDR/$id/" -d '{"state": "done"}' -H "Content-Type: application/json")

curl -X GET "$ADDR/$id/"

result=$(curl -s -X PATCH "$ADDR/$id/" -d '{"due":"'$(rfcdate $(daysoffset '+20'))'", "state": "in_progress"}' -H "Content-Type: application/json")

curl -X GET "$ADDR/$id/"

curl -X DELETE "$ADDR/$id/"

curl -X GET "$ADDR/$id/"

result=$(curl -s -X POST $ADDR -d '{"desc":"In progress TODO", "due":"'$(rfcdate $(daysoffset '+10'))'", "state": "in_progress"}' -H "Content-Type: application/json")

ida=$(todoid $result)

curl -X GET "$ADDR/$ida/"

result=$(curl -s -X POST $ADDR -d '{"desc":"Done TODO", "due":"'$(rfcdate $(daysoffset '+10'))'", "state": "done"}' -H "Content-Type: application/json")

idb=$(todoid $result)

curl -X GET "$ADDR/$idb/"

curl -X GET "$ADDR/?state=in_progress"
curl -X GET "$ADDR/?state=done"
curl -X GET "$ADDR/?state=todo"

echo -e "\nERRORS\n"

curl -s -X POST $ADDR -d '{"desc":"My Gabagoo", "due":"gabagoo", "state": "todo"}' -H "Content-Type: application/json"
curl -s -X POST $ADDR -d '{"due":"gabagoo", "state": "todo"}' -H "Content-Type: application/json"


