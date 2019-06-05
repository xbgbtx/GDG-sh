#Generates a requirements.txt file using pip3
#Strips away a module called 'pkg-resources' that seems to be installed
#due to a debian bug
pip3 freeze | grep -v "pkg-resources" > requirements.txt

