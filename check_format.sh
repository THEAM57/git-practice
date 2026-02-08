#!/bin/bash

FILES=$(git diff --cached --name-only | grep '\.txt$')

if [ -z "$FILES" ]; then
    exit 0
fi

ERROR=0

for FILE in $FILES; do
    if [ ! -f "$FILE" ]; then
        continue
    fi

    LONG_LINES=$(grep -n '^.\{101,\}' "$FILE")
    if [ ! -z "$LONG_LINES" ]; then
        echo "Строка длиннее 100 символов"
        ERROR=1
    fi

    if [ -s "$FILE" ] && [ "$(tail -c 1 "$FILE")" != "" ]; then
        echo "Добавьте пустую строку в конце файла"
        ERROR=1
    fi
done

if [ $ERROR -eq 1 ]; then
    echo "Исправьте ошибки"
    exit 1
fi

echo "Все файлы корректны"
exit 0