#include <iostream>
#include <cstdio>
#include <vector>

using namespace std;

struct tupla{
	long int index ;
	long int height;
};

long int find_max_distance(tupla* array,long int N);
tupla* readfromFilePair(char* name,long int *m);

int main(int argc,char** argv)
{	
	if(argc !=2){
		return 0;
	}
	long int N;
	tupla* find  = readfromFilePair(argv[1],&N);
	long int max_possible_path =find_max_distance(find,N);
	cout<<max_possible_path<<endl;
	return 0;
};



long int find_max_distance(tupla* array,long int N){
	long int max = 0;
	vector<tupla> min_sequence;
	vector<tupla> max_sequence;
	min_sequence.push_back(array[0]);
	max_sequence.push_back(array[N-1]);
	long int local_max = array[0].height;
	long int local_min = array[N-1].height;
	for(long int i=1;i<N;i++){
		if(local_max > array[i].height){
			min_sequence.push_back(array[i]);
			local_max =array[i].height;
		}
		if(local_min < array[N-1-i].height){
			local_min = array[N-1-i].height;
			max_sequence.push_back(array[N-1-i]);
			
		}
	}
	long int min_size = min_sequence.size();
	long int max_size = max_sequence.size();
	long int min_i=0,max_j=0;
	max = 0;
	long int guard = max_size-1;
	if(min_sequence[0].height < max_sequence[0].height)
		return max_sequence[0].index - min_sequence[0].index ;

	//Core of proccesing data

	for(min_i=0;min_i<min_size;min_i++){
		long int head = guard;
		for(max_j=guard;max_j>=0;max_j--){
			//Μake O(n) when first element of descending is >= of the first element
			if(max_sequence[head].height <= min_sequence[min_i].height){
				//guard = max_j - 1;
				//cout<<"I am inside "<<max_sequence[head].height<<endl;
				//cout<<guard<<endl;
				break;
			}
			if(min_sequence[min_i].height > max_sequence[max_j].height){
					//We have to be sure that previous stops are lower than you are
					if(max_sequence[max_j+1].height <= min_sequence[min_i].height)
						break;
					if(max < max_sequence[max_j+1].index - min_sequence[min_i].index){
						max	= max_sequence[max_j+1].index - min_sequence[min_i].index;
					}
					guard = max_j;
					break;
			}
			//Smaller than the smaller of the list -> Still can be reached
			if(max_j==0){
					if(max_sequence[max_j].height > min_sequence[min_i].height){
						if(max < max_sequence[max_j].index - min_sequence[min_i].index)
							max	= max_sequence[max_j].index - min_sequence[min_i].index;
					guard = max_j;
				}
			}
		}
	}	
	return max;
};
	

tupla* readfromFilePair(char* name,long int *m){
	FILE* pFile;
	pFile = fopen(name,"r+");
	int count_read = fscanf(pFile,"%ld",m);
	count_read ++; // Just to use count_read variable so no errors will occur
	tupla* my_pair = new tupla[*m];
	for(int i=0;i<(*m);i++){
		count_read = fscanf(pFile,"%ld",&my_pair[i].height);
		my_pair[i].index = i;
	}
	return my_pair;
};