#!/bin/bash

# Compile the C backend
gcc -o texlike_pdf texlike_pdf.c -lhpdf

echo "Compilation complete. texlike_pdf executable generated."