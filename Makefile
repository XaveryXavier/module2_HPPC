CXX := g++

#######################################################
# Optimization flags are chosen as the last definition.
# Comment out using "#" at the begining of the line or rearrange according to your needs.
#
# Add profiling to code
OPT=-O1 -pg

# Faster compilation time
OPT=-O1

# Fastest executable (-ffast-math removes checking for NaNs and other things)
OPT=-O3 -ffast-math

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
		echo "Running for $$i"; \
		./vec -no_mol $$i > data/vec_results$$i.txt; \
		gprof -p -b ./vec gmon.out > data/vec_analysis_$$i.txt; \
		./seq -no_mol $$i > data/seq_results$$i.txt; \
		gprof -p -b ./seq gmon.out > data/seq_analysis_$$i.txt; \
	done

exercise3: clean vec seq 
	for i in 10 100 1000; do \
		echo "Running for $$i"; \
		./vec -no_mol $$i > data/vec_results$$i.txt; \
		gprof -p -b ./vec gmon.out > data/vec_analysis_$$i.txt; \
		./seq -no_mol $$i > data/seq_results$$i.txt; \
		gprof -p -b ./seq gmon.out > data/seq_analysis_$$i.txt; \
	done
	
clean:
	rm -fr seq vec
