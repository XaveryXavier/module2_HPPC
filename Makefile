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
	$(CXX) Water_vectorised.cpp $(CXXFLAGS) -o vec

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
	for k in 1 ; do \
		i=$$(echo 16 100 1000 10000| cut -d' ' -f$$k); \
		j=$$(echo 1000000 100000 10000 500| cut -d' ' -f$$k); \
		echo "Running for i=$$i and steps=$$j and no pragmas"; \
		./vec -no_mol $$i -steps $$j > data/vec_results$$i.nopragmas.txt; \
		gprof -p -b ./vec gmon.out > data/vec_analysis_$$i.nopragmas.txt; \
		./seq -no_mol $$i -steps $$j > data/seq_results$$i.nopragmas.txt; \
	done
	rm -fr seq vec
	$(CXX) Water_vectorised.cpp $(CXXFLAGS) -fopenmp-simd -o vec
	for k in 1 2 3 4; do \
		i=$$(echo 16 100 1000 10000| cut -d' ' -f$$k); \
		j=$$(echo 1000000 100000 10000 500| cut -d' ' -f$$k); \
		./vec -no_mol $$i -steps $$j > data/vec_results$$i.pragmas.txt
		echo "Running for i=$$i and steps=$$j and pragmas"; \
		gprof -p -b ./vec gmon.out > data/vec_analysis_$$i.pragmas.txt; \
	done

look_for_pragmas: clean vec seq 
	for k in 1 ; do \
		i=$$(echo 16 100 1000 10000| cut -d' ' -f$$k); \
		j=$$(echo 1000000 100000 10000 500| cut -d' ' -f$$k); \
		echo "Running for i=$$i and steps=$$j and no pragmas"; \
		./vec -no_mol $$i -steps $$j > data/vec_results$$i.nopragmas.txt; \
		gprof -p -b ./vec gmon.out > data/vec_analysis_$$i.nopragmas.txt; \
		./seq -no_mol $$i -steps $$j > data/seq_results$$i.nopragmas.txt; \
		done
		rm -fr seq vec
	$(CXX) Water_vectorised.cpp $(CXXFLAGS) -fopenmp-simd -o vec
	$(CXX) without_pragma_1.cc $(CXXFLAGS) -fopenmp-simd -o pragma1
	$(CXX) without_pragma_2.cc $(CXXFLAGS) -fopenmp-simd -o pragma2
	$(CXX) without_pragma_3.cc $(CXXFLAGS) -fopenmp-simd -o pragma3
	$(CXX) without_pragma_4.cc $(CXXFLAGS) -fopenmp-simd -o pragma4


	for k in 1 2 3 4; do \
		i=$$(echo 16 100 1000 10000| cut -d' ' -f$$k); \
		j=$$(echo 1000000 100000 10000 500| cut -d' ' -f$$k); \
		echo "Running for i=$$i and steps=$$j and pragmas"; \
		./vec -no_mol $$i -steps $$j > data/vec_results$$i.pragmas.txt; \
		gprof -p -b ./vec gmon.out > data/vec_analysis_$$i.pragmas.txt; \
		./pragma1 -no_mol $$i -steps $$j > data/pragma1_results$$i.pragma1.txt; \
		gprof -p -b ./pragma1 gmon.out > data/pragma1_analysis_$$i.pragma1.txt; \
		./pragma2 -no_mol $$i -steps $$j > data/pragma2_results$$i.pragma2.txt; \
		gprof -p -b ./pragma2 gmon.out > data/pragma2_analysis_$$i.pragma2.txt; \
		./pragma3 -no_mol $$i -steps $$j > data/pragma3_results$$i.pragma3.txt; \
		gprof -p -b ./pragma3 gmon.out > data/pragma3_analysis_$$i.pragma3.txt; \
		./pragma4 -no_mol $$i -steps $$j > data/pragma4_results$$i.pragma4.txt; \
		gprof -p -b ./pragma4 gmon.out > data/pragma4_analysis_$$i.pragma4.txt; \
	done
	
clean:
	rm -fr seq vec
