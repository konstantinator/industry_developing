#!/bin/bash

# parcing
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --input_folder)
            input_folder="$2"
            shift
            shift
            ;;
        --extension)
            extension="$2"
            shift
            shift
            ;;
        --backup_folder)
            backup_folder="$2"
            shift
            shift
            ;;
        --backup_archive_name)
            backup_archive_name="$2"
            shift
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# check args
if [[ -z "$input_folder" || -z "$extension" || -z "$backup_folder" || -z "$backup_archive_name" ]]; then
    echo "Usage: $0 --input_folder [input_folder] --extension [extension] --backup_folder [backup_folder] --backup_archive_name [backup_archive_name]"
    exit 1
fi

# create backup folder
mkdir $backup_folder

# find and backup files
find "$input_folder" -name "*.$extension" -exec cp --parents {} "$backup_folder" \;
mv $backup_folder/$input_folder/ $backup_folder/
find $backup_folder -depth -type d -empty -exec rmdir {} \;

# archivate
tar -czf "$backup_archive_name" -C "$backup_folder" .

# clear backup_folder
rm -rf "$backup_folder"

echo "done"
