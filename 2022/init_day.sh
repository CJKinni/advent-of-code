#!/usr/bin/env bash

day=$1
if [ -z "$day" ]; then
    echo "Usage: init_day.sh <day>"
    exit 1
fi

# Check if "$day.py" exists
if [ -f "$day.py" ]; then
    echo "File $day.py already exists"
    # Check if argument -f or --force is passed in any position
    if [[ "$@" =~ -f|--force ]]; then
        echo "Overwriting $day.py"
        rm "$day.py"
    else
        exit 1
    fi
fi

touch "$day.py"
touch "input_$day.txt"

# set a variable to a string of template.py, swapping $day in that string to $day:
template=$(sed "s/\$day/$day/g" template.py)
echo "$template" > "$day.py"

rm "run.sh"
touch "run.sh"
echo "#!/usr/bin/env bash

pipenv run python $day.py" >> "run.sh"