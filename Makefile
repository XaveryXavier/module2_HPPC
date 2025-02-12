CXX := g++

#######################################################
# Optimization flags are chosen as the last definition.
# Comment out using "#" at the begining of the line or rearrange according to your needs.
#
# Fastest executable (-ffast-math removes checking for NaNs and other things)
OPT=-O3 -ffast-math

# Add profiling to code
OPT=-O1 -pg

# Faster compilation time
OPT=-O3 -ffast-math -pg

CXXFLAGS := $(OPT) -pg -Wall -march=native -g -std=c++17

default: seq vec

seq: Water_sequential.cpp
	$(CXX) Water_sequential.cpp $(CXXFLAGS) -o seq

vec: Water_vectorised.cpp
	$(CXX) Water_vectorised.cpp $(CXXFLAGS) -fopenmp-simd -o vec

profiler_vec: vec 
	./vec
	gprof -p -b ./vec gmon.out > vec_analysis.txt

profiler_seq: seq
	./seq
	gprof -p -b ./seq gmon.out > seq_analysis.txt

exercise2: vec seq
	for i in 10 100 1000 10000; do \
		./vec -no_mol $$i; \
		gprof -p -b ./vec gmon.out > vec_analysis_$$i.txt; \
		./seq -no_mol $$i; \
		gprof -p -b ./seq gmon.out > seq_analysis_$$i.txt; \
	done
clean:
	rm -fr seq vec
