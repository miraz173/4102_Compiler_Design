!/bin/bash

# Get the filename from argument 2
FILENAME=$1

# Convert the filename to a Windows-compatible path using winepath
WIN_FILENAME=$(winepath -w "$FILENAME.asm")

# Assemble the ASM file to produce the object file
if ! wine "C:\\masm32\\bin\\ml.exe" /c /coff /Cp "$WIN_FILENAME"; then
    echo "Error: Assembly failed!"
    exit 1
fi

# Convert the object filename to Windows-compatible path
WIN_OBJ_FILE=$(winepath -w "$FILENAME.obj")

# Link the object file to produce the executable
if ! wine "C:\\masm32\\bin\\link.exe" -entry:main /subsystem:console "$WIN_OBJ_FILE"; then
    echo "Error: Linking failed!"
    exit 1
fi

# Convert the executable filename to Windows-compatible path
WIN_EXE_FILE=$(winepath -w "$FILENAME.exe")

# Run the resulting executable using Wine
if wine "$WIN_EXE_FILE"; then
    echo "Succesfull Execution!"
    exit 0;
else
    echo "Error: Executable failed to run!"
    exit 1
fi
