#!/bin/bash
find "Results/homo" -type f -delete
find "Results/nonpoly" -type f -delete
find "Results/sufficient" -type f -delete
find "Results/plots" -type f -delete
find "Results/problem" -type f -delete

echo "clean results"