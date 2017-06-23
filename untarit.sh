#!/bin/bash

# _____________________________________________________________________________
# 
# untarit shell 
#  
# License
# :: Copyright 2017 by Lukas Hammerschmidt
#  
# :: This is a free bash script code. It is a script for using tar and gnu gzip.
#    For that reason you can redistribute it and/or modify it under the terms
#    of the GNU General Public License as published by the Free Software 
#    Foundation, either version 3 of the License, or any later version.
# 
# :: This piece of code is distributed in the hope that it will be useful, but 
#    WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
#    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
#    for more details. You should have received a copy of the GNU General
#    Public License along with this code.  If not, see 
#    <http://www.gnu.org/licenses/>.
# 
# _____________________________________________________________________________



function usage_help
{
  echo 
  echo "Usage: untarit [-nd] [-q] [-h] [tar-FILE] "
  echo
  echo "positional arguments:"
  echo "[FILE/FOLDER]               Provide at least one file/folder name (or a list)"
  echo
  echo "optional arguments:"
  echo "  -h, --help               show this help message and exit"
  echo "  -nd, --no-delete         do NOT delete original folder/file"
  echo "  -q, --quiet              be quiet. Don't show any text."
  echo
}

print_error_message()
{
  echo "Error! '$1' is not a valid argument or file/folder."
  echo "Use -h to see help and usage of tarit."
  exit 1
}



#--------------------------------------------------
# Main
#--------------------------------------------------
not_delete=false
quiet=false
exitStatus=0
file=""

declare -a file_array

#-----------------------
# Check for options
#-----------------------
if [ "$#" -gt 0 ]; then                      # :: loop over all given command line arguments

  while [ "$1" != "" ]; do
    
    if [ ! -e "$1" ]; then                   # :: if argument $1 is not a file check if
                                             #    it is an option
  
      case $1 in
        -nd | --no-delete )  not_delete=true
                             ;;
        -q  | --quiet )      quiet=true
                             ;;
        -h  | --help )       usage_help
                             exit 1
                             ;;
        * )                  print_error_message $1
                             ;;
      esac
    else
      file_array=("${file_array[@]}" "$1")   # :: add file to file array to loop over later
    fi
    
    shift                                    # :: next argument
    
  done

else
  usage_help
  exit 1
fi


#---------------------------
# If no files given, stop
#---------------------------
if [ ${#file_array[@]} -le 0 ]; then
  usage_help
  exit 1
fi


#---------------------------
# Loop over all input files
#---------------------------
for file in "${file_array[@]}"; do

  #-----------------------
  # filename
  #-----------------------
  filename=$file

  #-----------------------
  # Do the Un-Taring
  #-----------------------
  if [ "$quiet" = "true" ]; then
    tar -xzf $filename
    exitStatus=$?                               # catch exit-code from tar
  else
    tar -xvzf $filename
    exitStatus=$?
  fi
    
  #-----------------------
  # Check exit code of
  #   untaring
  #-----------------------
  if [ $exitStatus -ne 0 ]; then
    echo "Error: tar-related error!"
    echo "       Original file will not be deleted!"
    exit 1
  fi
  
  #-----------------------
  # Perform delete action
  #-----------------------
  if [ "$not_delete" = "true" ];then
    echo "Tar successful. Orig.file not deleted."
  else
    echo "Tar successful. Orig.file deleted."
    rm -r $filename
  fi
  
done

exit 0
