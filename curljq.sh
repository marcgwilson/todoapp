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

url="$ADDR/?state=todo&due:gt=$(rfcdate "$(daysoffset '-10')")&due:lt="$(rfcdate "$(daysoffset '+10')")"&page=1"

echo "GET $url"
curl -sX GET $url | jq -r

payload='{"desc":"My Todo", "due":"'$(rfcdate "$(daysoffset '+10')")'", "state": "todo"}'
echo "POST $ADDR $payload"
result=$(curl -sX POST $ADDR -d "$payload" -H "Content-Type: application/json")
echo $result | jq -r

id=$(echo $result | python -c "import json,sys;obj=json.load(sys.stdin);print obj['id'];")

url="$ADDR/$id/"
echo "GET $url"
curl -sX GET $url | jq -r

payload='{"state": "in_progress"}'
echo "PATCH $url $payload"
result=$(curl -sX PATCH $url -d "$payload" -H "Content-Type: application/json")
echo $result | jq -r

echo "GET $url"
curl -sX GET $url | jq -r

payload='{"state": "done"}'
echo "PATCH $url $payload"
result=$(curl -sX PATCH $url -d "$payload" -H "Content-Type: application/json")
echo $result | jq -r

echo "GET $url"
curl -sX GET $url | jq -r

payload='{"due":"'$(rfcdate "$(daysoffset '+20')")'", "state": "in_progress"}'
echo "PATCH $url $payload"
result=$(curl -sX PATCH $url -d "$payload" -H "Content-Type: application/json")
echo $result | jq -r

echo "GET $url"
curl -sX GET $url | jq -r

echo "DELETE $url"
curl -sX DELETE $url | jq -r

echo "GET $url"
curl -sX GET $url | jq -r

payload='{"desc":"In progress TODO", "due":"'$(rfcdate "$(daysoffset '+10')")'", "state": "in_progress"}'
echo "POST $ADDR $payload"
result=$(curl -sX POST $ADDR -d "$payload" -H "Content-Type: application/json")
echo $result | jq -r

ida=$(todoid $result)
url="$ADDR/$ida/"

echo "GET $url"
curl -sX GET $url | jq -r

payload='{"desc":"Done TODO", "due":"'$(rfcdate "$(daysoffset '+10')")'", "state": "done"}'
echo "POST $ADDR $payload"
result=$(curl -sX POST $ADDR -d "$payload" -H "Content-Type: application/json")
echo $result | jq -r
idb=$(todoid $result)

url="$ADDR/$idb/"
echo "GET $url"
curl -sX GET $url | jq -r

url="$ADDR/?state=in_progress"
echo "GET $url"
curl -sX GET $url | jq -r

url="$ADDR/?state=done"
echo "GET $url"
curl -sX GET $url | jq -r

url="$ADDR/?state=todo"
echo "GET $url"
curl -sX GET $url | jq -r

url="$ADDR/?state=todo&state=in_progress"
echo "GET $url"
curl -sX GET $url | jq -r

echo -e "\nERRORS\n"

payload='{"desc":"My Gabagoo", "due":"gabagoo", "state": "todo"}'
echo "POST $ADDR $payload"
result=$(curl -sX POST $ADDR -d "$payload" -H "Content-Type: application/json")
echo $result | jq -r

payload='{"due":"gabagoo", "state": "todo"}'
echo "POST $ADDR $payload"
result=$(curl -sX POST $ADDR -d "$payload" -H "Content-Type: application/json")
echo $result | jq -r

